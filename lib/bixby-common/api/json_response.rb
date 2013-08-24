
module Bixby

# Wraps a JSON Response
#
# @attr [String] status  Status of operaiton ("success" or "fail")
# @attr [String] message  Response message
# @attr [Hash] data  Response data as key/value pairs
# @attr [FixNum] code  Response code
class JsonResponse

  include Jsonify

  attr_accessor :status, :message, :data, :code

  SUCCESS = "success"
  FAIL    = "fail"

  # Create a new JsonResponse
  #
  # @param [String] status  Status of operaiton ("success" or "fail")
  # @param [String] message  Response message
  # @param [Hash] data  Response data as key/value pairs
  # @param [FixNum] code  Response code
  def initialize(status = nil, message = nil, data = nil, code = nil)
    @status = status
    @message = message
    @data = data
    @code = code
  end

  # Was operation successful?
  #
  # @return [Boolean] True if @status == "success"
  def success?
    @status && @status == SUCCESS
  end

  # Was operation unsuccessful?
  #
  # @return [Boolean] True if @status != "success"
  def fail?
    @status && @status == FAIL
  end
  alias_method :error?, :fail?

  # Create a JsonResponse representing an invalid request
  #
  # @param [String] msg Optional message (default: "invalid request")
  def self.invalid_request(msg = nil) # :nocov:
    new("fail", (msg || "invalid request"), nil, 400)
  end # :nocov:

  # Create a JsonResponse indicating "bundle not found"
  #
  # @param [String] bundle  Name of bundle
  def self.bundle_not_found(bundle) # :nocov:
    new("fail", "bundle not found: #{bundle}", nil, 404)
  end # :nocov:

  # Create a JsonResponse indicating "command not found"
  #
  # @param [String] command  Name of command
  def self.command_not_found(command) # :nocov:
    new("fail", "command not found: #{command}", nil, 404)
  end # :nocov:

  # Convert object to String, useful for debugging
  #
  # @return [String]
  def to_s # :nocov:
    s = []
    s << "JsonResponse:#{self.object_id}"
    s << "  status:   #{self.status}"
    s << "  code:     #{self.code}"
    s << "  message:  #{self.message}"
    s << "  data:     " + MultiJson.dump(self.data)
    s.join("\n")
  end # :nocov:

  def to_wire
    MultiJson.dump(self)
  end

end # JsonResponse

end # Bixby
