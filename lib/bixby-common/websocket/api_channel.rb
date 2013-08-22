
require "bixby-common/websocket/async_response"
require "api-auth"

module Bixby
  module WebSocket

    # WebSocket API channel
    #
    # Implements a simple request/response interface over a WebSocket channel.
    # Requests can be sent in either direction, in a sync or async manner.
    class APIChannel

      include Bixby::Log
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
        id = SecureRandom.uuid
        @responses[id] = AsyncResponse.new(id)

        EM.next_tick {
          hash = { :type => "rpc", :id => id, :data => json_request.to_wire }
          ws.send(MultiJson.dump(hash))
        }
        id
      end

      # Fetch the response for the given request
      #
      # @param [String] request id
      #
      # @return [Object] JsonResponse
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
        end
      end

      # Message
      #
      # Fired whenever a message is received on the channel
      def message(event)
        logger.debug "got a message:\n#{event.data}"
        cmd = MultiJson.load(event.data)

        if cmd["type"] == "rpc" then
          json_response = do_rpc(cmd)
          # wrap response & send
          result = { :type => "rpc_result", :id => cmd["id"], :data => json_response }
          ws.send(MultiJson.dump(result))

        elsif cmd["type"] == "rpc_result" then
          do_result(cmd)
        end
      end


      private

      # Execute the requested method and return the result
      def do_rpc(cmd)
        @handler.new(nil).handle(cmd["data"])
      end

      # Pass the result back to the caller
      def do_result(cmd)
        id = cmd["id"]
        @responses[id].response = cmd["data"]
      end

    end

  end
end
