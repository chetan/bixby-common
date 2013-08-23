
module Bixby
  module WebSocket

    class Message

      attr_reader :id, :type, :headers, :body

      def initialize(id, type = "rpc")
        @id = id
        @hash = { :type => type, :id => id }
      end

      def self.from_wire(body)
        obj = MultiJson.load(body)

        clazz = case obj["type"]
        when "rpc"
        when "connect"
          Request
        when "rpc_result"
          Repsonse
        end

        req = clazz.allocate
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

      def to_wire
        @body
      end

    end

  end
end
