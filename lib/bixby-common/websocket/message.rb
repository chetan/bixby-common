
module Bixby
  module WebSocket

    class Message

      attr_reader :id, :type, :headers, :body

      def initialize(id=nil, type="rpc", headers=nil)
        @id = id || SecureRandom.uuid
        @type = type
        @headers = headers || {}
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
        hash = { :type    => @type,
                 :id      => @id,
                 :headers => @headers,
                 :data    => @body }

        MultiJson.dump(hash)
      end

      # Convert object to String, useful for debugging
      #
      # @return [String]
      def to_s # :nocov:
        s = []
        s << "#{self.class}:#{self.object_id}"
        s << "  id:       #{self.id}"
        s << "  type:     #{self.type}"
        s << "  headers:  " + Debug.pretty_hash(self.headers)
        s << "  body:     " + Debug.pretty_hash(MultiJson.load(self.body))
        s.join("\n")
      end # :nocov:

    end

  end
end
