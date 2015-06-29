
require "httpi"
require "logging"

require "bixby-common/util/log/filtering_layout"
require "bixby-common/util/log/logger"

module Bixby

  # A simple logging mixin
  module Log

    class << self

      def gems_regex
        return @gems_regex if @gems_regex
        gems_paths = (Gem.path | [Gem.default_dir]).map { |p| Regexp.escape(p) }
        gems_paths << "#{Gem.path.first}/bundler" # include path for gems installed via git repo
        @gems_regex = %r{(#{gems_paths.join('|')})/gems/([^/]+)-([\w.]+)/(.*)}
      end

      def bin_regex
        @bin_regex ||= %r{#{Gem.path.first}/(bin/.*)$}
      end

      def ruby_regex
        @ruby_regex ||= %r{^#{ENV["MY_RUBY_HOME"]}/lib(/.*?)?/ruby/[\d.]+/(.*)$}
      end

      # Check whether the given logger is configured to append to the console (STDOUT)
      #
      # @param [Logging::Logger] logger
      #
      # @return [Boolean] true if writing to STDOUT
      def console_appender?(logger)
        logger.appenders.each do |a|
          if a.kind_of? Logging::Appenders::Stdout then
            return true
          end
        end

        if logger.respond_to?(:parent) && logger.parent then
          return console_appender?(logger.parent)
        end

        false # at root
      end
      alias_method :console?, :console_appender?
      alias_method :stdout?,  :console_appender?

      def clean_ex_for_console(ex, logger)
        console?(logger) ? clean_ex(ex) : ex
      end

      # Created a cleaned up exception, suitable for printing to the console
      #
      # This method should generally only be used for debugging as it can be quite slow.
      #
      # @param [Exception] ex
      # @param [Boolean] exclude_gems          Whether or not to exclude all gems from the stacktrace (default: true)
      # @param [Boolean] exclude_dupes         When exclude_gems is set to false, omits duplicate gems from the stacktrace (default: true)
      #
      # @return [String]
      def clean_ex(ex, exclude_gems=true, exclude_dupes=true)
        puts self
        s = []
        s << "<#{ex.class}> #{ex.message}"

        last_gem = nil
        ex.backtrace.each do |e|
          if e =~ Log.gems_regex then
            next if exclude_gems
            gem_name = $2
            gem_ver  = $3
            trace    = $4
            gem_str = "#{gem_name} (#{gem_ver})"
            if !exclude_dupes || (last_gem.nil? || last_gem != gem_name) then
              s << "    #{gem_str} #{trace}"
            elsif exclude_dupes && last_gem == gem_name then
              # s << "    " + (" "*(gem_str.size+1)) + "..."
            end
            last_gem = gem_name

          elsif e =~ Log.bin_regex then
            next if exclude_gems
            rel_path = $1
            s << "    #{rel_path}"

          elsif e =~ Log.ruby_regex then
            next if exclude_gems
            last_gem = nil
            trace = $2
            s << "    ruby (#{RUBY_VERSION}) #{trace}"

          else
            s << "    #{e}"
          end
        end

        s.join("\n")
      end
    end

    # Get a log instance for this class
    #
    # @return [Logger]
    def log
      @log ||= Logging.logger[self]
    end
    alias_method :logger, :log

    # Create a method for each log level. Allows receiver to simply call
    #
    #   warn "foo"
    %w{debug warn info error fatal}.each do |level|
      code = <<-EOF
      def #{level}(data=nil, &block)
        log.send(:#{level}, data, &block)
      end
      EOF
      eval(code)
    end

    # Setup logging
    #
    # @param [Hash] opts                  Options for the rolling file appender
    # @option opts [String] :filename     Filename to log to
    # @option opts [Symbol] :level        Log level to use (default = :warn)
    # @option opts [String] :pattern      Log pattern
    def self.setup_logger(opts={})

      # set level: ENV flag overrides; default to warn
      opts[:level] = ENV["BIXBY_LOG"] if ENV["BIXBY_LOG"]

      if opts[:level].nil? then
        # try to read from config file
        c = Bixby.path("etc", "bixby.yml")
        if File.exists? c then
          if config = YAML.load_file(c) then
            log_level = config["log_level"]
            log_level = log_level.strip.downcase if log_level.kind_of? String
            opts[:level] = log_level
          end
        end
      end

      opts[:level] ||= :info

      pattern = opts.delete(:pattern) || '%.1l, [%d] %5l -- %c:%L: %m\n'
      layout = Logging.layouts.pattern(:pattern => pattern)

      opts[:filename] ||= Bixby.path("var", "bixby-agent.log")
      log_dir = File.dirname(opts[:filename])
      FileUtils.mkdir_p(log_dir)

      # make sure we have the correct permissions
      if Process.uid == 0 then
        if !File.exists? opts[:filename] then
          FileUtils.touch([opts[:filename], opts[:filename] + ".age"])
        end
        File.chmod(0777, log_dir)
        File.chmod(0777, opts[:filename])
        File.chmod(0777, opts[:filename] + ".age")
      end

      # configure stdout appender (used in debug modes, etc)
      Logging.color_scheme( 'bright',
        :levels => {
          :info  => :green,
          :warn  => :yellow,
          :error => :red,
          :fatal => [:white, :on_red]
        },
        :date => :blue,
        :logger => :cyan,
        :message => :magenta
      )
      Logging.appenders.stdout( 'stdout',
        :auto_flushing => true,
        :layout => Logging.layouts.pattern(
          :pattern => pattern,
          :color_scheme => 'bright'
        )
      )

      # configure rolling file appender
      options = {
        :keep          => 7,
        :roll_by       => 'date',
        :age           => 'daily',
        :truncate      => false,
        :auto_flushing => true,
        :layout        => layout
      }.merge(opts)
      Logging.appenders.rolling_file("file", options)

      root = Logging::Logger.root
      root.add_appenders("file") if !root.appenders.find{ |a| a.name == "file" }
      root.level = opts[:level]
      root.trace = true

      # setup HTTPI logger
      HTTPI.log = true
      HTTPI.logger = Logging.logger[HTTPI]
    end

  end # Log

end
