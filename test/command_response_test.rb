
require 'helper'
require 'mixlib/shellout'

module Bixby
module Test

class TestCommandResponse < TestCase

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

  def test_to_json_response
    cr = CommandResponse.new(:status => 50, :stdout => "foobar", :stderr => "baz")
    js = cr.to_json_response

    assert js
    assert_kind_of JsonResponse, js

    refute js.success?
    assert js.fail?

    assert_nil js.message
    assert js.data

    assert_equal 50, js.data[:status]
    assert_equal "foobar", js.data[:stdout]
    assert_equal "baz", js.data[:stderr]
  end

  def test_from_shellout
    cmd = Mixlib::ShellOut.new("uname")
    cmd.run_command

    cr = CommandResponse.new(cmd)
    assert cr

    assert_equal 0, cr.status
    assert cr.stdout =~ /^Darwin|Linux$/
    assert_empty cr.stderr
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
