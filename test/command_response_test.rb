
require 'helper'

module Bixby
module Test

class TestCommandResponse < MiniTest::Unit::TestCase

  def test_from_json_response
    res = JsonResponse.new("fail", "unknown")
    assert res.fail?
    refute res.success?
    cr = CommandResponse.from_json_response(res)
    assert_kind_of CommandResponse, cr
    assert_equal 255, cr.status
    assert_equal "unknown", cr.stderr
    begin
      cr.raise!
    rescue CommandException => ex
      assert_equal "unknown", ex.message
    end

    res = JsonResponse.new("success", nil, {:status => 0, :stdout => "foobar", :stderr => nil})
    assert res.success?
    refute res.fail?
    cr = CommandResponse.from_json_response(res)
    assert_kind_of CommandResponse, cr
    assert_equal 0, cr.status
    assert_equal "foobar", cr.stdout
    assert_nil cr.stderr
  end

  def test_status
    cr = CommandResponse.new
    cr.status = 0
    assert cr.success?
    refute cr.fail?
    refute cr.error?

    cr.status = "255"
    refute cr.success?
    assert cr.fail?
  end

end # TestCommandResponse

end # Test
end # Bixby
