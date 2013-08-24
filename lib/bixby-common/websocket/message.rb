
module Bixby
  module WebSocket

    class Message

      attr_reader :id, :type, :headers, :body

      def initialize(id=nil, type="rpc", headers=nil)
        @id = id || SecureRandom.uuid
        @type = type
        @hash = { :type => @type, :id => @id }

        headers ||= {}
        @headers = @hash[:headers] = headers
      end

      def self.from_wire(body)
        obj = MultiJson.load(body)

        clazz = case obj["type"]
        when "rpc", "connect"
          Request
        when "rpc_result"
          Response
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
