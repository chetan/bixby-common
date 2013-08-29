
# Patch Logging::Logger so that :trace becomes an inherited flag

module Logging
  class Logger

    # Override to pass trace flag from parent to child
    def initialize( name )
      case name
      when String
        raise(ArgumentError, "logger must have a name") if name.empty?
      else raise(ArgumentError, "logger name must be a String") end

      repo = ::Logging::Repository.instance
      parent = repo.parent(name)
      _setup(name, :parent => parent, :trace => parent.trace)
    end

  end
end

