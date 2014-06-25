
require 'digest'
require 'tempfile'

module Bixby

# Describes a Command execution request for the Agent
class CommandSpec

  include Jsonify
  include Hashify

  attr_accessor :digest, :repo, :bundle, :command, :args, :stdin, :env,
                :user, :group

  # Create new CommandSpec
  #
  # @param [Hash] params  Hash of attributes to initialize with
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

  # Check if the bundle described by this CommandSpec exists
  #
  # @return [Boolean]
  def bundle_exists?
    File.exists? self.bundle_dir
  end

  # Absolute command filename
  #
  # @return [String]
  def command_file
    path("bin", @command)
  end

  # Check if the command file exists
  #
  # @return [Boolean]
  def command_exists?
    File.exists? self.command_file
  end

  # Command manifest filename
  #
  # @return [String]
  def manifest_file
    command_file + ".json"
  end
  alias_method :config_file, :manifest_file

  # Retrieve the command's Manifest, loading it from disk if necessary
  # If no Manifest is available, returns an empty hash
  #
  # @return [Hash]
  def manifest
    if File.exists?(manifest_file) && File.readable?(manifest_file) then
      MultiJson.load(File.read(manifest_file))
    else
      {}
    end
  end
  alias_method :load_config, :manifest

  # Bundle digest filename
  #
  # @return [String] path to bundle digest file
  def digest_file
    path("digest")
  end

  # Retrieve the bundle digest
  #
  # @return [Hash]
  def load_digest
    begin
      return MultiJson.load(File.read(digest_file))
    rescue => ex
    end
    nil
  end

  # Retrieve the bundle manifest
  #
  # @return [Hash]
  def load_bundle_manifest
    begin
      return MultiJson.load(File.read(path("manifest.json")))
    rescue => ex
    end
    nil
  end
  alias_method :load_manifest, :load_bundle_manifest

  # Create and return an absolute pathname pointing to the given file
  #
  # @param [String] *relative
  #
  # @return [String]
  def path(*relative)
    File.join(self.bundle_dir, *relative)
  end

  # Update the digest hashes for this bundle
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
    s << "  user:     #{self.user}"
    s << "  group:    #{self.group}"
    s << "  env:      " + (self.env.nil?() ? "" : MultiJson.dump(self.env))
    s << "  stdin:    " + Debug.pretty_str(stdin)
    s.join("\n")
  end # :nocov:

end # CommandSpec
end # Bixby
