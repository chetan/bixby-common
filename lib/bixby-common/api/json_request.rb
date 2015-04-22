
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

  # Stringify, useful for debugging
  #
  # @param [Boolean] include_params         whether or not to include params in the output (default: true)
  #
  # @return [String]
  def to_s(include_params=true)
    s = []
    s << "JsonRequest:#{self.object_id}"
    s << "  operation:  #{self.operation}"
    s << "  params:     " + MultiJson.dump(self.params) if include_params
    s.join("\n")
  end

  def to_wire
    MultiJson.dump(self)
  end

  # Test if this object is equal to some other object
  #
  # @param [JsonRequest] other
  #
  # @return [Boolean]
  def ==(other)
    operation == other.operation && params == other.params
  end

end # JsonRequest
end # Bixby
