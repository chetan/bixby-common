
require 'thread'

module Bixby
  module WebSocket

    # Asynchronously receive a response via some channel
    class AsyncResponse

      attr_reader :id

      # Create a new AsyncResponse. Optionally pass a callback block which will
      # be fired when the response is set.
      #
      # @param [String] id
      #
      # @yieldparam [JsonResponse] response
      #
      # @return [AsyncResponse]
      def initialize(id, &block)
        @id = id
        @block = block
        @mutex = Mutex.new
        @cond = ConditionVariable.new
        @response = nil
        @completed = false
      end

      # Set the response and signal any blocking threads. Triggers callback, if
      # one was set.
      #
      # @param [Object] obj       result of request, usually a JsonResponse
      def response=(obj)
        @mutex.synchronize {
          @response = obj
          @completed = true
          @cond.broadcast
        }

        if not @block.nil? then
          @block.call(@response)
        end
      end

      # Has the request completed?
      #
      # @return [Boolean] true if completed
      def completed?
        @completed
      end

      # Retrieve the response, blocking until it is available
      #
      # @return [Object] response data
      def response
        @mutex.synchronize {
          if !@completed then
            @cond.wait(@mutex)
          end
        }
        return @response
      end

    end

  end
end
