
require 'helper'

module Bixby
module Test
module WebSocket
class TestResponse < TestCase

  def test_init
    cr = CommandResponse.new(:status => 0, :stdout => "foobar", :stderr => "")
    json_res = JsonResponse.new("success", nil, cr.to_hash)
    res = Bixby::WebSocket::Response.new(json_res, "1234")

    assert res
    assert res.headers
    assert_empty res.headers

    h = MultiJson.load(res.to_wire)
    assert h
    assert_equal "rpc_result", h["type"]
    assert_equal "1234", h["id"]

    d = MultiJson.load(h["data"])
    assert_equal "success", d["status"]
    refute d["message"]
    refute d["code"]
    assert_equal 0, d["data"]["status"]
    assert_equal "foobar", d["data"]["stdout"]
    assert_equal "", d["data"]["stderr"]
  end

  def test_json_res
    cr = CommandResponse.new("status" => 0, "stdout" => "foobar", "stderr" => "")
    json_res = JsonResponse.new("success", nil, cr.to_hash)
    res = Bixby::WebSocket::Response.new(json_res, "1234")

    assert res.json_response
    assert_equal json_res.to_wire, res.json_response.to_wire
    assert_equal json_res.to_wire, Bixby::WebSocket::Message.from_wire(res.to_wire).json_response.to_wire
  end

end
end
end
end
