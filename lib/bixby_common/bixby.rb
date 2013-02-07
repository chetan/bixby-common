
module Bixby
  class << self
    attr_accessor :manager_uri

    def repo_path
      path("repo")
    end

    # Path to BIXBY_HOME
    def root
      @root ||= ENV["BIXBY_HOME"]
    end
    alias_method :home, :root

    # Helper for creating absolute paths inside BIXBY_HOME
    def path(*args)
      File.expand_path(File.join(root, *args))
    end


  end
end
