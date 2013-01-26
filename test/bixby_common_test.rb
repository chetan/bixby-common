require 'helper'

module Bixby
module Test

class TestBixbyCommon < MiniTest::Unit::TestCase

  def test_autoloading
    assert_equal(JsonRequest, JsonRequest.new(nil, nil).class)
    assert_equal(BundleNotFound, BundleNotFound.new.class)
    assert_equal(CommandNotFound, CommandNotFound.new.class)
    assert_equal(CommandSpec, CommandSpec.new.class)
  end

end

end # Test
end # Bixby
