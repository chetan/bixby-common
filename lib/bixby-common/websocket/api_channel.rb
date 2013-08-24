
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
      def execute_async(json_request)
        request = Request.new(json_request)
        id = request.id
        @responses[id] = AsyncResponse.new(id)

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
        # TODO extract Agent ID, if Agent
        logger.debug "new channel opened"
        @connected = true
      end

      # Close
      #
      # Can be fired either due to disconnection or failure to connect
      def close(event)
        if @connected then
          logger.debug "client disconnected"
          @connected = false
          @handler.new(nil).disconnect(self)
        end
      end

      # Message
      #
      # Fired whenever a message is received on the channel
      def message(event)
        logger.debug "got a message:\n#{event.data}"
        req = Message.from_wire(event.data)

        if req.type == "rpc" then
          # Execute the requested method and return the result
          json_response = @handler.new(req).handle(req.json_request)

          # result = { :type => "rpc_result", :id => req.id, :data => json_response }
          # ws.send(MultiJson.dump(result))
          ws.send(Response.new(json_response, req.id).to_wire)

        elsif req.type == "rpc_result" then
          # Pass the result back to the caller
          @responses[req.id].response = JsonResponse.from_json(req.body)

        elsif req.type == "connect" then
          @handler.new(req).connect(req.json_request, self)

        end
      end

    end

  end
end
