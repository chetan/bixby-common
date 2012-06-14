
require 'tempfile'

require 'systemu'

module Bixby
class CommandSpec

  include Jsonify
  include Hashify

  attr_accessor :repo, :digest, :bundle, :command, :args, :stdin, :env

  # Create new CommandSpec
  #
  # @params [Hash] params  Hash of attributes to initialize with
  def initialize(params = nil)
    return if params.nil? or params.empty?
    params.each{ |k,v| self.send("#{k}=", v) if self.respond_to? "#{k}=" }

    digest = load_digest()
    @digest = digest["digest"] if digest
  end

  # Execute this command
  #
  # @param [String] cmd  Command string to execute
  #
  # @return [Array<FixNum, String, String>] status, stdout, stderr
  def execute
    if @stdin and not @stdin.empty? then
      temp = Tempfile.new("input-")
      temp << @stdin
      temp.flush
      temp.close
      cmd = "sh -c 'cat #{temp.path} | #{self.command_file}"
    else
      cmd = "sh -c '#{self.command_file}"
    end
    cmd += @args ? " #{@args}'" : "'"

    status, stdout, stderr = system_exec(cmd)
  end

  # Validate the existence of this Command on the local system
  #
  # @return [Boolean] returns true if available, else raises error
  # @raise [BundleNotFound]
  # @raise [CommandNotFound]
  def validate
    if not bundle_exists? then
      raise BundleNotFound.new("repo = #{@repo}; bundle = #{@bundle}")
    end

    if not command_exists? then
      raise CommandNotFound.new("repo = #{@repo}; bundle = #{@bundle}; command = #{@command}")
    end
    return true
  end

  # resolve the given bundle
  def bundle_dir
    if @repo == "local" and Module.constants.include? :AGENT_ROOT then
      # only resolve the special "local" repo for Agents
      return File.expand_path(File.join(AGENT_ROOT, "../repo", @bundle))
    end
    File.join(BundleRepository.path, self.relative_path)
  end

  def relative_path
    File.join(@repo, @bundle)
  end

  def bundle_exists?
    File.exists? self.bundle_dir
  end

  def command_file
    File.join(self.bundle_dir, "bin", @command)
  end

  def command_exists?
    File.exists? self.command_file
  end

  def config_file
    command_file + ".json"
  end

  def load_config
    if File.exists? config_file then
      MultiJson.load(File.read(config_file))
    else
      {}
    end
  end

  def digest_file
    File.join(self.bundle_dir, "digest")
  end

  def load_digest
    begin
      return MultiJson.load(File.read(digest_file))
    rescue => ex
    end
    nil
  end

  def update_digest

    path = self.bundle_dir
    sha = Digest::SHA2.new
    bundle_sha = Digest::SHA2.new

    digests = []
    Dir.glob("#{path}/**/*").sort.each do |f|
      next if File.directory? f || File.basename(f) == "digest"
      bundle_sha.file(f)
      sha.reset()
      digests << { :file => f.gsub(/#{path}\//, ''), :digest => sha.file(f).hexdigest() }
    end

    @digest = { :digest => bundle_sha.hexdigest(), :files => digests }
    File.open(path+"/digest", 'w'){ |f| f.write(MultiJson.dump(@digest, :pretty => true) + "\n") }

  end


  private

  # Cleanup the ENV before executing command
  #
  # @param [String] cmd  Command string to execute
  #
  # @return [Array<FixNum, String, String>] status, stdout, stderr
  def system_exec(cmd)
    rem = [ "BUNDLE_BIN_PATH", "BUNDLE_GEMFILE", "RUBYOPT" ]
    old_env = {}
    rem.each{ |r| old_env[r] = ENV.delete(r) }
    status, stdout, stderr = systemu(cmd)
    rem.each{ |r| ENV[r] = old_env[r] if old_env[r] }

    return [ status, stdout, stderr ]
  end

end # CommandSpec
end # Bixby
