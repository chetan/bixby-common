
require "logging"

require "bixby-common/util/log/filtering_layout"
require "bixby-common/util/log/logger"

module Bixby

  # A simple logging mixin
  module Log

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
      opts[:level] = :debug if ENV["BIXBY_DEBUG"]
      opts[:level] ||= :warn

      pattern = opts.delete(:pattern) || '%.1l, [%d] %5l -- %c:%L: %m\n'
      layout = Logging.layouts.pattern(:pattern => pattern)

      opts[:filename] ||= Bixby.path("var", "bixby-agent.log")
      log_dir = File.dirname(opts[:filename])
      FileUtils.mkdir_p(log_dir)

      # make sure we have the correct permissions
      if Process.uid == 0 then
        if !File.exists? opts[:filename] then
          FileUtils.touch(opts[:filename], opts[:filename] + ".age")
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

      Logging::Logger.root.add_appenders("file")
      Logging::Logger.root.level = opts[:level]
      Logging::Logger.root.trace = true
    end

  end # Log

end
