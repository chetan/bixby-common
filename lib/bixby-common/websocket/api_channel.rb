
require "bixby-common/websocket/async_response"
require "api-auth"

module Bixby
  module WebSocket

    # WebSocket API channel
    #
    # Implements a simple request/response interface over a WebSocket channel.
    # Requests can be sent in either direction, in a sync or async manner.
    class APIChannel < Bixby::APIChannel

      attr_reader :ws

      def initialize(ws, handler)
        @ws = ws
        @handler = handler
        @responses = {}
        @connected = false
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
        logger.debug { "execute_async:\n#{json_request.to_s}" }

        request = Request.new(json_request)
        id = request.id
        @responses[id] = AsyncResponse.new(id, &block)

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
        @connected = true
      end

      # Close
      #
      # Can be fired either due to disconnection or failure to connect
      def close(event)
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
        logger.debug { "new '#{req.type}' message" }

        if req.type == "rpc" then
          # Execute the requested method and return the result
          json_req = req.json_request
          logger.debug { json_req.to_s }
          json_response = @handler.new(req).handle(json_req)

          # result = { :type => "rpc_result", :id => req.id, :data => json_response }
          # ws.send(MultiJson.dump(result))
          ws.send(Response.new(json_response, req.id).to_wire)

        elsif req.type == "rpc_result" then
          # Pass the result back to the caller
          res = req.json_response
          logger.debug { res.to_s }
          @responses[req.id].response = res

        elsif req.type == "connect" then
          @handler.new(req).connect(req.json_request, self)

        end
      end

    end

  end
end
