
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

    # Channel connect event
    #
    # NOTE: only used by WebSocket channels and generally only implemented by
    #       the server-side.
    #
    # @param [Bixby::JsonRequest] json_req
    # @param [Bixby::APIChannel] api
    def connect(json_req, api)
      # no-op
    end

    # Channel disconnection event
    # NOTE: only used by WebSocket channels and generally only implemented by
    #       the server-side.
    #
    # @param [Bixby::APIChannel] api
    def disconnect(api)
      # no-op
    end

  end
end
