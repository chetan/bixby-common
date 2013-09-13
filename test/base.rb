
module Bixby
  module Test
    class TestCase < MiniTest::Unit::TestCase

      def setup
        ENV["BIXBY_HOME"] = File.join(File.expand_path(File.dirname(__FILE__)), "support")
      end

      def teardown
        EM.stop_event_loop if EM.reactor_running?
      end

    end
  end
end
