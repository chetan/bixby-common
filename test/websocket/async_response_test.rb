
require 'helper'

module Bixby
module Test
module WebSocket
class TestAsyncResponse < TestCase

  def test_block

    sync_response = nil
    cb_response = nil

    res = Bixby::WebSocket::AsyncResponse.new("1234") do |r|
      cb_response = r
    end

    assert res
    assert_equal "1234", res.id
    refute res.completed?

    # start a thread waiting on the response to be writ ten
    t = Thread.new {
      sync_response = res.response
    }
    assert t.alive?

    # small sleep here, otherwise execution will continue too quickly, before the thread starts
    assert_nil t.join(0.001)

    # now write it, thread should complete & callback will fire
    res.response = "hi"

    t.join
    refute t.alive?
    assert_equal "hi", cb_response
    assert_equal "hi", sync_response
  end

end
end
end
end
