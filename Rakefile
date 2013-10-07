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
  gemspec.license = "MIT"
end
Jeweler::RubygemsDotOrgTasks.new

Dir['tasks/**/*.rake'].each { |rake| load rake }

require "micron/rake"
Micron::Rake.new do |task|
end
task :default => :test

# for displaying coverage
require "easycov/rake"

# for reporting to coveralls
require "coveralls"
desc "Report coverage to coveralls"
task :coveralls do
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  if File.exists? File.join(EasyCov.path, ".resultset.json") then
    SimpleCov::ResultMerger.merged_result.format!
  end
end

require 'yard'
YARD::Rake::YardocTask.new
