
module Bixby
  module Test
    class TestCase < MiniTest::Unit::TestCase

      def setup
        ENV["BIXBY_HOME"] = File.join(File.expand_path(File.dirname(__FILE__)), "support")
      end

    end
  end
end
