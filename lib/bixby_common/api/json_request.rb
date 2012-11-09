
module Bixby

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

  # Convert object to String, useful for debugging
  #
  # @return [String]
  def to_s
    s = []
    s << "JsonRequest:" + self.object_id.to_s
    s << "  operation:  " + self.operation
    s << "  params:     " + MultiJson.dump(self.params)
    s.join("\n")
  end

end # JsonRequest
end # Bixby
