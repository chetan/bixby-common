
module Bixby

  class APIChannel

    include Bixby::Log
    extend  Bixby::Log

    # Execute the given request
    #
    # @param [JsonRequest] json_request
    #
    # @return [JsonResponse] response
    def execute(json_request)
      raise NotImplementedError
    end

  end

end
