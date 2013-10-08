
require 'helper'

module Bixby


  module WebSocket
    class APIChannel
      def responses
        @responses
      end
    end
  end


module Test
module WebSocket
class TestAPIChannel < TestCase

  attr_reader :api_chan, :ws

  def setup
    @em_thread = Thread.new { EM.run{} }
    @ws = mock("websocket")
    @api_chan = Bixby::WebSocket::APIChannel.new(ws, SampleHandler)
  end

  def test_open
    refute api_chan.connected?
    api_chan.open(nil)
    assert api_chan.connected?
  end


  def test_exec
    # test executing a request on the channel
    json_req = JsonRequest.new("exec", {:foo => "bar"})
    ws.expects(:send).once().add_side_effect(SideEffect.new{ api_chan.responses.values.first.response = "hi" })
    assert_equal "hi", api_chan.execute(json_req)
  end

  def test_message_request
    # test receiving a request on the channel
    json_req = JsonRequest.new("exec", {"foo" => "bar"})
    signed_json_req = SignedJsonRequest.new(json_req, "foo", "bar")
    req = Bixby::WebSocket::Request.new(signed_json_req)

    cr = CommandResponse.new(:status => 0, :stdout => "foobar", :stderr => "")
    json_res = JsonResponse.new("success", nil, cr.to_hash)

    event = mock()
    event.expects(:data).once.returns(req.to_wire)
    SampleHandler.any_instance.expects(:handle).with{ |r| r == json_req }.returns(json_res)
    ws.expects(:send).once.with { |str|
      res = Bixby::WebSocket::Message.from_wire(str)
      !res.nil? && res.json_response.to_wire == json_res.to_wire
    }
    api_chan.message(event)
  end

  def test_message_response
    # test receiving a response on the channel
    cr = CommandResponse.new(:status => 0, :stdout => "foobar", :stderr => "")
    json_res = JsonResponse.new("success", nil, cr.to_hash)
    res = Bixby::WebSocket::Response.new(json_res, "1234")

    event = mock()
    event.expects(:data).once.returns(res.to_wire)
    api_chan.responses["1234"] = Bixby::WebSocket::AsyncResponse.new("1234")
    api_chan.message(event)
    ret = api_chan.fetch_response("1234")
    assert ret
    assert_kind_of JsonResponse, ret
    assert_equal json_res.to_wire, ret.to_wire
  end

  def test_message_connect
    # test receiving a connect request on the channel
    json_req = JsonRequest.new("", {})
    signed_json_req = SignedJsonRequest.new(json_req, "foo", "bar")
    req = Bixby::WebSocket::Request.new(signed_json_req, nil, "connect")

    event = mock("event")
    event.expects(:data).once.returns(req.to_wire)
    SampleHandler.any_instance.expects(:connect).with(json_req, api_chan)
    ws.expects(:send).once.with { |str|
      res = Bixby::WebSocket::Message.from_wire(str)
      !res.nil? && res.type == "rpc_result" && res.json_response.success?
    }
    api_chan.message(event)
  end

  def test_close
    # close
    api_chan.open(nil)
    SampleHandler.any_instance.expects(:disconnect).with(api_chan).once()
    api_chan.close(nil)

  end

end
end
end
end
