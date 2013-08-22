
module Bixby

  class HttpChannel < Bixby::APIChannel

    def initialize(uri)
      @uri = uri
    end

    # Execute the given request
    #
    # @param [JsonRequest] json_request
    #
    # @return [JsonResponse] response
    def execute(json_request)
      execute_internal(json_request)
    end


    # Execute a download request
    # NOTE: This method is only available on the HTTP Channel.
    #
    # @param [JsonRequest] json_request
    # @param [Block] block
    #
    # @return [JsonResponse] response
    def execute_download(json_request, &block)
      execute_internal(json_request, &block)
    end


    private

    # Execute the request, optionally passing a block to handle the response
    #
    # @param [JsonRequest] json_request
    # @param [Block] block
    #
    # @return [JsonResponse] response
    def execute_internal(json_request, &block)

      req = HTTPI::Request.new(:url => @uri, :body => json_request.to_wire)

      # add in extra headers if we have a SignedJsonRequest (or anything which has additional headers)
      if json_request.respond_to? :headers then
        req.headers.merge!(json_request.headers)
      end

      if not req.headers.include? "Content-Type" then
        # add content-type if not set
        # may be set when creating a signed request
        req.headers["Content-Type"] = "application/json"
      end

      if block then
        # execute request with block
        req.on_body(&block)
        HTTPI.post(req)
        return JsonResponse.new("success")

      else
        # execute normal req, and return parsed response
        res = HTTPI.post(req).body
        return JsonResponse.from_json(res)
      end


    end


  end
end
