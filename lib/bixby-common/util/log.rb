
require "logging"

require "bixby-common/util/log/filtering_layout"

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

      pattern = opts.delete(:pattern) || '%.1l, [%d] %5l -- %c: %m\n'
      layout = Logging.layouts.pattern(:pattern => pattern)

      opts[:filename] ||= Bixby.path("var", "bixby-agent.log")
      FileUtils.mkdir_p(File.dirname(opts[:filename]))

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
    end

  end # Log

end
