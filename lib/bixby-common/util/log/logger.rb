
# Patch Logging::Logger so that :trace becomes an inherited flag

require "logging"

module Logging
  class Logger
    # :nocov:

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

    # :nocov:
  end

  module Appenders
    class RollingFile < ::Logging::Appenders::IO

      # Simple patch to DateRoller which uses the previous day's date for the rolled filename
      #
      # oneliner to fix incorrect dates from previously rolled files:
      # ruby -rtime -e '`ls *.2*.log`.split("\n").each{ |f| f =~ /(2015\d+)/; d = $1; dd = (Time.parse(d)-86400).strftime("%Y%m%d"); File.rename(f, f.gsub(/#{d}/, dd)) }'
      class DateRoller

        def roll_files
          return unless @roll and ::File.exist?(@fn_copy)

          # rename the copied log file
          ::File.rename(@fn_copy, (Time.now-86400).strftime(@logname_fmt))

          # prune old log files
          if @keep
            files = Dir.glob(@glob).find_all {|fn| @rgxp =~ fn}
            length = files.length
            if length > @keep
              files.sort {|a,b| b <=> a}.last(length-@keep).each {|fn| ::File.delete fn}
            end
          end

        ensure
          @roll = false
        end

      end
    end
  end
end

