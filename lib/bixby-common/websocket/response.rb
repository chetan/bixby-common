
module Bixby
  module WebSocket

    class Response < Message

      def initialize(json_response, id, headers=nil)
        if json_response.respond_to? :headers then
          headers = json_response.headers
        end
        super(id, "rpc_result", headers)

        @hash[:data] = json_response.to_wire
        @body = MultiJson.dump(@hash)
      end

      def json_response
        JsonResponse.from_json(body)
      end

    end

  end
end
