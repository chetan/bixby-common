
module Bixby
  module WebSocket

    class Request < Message

      def initialize(json_request, id=nil, type="rpc", headers=nil)
        if json_request.respond_to? :headers then
          headers = json_request.headers
        end
        super(id, type, headers)

        @body = json_request.to_wire
      end

      def json_request
        JsonRequest.from_json(body)
      end

    end

  end
end
