
module Bixby
  class RpcHandler

    # Handle a request
    #
    # @param [JsonRequest] request
    #
    # @return [JsonResponse] response
    def handle(request)
      raise NotImplementedError
    end
  end
end
