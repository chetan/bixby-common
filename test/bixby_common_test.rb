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

  def test_strings
    assert_kind_of String, JsonRequest.new(nil, nil).to_s
    assert_kind_of String, JsonResponse.new.to_s
    assert_kind_of String, CommandResponse.new.to_s

    assert_includes Debug.pretty_str("abc"), "EOF"
    assert_equal "''", Debug.pretty_str("")
  end

end

end # Test
end # Bixby
