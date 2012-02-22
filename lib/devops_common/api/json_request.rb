
# Wraps a JSON Request
#
# @attr [String] operation  Name of operation
# @attr [Array] params  Array of paramters; must be valid JSON types
class JsonRequest

    include Jsonify
    include HttpClient

    attr_accessor :operation, :params

    # Create a new JsonRequest
    #
    # @param [String] operation  Name of operation
    # @param [Array] params  Array of parameters; must ve valid JSON types
    def initialize(operation, params)
        @operation = operation
        @params = params
    end

    # Executes the request and returns a JsonResponse
    #
    # @param [String] uri  URI to post to (default: manager uri, see HttpClient#api_uri)
    # @return [JsonResponse]
    def exec(uri = nil)
        uri ||= api_uri
        begin
            return JsonResponse.from_json(http_post_json(uri, self.to_json))
        rescue Curl::Err::ConnectionFailedError => ex
            return JsonResponse.new("fail", ex.message, ex.backtrace)
        end
    end

    # Download the file specified by this request and save it to download_path
    #
    # @param [String] download_path  Location to write file to
    # @return [void]
    def exec_download(download_path, uri = nil)
        uri ||= api_uri
        http_post_download(uri, self.to_json, download_path)
    end
end
