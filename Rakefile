# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'
require 'jeweler'

Jeweler::Tasks.new do |gemspec|
  gemspec.name = "bixby-common"
  gemspec.summary = "Bixby Common"
  gemspec.description = "Bixby Common files/libs"
  gemspec.email = "chetan@pixelcop.net"
  gemspec.homepage = "http://github.com/chetan/bixby-common"
  gemspec.authors = ["Chetan Sarva"]
end
Jeweler::RubygemsDotOrgTasks.new

Dir['tasks/**/*.rake'].each { |rake| load rake }

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

if Module.const_defined? :Rcov then
  begin
    require 'rcov/rcovtask'
    Rcov::RcovTask.new do |test|
      test.libs << 'test'
      test.pattern = 'test/**/*_test.rb'
      test.verbose = true
      test.rcov_opts << '--exclude "gems/*"'
    end
  rescue Exception => ex
  end
end

task :default => :test

begin
  require 'single_test'
  SingleTest.load_tasks

rescue LoadError
  warn "single_test not available"
end

require 'yard'
YARD::Rake::YardocTask.new
