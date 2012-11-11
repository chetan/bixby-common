
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
    cr = CommandResponse.new(res.data)
    if res.message then
      cr.status ||= 255
      cr.stderr = res.message
    end
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

  # Convert object to String, useful for debugging
  #
  # @return [String]
  def to_s
    s = []
    s << "CommandResponse:#{self.object_id}"
    s << "  status:   #{self.status}"
    s << "  stdout:   <<-EOF"
    s << self.stdout if self.stdout and not self.stdout.empty?
    s << "EOF"
    s << "  stderr:   <<-EOF"
    s << self.stderr if self.stderr and not self.stderr.empty?
    s << "EOF"
    s.join("\n")
  end

end # CommandResponse
end # Bixby
