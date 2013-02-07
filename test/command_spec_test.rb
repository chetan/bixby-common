

require 'helper'

module Bixby
module Test

class TestCommandSpec < MiniTest::Unit::TestCase

  def setup
    ENV["BIXBY_HOME"] = File.join(File.expand_path(File.dirname(__FILE__)), "support")
    h = { :repo => "vendor", :bundle => "test_bundle", 'command' => "echo", :foobar => "baz" }
    @c = CommandSpec.new(h)
  end

  def teardown
    super
    system("rm -rf /tmp/_test_bixby_home")
    Bixby.instance_eval do
      @root = nil # make sure we can pickup the new ENV
    end
  end


  def test_init_with_hash
    assert(@c)
    assert_equal("vendor", @c.repo)
    assert_equal("test_bundle", @c.bundle)
    assert_equal("echo", @c.command)
  end

  def test_to_hash
    assert_equal("vendor", @c.to_hash[:repo])
    assert_equal("test_bundle", @c.to_hash[:bundle])
    assert_equal("echo", @c.to_hash[:command])
  end

  def test_load_config
    config = @c.load_config
    assert config
    assert_kind_of Hash, config
    assert_empty config

    @c.command = "cat"
    config = @c.load_config
    assert config
    assert_equal "cat", config["name"]
  end

  def test_validate_failures
    assert_throws(BundleNotFound) do
      CommandSpec.new(:repo => "vendor", :bundle => "foobar").validate(nil)
    end
    assert_throws(CommandNotFound) do
      CommandSpec.new(:repo => "vendor", :bundle => "test_bundle", :command => "foobar").validate(nil)
    end
    assert_throws(BundleNotFound) do
      @c.validate(nil)
    end
  end

  def test_digest
    expected_digest = "8980372485fc6bcd287e481ab1e15710e2b63c68db75085c2d24386ced272ca4"
    assert_equal expected_digest, @c.digest
    assert @c.validate(expected_digest)
  end

  def test_digest_no_err
    c = CommandSpec.new({ :repo => "vendor", :bundle => "test_bundle", 'command' => "echofoo" })
  end

  def test_exec_digest_changed_throws_error
    assert_throws(BundleNotFound) do
      @c.validate("alkjasdfasd")
    end
  end

  def test_update_digest
    expected = MultiJson.load(File.read(Bixby.repo_path + "/vendor/test_bundle/digest"))

    t = "/tmp/_test_bixby_home"
    d = "#{t}/repo/vendor/test_bundle/digest"
    `mkdir -p #{t}`
    `cp -a #{Bixby.repo_path}/ #{t}/`
    `rm #{d}`
    ENV["BIXBY_HOME"] = t

    Bixby.instance_eval do
      @root = nil # make sure we can pickup the new ENV
    end

    refute File.exist? d
    @c.update_digest
    assert File.exist? d
    assert_equal MultiJson.dump(expected), MultiJson.dump(MultiJson.load(File.read(d)))

    @c.update_digest
    assert File.exist? d
    assert_equal MultiJson.dump(expected), MultiJson.dump(MultiJson.load(File.read(d)))
  end

end # TestCommandSpec

end # Test
end # Bixby
