
require "bixby-common/websocket/async_request"
require "api-auth"

module Bixby
  module WebSocket

    # WebSocket API channel
    #
    # Implements a simple request/response interface over a WebSocket channel.
    # Requests can be sent in either direction, in a sync or async manner.
    class API

      include Bixby::Log
      attr_reader :ws

      def initialize(ws, handler)
        @ws = ws
        @handler = handler
        @requests = {}
        @connected = false
      end

      # Perform RPC

      # Perform the given RPC request and return the response
      #
      # @param [String] operation
      # @param [Array] params
      #
      # @return [Object] JsonResponse
      def rpc(operation, params)
        fetch_response( async_rpc(operation, params) )
      end

      # Make an asynchronous RPC request
      #
      # @param [String] operation
      # @param [Array] params
      #
      # @return [String] request id
      def async_rpc(operation, params)
        id = SecureRandom.uuid
        json_req = JsonRequest.new(operation, params)
        req = @requests[id] = AsyncRequest.new(id, json_req)

        EM.next_tick {
          ws.send(req.to_wire_format)
        }
        id
      end

      # Fetch the response for the given request
      #
      # @param [String] request id
      #
      # @return [Object] JsonResponse
      def fetch_response(id)
        res = @requests[id].response
        @requests.delete(id)
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
        logger.debug "got a message: #{event.data.ai}"
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
        @handler.handle(cmd["data"])
      end

      # Pass the result back to the caller
      def do_result(cmd)
        id = cmd["id"]
        @requests[id].response = cmd["data"]
      end

    end

  end
end
