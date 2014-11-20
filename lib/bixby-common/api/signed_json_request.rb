
require "bixby-auth"

module Bixby
  class SignedJsonRequest < JsonRequest

    attr_accessor :headers

    def initialize(json_request, access_key=nil, secret_key=nil)
      @operation = json_request.operation
      @params = json_request.params
      @access_key = access_key
      @secret_key = secret_key
      @headers = {}
    end

    # api-auth requires a path
    def path
      "/api"
    end

    def body=(str)
      @body = str
    end

    def body
      if @body.nil? then
        hash = { :operation => operation, :params => params }
        @body = MultiJson.dump(hash)
      end
      return @body
    end

    def to_wire
      ApiAuth.sign!(self, @access_key, @secret_key)
      body
    end

  end
end
