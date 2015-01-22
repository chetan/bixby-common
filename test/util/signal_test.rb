require 'helper'

module Bixby
module Test
class TestSignal < TestCase

  def test_create_signal

    foo = 0
    thread = Bixby::Signal.trap("ALRM") do
      foo += 1
    end

    assert thread.kind_of? Thread
    assert thread.alive?
    assert_equal 0, foo

    Process.kill("ALRM", Process.pid)
    sleep 0.01
    assert_equal 1, foo

    Process.kill("ALRM", Process.pid)
    sleep 0.01
    assert_equal 2, foo

    assert thread.alive?
    thread.kill
    thread.join
    refute thread.alive?
  end

end
end
end
