
class CommandResponse

  include Jsonify

  attr_accessor :status, :stdout, :stderr

  def initialize(params = nil)
    return if params.nil? or params.empty?
    params.each{ |k,v| self.send("#{k}=", v) if self.respond_to? "#{k}=" }
  end

  def success?
    @status.to_i == 0
  end

  def error?
    not success?
  end

end
