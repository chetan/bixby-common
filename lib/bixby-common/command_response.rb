
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
      cr.stderr ||= res.message
    end
    return cr
  end

  # Create a JsonResponse from this CommandResponse
  #
  # @return [JsonResponse]
  def to_json_response
    return JsonResponse.new((status == 0 ? "success" : "fail"), nil, self.to_hash)
  end

  def initialize(params = nil)
    if params.kind_of? Hash then
      params.each{ |k,v| self.send("#{k}=", v) if self.respond_to? "#{k}=" }

    elsif params.class.to_s == "Mixlib::ShellOut" then
      @status = params.exitstatus
      @stdout = params.stdout
      @stderr = params.stderr
    end
  end

  def success?
    @status.to_i == 0
  end

  def fail?
    not success?
  end
  alias_method :error?, :fail?

  def raise!
    if fail? then
      msg = stdout || ""
      msg += "\n" if !(stdout.nil? or stdout.empty?)
      msg += stderr || ""
      raise CommandException.new(msg, msg)
    end
  end

  def decode # :nocov:
    MultiJson.load(@stdout)
  end # :nocov:

  def decode_stderr # :nocov:
    MultiJson.load(@stderr)
  end # :nocov:

  # Convert object to String, useful for debugging
  #
  # @return [String]
  def to_s # :nocov:
    s = []
    s << "CommandResponse:#{self.object_id}"
    s << "  status:   #{self.status}"
    s << "  stdout:   " + Debug.pretty_str(stdout)
    s << "  stderr:   " + Debug.pretty_str(stderr)
    s.join("\n")
  end # :nocov:

end # CommandResponse
end # Bixby
