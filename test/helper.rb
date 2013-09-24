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
require 'micron/minitest'

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

require "base"
require "sample_handler"
require "side_effect"

Dir.glob(File.dirname(__FILE__) + "/../lib/**/*.rb").each{ |f| require f }

EasyCov.path = "coverage"
EasyCov.filters << EasyCov::IGNORE_GEMS << EasyCov::IGNORE_STDLIB
EasyCov.start
