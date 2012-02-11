
require 'helper'

class TestCommandSpec < MiniTest::Unit::TestCase

  def test_to_json
    j = JFoo.new
    j.bar = "baz"
    json = j.to_json
    assert json
    assert_equal '{"bar":"baz"}', json
  end

  def test_from_json
    j1 = JFoo.new
    j1.bar = "baz"

    j2 = JFoo.from_json(j1.to_json)
    assert_equal "baz", j2.bar
  end

end

class JFoo
  include Jsonify
  attr_accessor :bar
end
