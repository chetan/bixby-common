

require 'helper'

class TestCommandSpec < MiniTest::Unit::TestCase

  def setup
    BundleRepository.path = File.expand_path(File.dirname(__FILE__))
    h = { :repo => "support", :bundle => "test_bundle", 'command' => "echo", :foobar => "baz" }
    @c = CommandSpec.new(h)
  end


  def test_init_with_hash

    assert(@c)
    assert_equal("support", @c.repo)
    assert_equal("test_bundle", @c.bundle)
    assert_equal("echo", @c.command)

  end

  def test_to_hash

    assert_equal("support", @c.to_hash[:repo])
    assert_equal("test_bundle", @c.to_hash[:bundle])
    assert_equal("echo", @c.to_hash[:command])

  end

  def test_validate
    @c.validate
  end

  def test_validate_failures
    assert_throws(BundleNotFound) do
      CommandSpec.new(:repo => "support", :bundle => "foobar").validate
    end
    assert_throws(CommandNotFound) do
      CommandSpec.new(:repo => "support", :bundle => "test_bundle", :command => "foobar").validate
    end
  end

  def test_execute
    (status, stdout, stderr) = @c.execute
    assert(status.success?)
    assert_equal("hi\n", stdout)
    assert_equal("", stderr)
  end

  def test_execute_stdin
    @c.command = "cat"
    @c.stdin = "hi"
    (status, stdout, stderr) = @c.execute
    assert(status.success?)
    assert_equal("hi", stdout)
    assert_equal("", stderr)
  end

end
