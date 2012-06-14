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

  def test_json_request_error
    BaseModule.manager_uri = "http://127.0.0.1:9"
    req = JsonRequest.new("foo:bar", [ 3 ])
    res = req.exec()
    assert res
    refute res.success?
    assert res.fail?
    assert res.message =~ /ConnectionFailedError/
  end

end

end # Test
end # Bixby
