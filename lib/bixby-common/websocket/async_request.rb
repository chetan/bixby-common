
require 'thread'

module Bixby
  module WebSocket

    class AsyncRequest

      attr_reader :id, :headers
      attr_accessor :body

      def initialize(id, json_request)
        @id = id
        @json_request = json_request
        @body = MultiJson.dump(@json_request)
        @headers = {}
        @mutex = Mutex.new
        @cond = ConditionVariable.new
        @response = nil
        @completed = false
      end

      def json_request
        return JsonRequest.from_json(body)
      end

      # Set the response and signal any blocking threads
      #
      # @param [Object] obj       result of request, usually a JsonResponse
      def response=(obj)
        @mutex.synchronize {
          @completed = true
          @response = obj
          @cond.signal
        }
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
        return @response if @completed
        @mutex.synchronize { @cond.wait(@mutex) }
        return @response
      end

      def to_wire_format
        hash = { :type => "rpc", :id => id, :headers => headers, :data => body }
      end

    end

  end
end
