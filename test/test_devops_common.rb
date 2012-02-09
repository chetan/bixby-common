require 'helper'

class TestDevopsCommon < MiniTest::Unit::TestCase

  def test_autoloading
    assert_equal(JsonRequest, JsonRequest.new(nil, nil).class)
    assert_equal(BundleNotFound, BundleNotFound.new.class)
    assert_equal(CommandSpec, CommandSpec.new.class)
  end

end
