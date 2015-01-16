
require 'micron/test_case/redir_logging'

module Bixby
  module Test
    class TestCase < Micron::TestCase

      include Bixby::Log
      include Micron::TestCase::RedirLogging
      self.redir_logger = Logging.logger[Bixby]

      def setup
        ENV["BIXBY_HOME"] = File.join(File.expand_path(File.dirname(__FILE__)), "support")
      end

      def teardown
        EM.stop_event_loop if EM.reactor_running?
      end

    end
  end
end
