
require 'helper'

module Bixby
module Test

class TestCommandResponse < MiniTest::Unit::TestCase

  def test_from_json_response
    res = JsonResponse.new("fail", "unknown")
    cr = CommandResponse.from_json_response(res)
    assert_kind_of CommandResponse, cr
    assert_equal 255, cr.status
    assert_equal "unknown", cr.stderr
  end

end # TestCommandResponse

end # Test
end # Bixby
