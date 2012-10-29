
module Bixby
class CommandResponse

  include Jsonify

  attr_accessor :status, :stdout, :stderr

  # Create a new CommandResponse from the given from_json_response
  #
  # @param [JsonResponse] res
  #
  # @return [CommandResponse]
  def self.from_json_response(res)
    cr = CommandResponse.new
    cr.status = res.code || 255
    cr.stderr = res.message
    return cr
  end

  def initialize(params = nil)
    return if params.nil? or params.empty?
    params.each{ |k,v| self.send("#{k}=", v) if self.respond_to? "#{k}=" }
  end

  def success?
    @status.to_i == 0
  end

  def fail?
    not success?
  end
  alias_method :error?, :fail?

  def decode
    MultiJson.load(@stdout)
  end

  def decode_stderr
    MultiJson.load(@stderr)
  end

end # CommandResponse
end # Bixby
