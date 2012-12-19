
require 'helper'

module Bixby
module Test

class TestHttpClient < MiniTest::Unit::TestCase

  include WebMock::API

  def teardown
    WebMock.reset!
  end

  class Foo
    include Bixby::HttpClient
  end

  def test_http_get
    stub_request(:get, "http://www.google.com/").
      to_return(:status => 200, :body => "foobar", :headers => {})
    body = Foo.new.http_get("http://www.google.com")
    assert_equal "foobar", body
  end

  def test_http_post
    stub_request(:post, "http://www.google.com/").
      with(:body => "foo=bar").
      to_return(:status => 200, :body => "foobar", :headers => {})
    body = Foo.new.http_post("http://www.google.com", {:foo => "bar"})
    assert_equal "foobar", body
  end

  def test_http_post_json
    # string bodies should pass through directly
    stub_request(:post, "http://www.google.com/").
      with(:body => "{\"foo\":\"bar\"}").
      to_return(:status => 200, :body => "foobar", :headers => {})
    body = Foo.new.http_post("http://www.google.com", MultiJson.dump({:foo => "bar"}))
    assert_equal "foobar", body
  end

  def test_http_post_download
    stub_request(:post, "http://www.google.com/").
      with(:body => "fooey").
      to_return(:status => 200, :body => "baznab", :headers => {})

    tmp = Tempfile.new("bc-post-")
    body = Foo.new.http_post_download("http://www.google.com", "fooey", tmp.path)

    s = File.read(tmp.path)
    assert_equal "baznab", s
  end

end # TestHttpClient

end # Test
end # Bixby
