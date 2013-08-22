
module Bixby
  module WebSocket

    class Request

      attr_reader :id, :type, :headers, :body

      def initialize(id, json_request)
        @id = id

        hash = { :type => "rpc", :id => id, :data => json_request.to_wire }
        if json_request.respond_to? :headers then
          @headers = hash[:headers] = json_request.headers
        end

        @body = MultiJson.dump(hash)
      end

      def self.from_wire(body)
        obj = MultiJson.load(body)

        req = Request.allocate
        req.instance_eval do
          @id = obj["id"]
          @type = obj["type"]
          @body = obj["data"]
          if obj.include? "headers" then
            @headers = obj["headers"]
          end
        end

        return req
      end

      def json_request
        JsonRequest.from_json(body)
      end

      def to_wire
        @body
      end

    end

  end
end
