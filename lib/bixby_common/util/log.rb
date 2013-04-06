
require "logging"

module Bixby

  # A simple logging mixin
  module Log

    # Get a log instance for this class
    #
    # @return [Logger]
    def log
      @log ||= Logging.logger[self]
    end

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
    # @param [Symbol] level       Log level to use (default = :warn)
    # @param [String] pattern     Log pattern
    def self.setup_logger(level=nil, pattern=nil)
      # set level: ENV flag overrides; default to warn
      level = :debug if ENV["BIXBY_DEBUG"]
      level ||= :warn

      pattern ||= '%.1l, [%d] %5l -- %c: %m\n'

      FileUtils.mkdir_p(Bixby.path("var"))

      # TODO always use stdout for now
      Logging.appenders.rolling_file("file",
        :filename      => Bixby.path("var", "bixby-agent.log"),
        :keep          => 7,
        :roll_by       => 'date',
        :age           => 'daily',
        :truncate      => false,
        :auto_flushing => true,
        :level         => level,
        :layout        => Logging.layouts.pattern(:pattern => pattern)
        )

      Logging::Logger.root.add_appenders("file")
      Logging::Logger.root.level = level
    end

  end # Log

end
