require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'minitest/unit'
require 'turn'

begin
  require 'simplecov'
  SimpleCov.start
rescue Exception => ex
end


$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'devops_common'

class MiniTest::Unit::TestCase

  # minitest assert_throws doesn't seem to work properly
  def assert_throws(clazz, msg = nil, &block)
    begin
      yield
    rescue Exception => ex
      if clazz.to_s == ex.class.name then
        if msg.nil?
          return
        elsif msg == ex.message then
          return
        end
      end
    end
    flunk("Expected #{mu_pp(clazz)} to have been thrown")
  end

end

MiniTest::Unit.autorun
