
module Bixby
  module WebSocket

    class Request < Message

      def initialize(id, json_request, type = "rpc")
        super(id, type)
        if json_request.respond_to? :headers then
          @headers = @hash[:headers] = json_request.headers
        else
          @headers = @hash[:headers] = []
        end
        @hash[:data] = json_request.to_wire
        @body = MultiJson.dump(@hash)
      end

      def json_request
        JsonRequest.from_json(body)
      end

    end

  end
end
