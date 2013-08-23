
module Bixby
  module WebSocket

    class Response < Message

      def initialize(id, json_response)
        super(id, "rpc_result")
        if json_response.respond_to? :headers then
          @headers = @hash[:headers] = json_response.headers
        else
          @headers = @hash[:headers] = []
        end
        @hash[:data] = json_response.to_wire
        @body = MultiJson.dump(@hash)
      end

      def json_response
        JsonResponse.from_json(body)
      end

    end

  end
end
