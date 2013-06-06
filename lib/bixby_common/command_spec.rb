
require 'digest'
require 'tempfile'

module Bixby

# Describes a Command execution request for the Agent
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

  # Validate the existence of this Command on the local system
  # and compare digest to local version
  #
  # @param [String] expected_digest
  # @return [Boolean] returns true if available, else raises error
  # @raise [BundleNotFound] If bundle doesn't exist or digest does not match
  # @raise [CommandNotFound] If command doesn't exist
  def validate(expected_digest)
    if not bundle_exists? then
      raise BundleNotFound.new("repo = #{@repo}; bundle = #{@bundle}")
    end

    if not command_exists? then
      raise CommandNotFound.new("repo = #{@repo}; bundle = #{@bundle}; command = #{@command}")
    end
    if self.digest != expected_digest then
      raise BundleNotFound, "digest does not match ('#{self.digest}' != '#{expected_digest}')", caller
    end
    return true
  end

  # resolve the given bundle
  def bundle_dir
    File.expand_path(File.join(Bixby.repo_path, self.relative_path))
  end

  # Return the relative path to the bundle (inside the repository)
  #
  # e.g., if Bixby.repo_path = /opt/bixby/repo then a relative path would
  #       look like:
  #
  #         vendor/system/monitoring
  #         or
  #         megacorp/sysops/scripts
  #
  # @return [String]
  def relative_path
    File.join(@repo, @bundle)
  end

  def bundle_exists?
    File.exists? self.bundle_dir
  end

  def command_file
    path("bin", @command)
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
    path("digest")
  end

  def load_digest
    begin
      return MultiJson.load(File.read(digest_file))
    rescue => ex
    end
    nil
  end

  def load_manifest
    begin
      return MultiJson.load(path("manifest.json"))
    rescue => ex
    end
    nil
  end

  # Create and return an absolute pathname pointing to the given file
  #
  # @param [String] *relative
  #
  # @return [String]
  def path(*relative)
    File.join(self.bundle_dir, *relative)
  end

  def update_digest

    path = self.bundle_dir
    sha = Digest::SHA2.new
    bundle_sha = Digest::SHA2.new

    digests = []
    Dir.glob("#{path}/**/*").sort.each do |f|
      next if File.directory?(f) || File.basename(f) == "digest" || f =~ /^#{path}\/test/
      bundle_sha.file(f)
      sha.reset()
      digests << { :file => f.gsub(/#{path}\//, ''), :digest => sha.file(f).hexdigest() }
    end

    @digest = { :digest => bundle_sha.hexdigest(), :files => digests }
    MultiJson.load_adapter(:json_gem).activate!
    File.open(path+"/digest", 'w'){ |f|
      f.write(MultiJson.dump(@digest, :pretty => true, :adapter => :json_gem) + "\n")
    }

  end

  # Convert object to String, useful for debugging
  #
  # @return [String]
  def to_s # :nocov:
    s = []
    s << "CommandSpec:#{self.object_id}"
    s << "  digest:   #{self.digest}"
    s << "  repo:     #{self.repo}"
    s << "  bundle:   #{self.bundle}"
    s << "  command:  #{self.command}"
    s << "  args:     #{self.args}"
    s << "  env:      " + MultiJson.dump(self.env)
    s << "  stdin:    " + Debug.pretty_str(stdin)
    s.join("\n")
  end # :nocov:

end # CommandSpec
end # Bixby
