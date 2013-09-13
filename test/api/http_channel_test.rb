
require 'helper'

module Bixby
module Test
module API
class TestHttpChannel < TestCase

  def test_exec
    url = "http://google.com/"

    json_req = JsonRequest.new("exec", {"foo" => "bar"})
    signed_json_req = SignedJsonRequest.new(json_req, "foo", "bar")

    # setup response stub
    cr = CommandResponse.new(:status => 0, :stdout => "foobar", :stderr => "")
    json_res = JsonResponse.new("success", nil, cr.to_hash)
    res_mock = mock()
    res_mock.expects(:body).once.returns(json_res.to_wire)
    HTTPI.expects(:post).with{ |r| r.kind_of?(HTTPI::Request) && r.url.to_s == url }.returns(res_mock)

    chan = HttpChannel.new(url)
    res = chan.execute(signed_json_req)

    # req should have been modified
    assert_includes signed_json_req.headers, "Content-Type"
    assert_equal "application/json", signed_json_req.headers["Content-Type"]

    assert res
    assert_kind_of JsonResponse, res
    assert res.success?

    cr = CommandResponse.from_json_response(res)
    assert cr
    assert_equal 0, cr.status
    assert_equal "foobar", cr.stdout
    assert_equal "", cr.stderr
  end

  def test_exec_download
    url = "http://google.com/"

    json_req = JsonRequest.new("exec", {"foo" => "bar"})
    signed_json_req = SignedJsonRequest.new(json_req, "foo", "bar")

    # setup response stub
    HTTPI.expects(:post).with{ |r| r.kind_of?(HTTPI::Request) && r.url.to_s == url }

    chan = HttpChannel.new(url)
    res = chan.execute_download(signed_json_req) do
    end

    # req should have been modified
    assert_includes signed_json_req.headers, "Content-Type"
    assert_equal "application/json", signed_json_req.headers["Content-Type"]

    assert res
    assert_kind_of JsonResponse, res
    assert res.success?
  end

end
end
end
end
