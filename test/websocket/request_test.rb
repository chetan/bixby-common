
require 'helper'

module Bixby
module Test
module WebSocket
class TestRequest < TestCase

  def test_init
    json_req = JsonRequest.new("exec", {:foo => "bar"})
    req = Bixby::WebSocket::Request.new(json_req)

    assert req
    assert req.headers
    assert_empty req.headers

    h = MultiJson.load(req.to_wire)
    test_common_props(h)
    assert_empty h["headers"]
  end

  def test_signed
    json_req = JsonRequest.new("exec", {:foo => "bar"})
    signed_json_req = SignedJsonRequest.new(json_req, "foo", "bar")
    req = Bixby::WebSocket::Request.new(signed_json_req)

    assert req
    h = MultiJson.load(req.to_wire)
    test_common_props(h)
    refute_empty h["headers"]

    assert_includes h["headers"], "Content-MD5"
    assert_includes h["headers"], "Date"
    assert_includes h["headers"], "Authorization"
    assert h["headers"]["Authorization"] =~ /^APIAuth foo:/
  end

  def test_json_req
    json_req = JsonRequest.new("exec", {"foo" => "bar"})
    req = Bixby::WebSocket::Request.new(json_req)

    assert req.json_request
    assert_equal json_req, req.json_request
    assert_equal json_req, Bixby::WebSocket::Message.from_wire(req.to_wire).json_request
  end


  private

  def test_common_props(h)
    assert h
    assert_equal "rpc", h["type"]
    assert h["id"]

    d = MultiJson.load(h["data"])
    assert_equal "exec", d["operation"]
    refute_empty d["params"]
    assert_equal "bar", d["params"]["foo"]
    h
  end

end
end
end
end
