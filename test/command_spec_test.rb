

require 'helper'

module Bixby
module Test

class TestCommandSpec < MiniTest::Unit::TestCase

  def setup
    Bixby.repo_path = File.expand_path(File.dirname(__FILE__))
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

  def test_validate_failures
    assert_throws(BundleNotFound) do
      CommandSpec.new(:repo => "support", :bundle => "foobar").validate(nil)
    end
    assert_throws(CommandNotFound) do
      CommandSpec.new(:repo => "support", :bundle => "test_bundle", :command => "foobar").validate(nil)
    end
    assert_throws(BundleNotFound) do
      @c.validate(nil)
    end
  end

  def test_digest
    assert_equal "2429629015110c29f8fae8ca97e0e494410a28b981653c0e094cfe4a7567f1b7", @c.digest
    assert @c.validate("2429629015110c29f8fae8ca97e0e494410a28b981653c0e094cfe4a7567f1b7")
  end

  def test_digest_no_err
    c = CommandSpec.new({ :repo => "support", :bundle => "test_bundle", 'command' => "echofoo" })
  end

  def test_exec_digest_changed_throws_error
    assert_throws(BundleNotFound) do
      @c.validate("alkjasdfasd")
    end
  end

  def test_update_digest
    expected = MultiJson.load(File.read(Bixby.repo_path + "/support/test_bundle/digest"))

    t = "/tmp/foobar_test_repo"
    d = "#{t}/support/test_bundle/digest"
    `mkdir -p #{t}`
    `cp -a #{Bixby.repo_path}/support #{t}/`
    `rm #{d}`
    Bixby.repo_path = t

    refute File.exist? d
    @c.update_digest
    assert File.exist? d
    assert_equal MultiJson.dump(expected), MultiJson.dump(MultiJson.load(File.read(d)))

    @c.update_digest
    assert File.exist? d
    assert_equal MultiJson.dump(expected), MultiJson.dump(MultiJson.load(File.read(d)))
    `rm -rf #{t}`
  end

end # TestCommandSpec

end # Test
end # Bixby
