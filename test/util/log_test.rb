
require 'helper'

module Bixby
module Test

class TestLog < MiniTest::Unit::TestCase

  def test_setup_logger
    ENV["BIXBY_DEBUG"] = "1"
    Bixby::Log.setup_logger
    assert_equal 0, Logging::Logger.root.level # debug

    ENV.delete("BIXBY_DEBUG")
    Bixby::Log.setup_logger
    assert_equal 2, Logging::Logger.root.level # warn

    ENV.delete("BIXBY_DEBUG")
    Bixby::Log.setup_logger(:info)
    assert_equal 1, Logging::Logger.root.level # info
  end

end # TestLog

end # Test
end # Bixby
