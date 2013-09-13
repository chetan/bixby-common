require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'test_guard'
TestGuard.load_simplecov()
require "base"

begin
  require 'curb'
  require 'curb_threadpool'
rescue LoadError
end

begin
  require 'httpclient'
rescue LoadError
end

require 'webmock'
require 'mocha/setup'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'bixby-common'

Dir.glob(File.dirname(__FILE__) + "/../lib/**/*.rb").each{ |f| require f }

MiniTest::Unit.autorun
