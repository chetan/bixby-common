
require "bixby-common/websocket/async_response"

require "bixby-auth"
require "eventmachine"

module Bixby
  module WebSocket

    # WebSocket API channel
    #
    # Implements a simple request/response interface over a WebSocket channel.
    # Requests can be sent in either direction, in a sync or async manner.
    class APIChannel < Bixby::APIChannel

      attr_reader :ws

      def initialize(ws, handler, thread_pool)
        @ws = ws
        @handler = handler
        @responses = {}
        @connected = false
        @thread_pool = thread_pool
      end

      # Perform RPC

      # Execute the given request (synchronously)
      #
      # @param [JsonRequest] json_request
      #
      # @return [JsonResponse] response
      def execute(json_request)
        fetch_response( execute_async(json_request) )
      end

      # Execute the given request (asynchronously)
      #
      # @param [JsonRequest] json_request
      #
      # @return [String] request id
      def execute_async(json_request, &block)
        if json_request.kind_of? Request then
          id, request = json_request.id, json_request
        else
          request = Request.new(json_request)
          id = request.id
        end
        @responses[id] = AsyncResponse.new(id, &block)

        logger.debug { request.type == "connect" ? "execute_async: CONNECT [#{id}]" : "execute_async: RPC [#{id}]\n#{request.to_s}" }

        EM.next_tick {
          ws.send(request.to_wire)
        }
        id
      end

      # Fetch the response for the given request
      #
      # @param [String] request id
      #
      # @return [JsonResponse]
      def fetch_response(id)
        res = @responses[id].response
        @responses.delete(id)
        res
      end


      # Handle channel events

      def connected?
        @connected
      end

      # Open
      def open(event)
        if event && !event.target.kind_of?(Faye::WebSocket::Client) then
          logger.debug { "opened connection from #{event.target.env["REMOTE_ADDR"]}" }
        end
        @connected = true
      end

      # Close
      #
      # Can be fired either due to disconnection or failure to connect
      def close(event)
        if event && !event.target.kind_of?(Faye::WebSocket::Client) then
          logger.debug { "closed connection from #{event.target.env["REMOTE_ADDR"]} (code=#{event.code}; reason=\"#{event.reason}\")" }
        end
        if @connected then
          @connected = false
          @handler.new(nil).disconnect(self)
        end
      end

      # Message
      #
      # Fired whenever a message is received on the channel
      def message(event)
        req = Message.from_wire(event.data)

        if req.type == "rpc" then
          # Execute the requested method and return the result
          # Do it asynchronously so as not to hold up the EM-loop while the command is running
          @thread_pool.perform do
            json_req = req.json_request
            logger.debug { "RPC request\n#{json_req}" }
            json_response = @handler.new(req).handle(json_req)
            EM.next_tick { ws.send(Response.new(json_response, req.id).to_wire) }
          end

        elsif req.type == "rpc_result" then
          # Pass the result back to the caller
          res = req.json_response
          logger.debug { "RPC_RESULT for request id [#{req.id}]\n#{res}" }
          @responses[req.id].response = res

        elsif req.type == "connect" then
          # Agent request to CONNECT to the manager
          # will only be received by the server-end of the channel
          logger.debug { "CONNECT request #{req.id}"}
          ret = @handler.new(req).connect(req.json_request, self)
          if ret.kind_of? JsonResponse then
            ws.send(Response.new(ret, req.id).to_wire)
          else
            ws.send(Response.new(JsonResponse.new("success"), req.id).to_wire)
          end

        end
      end

    end

  end
end
