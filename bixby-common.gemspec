# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "bixby-common"
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chetan Sarva"]
  s.date = "2012-12-21"
  s.description = "Bixby Common files/libs"
  s.email = "chetan@pixelcop.net"
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "Rakefile",
    "VERSION",
    "bixby-common.gemspec",
    "lib/bixby-common.rb",
    "lib/bixby_common.rb",
    "lib/bixby_common/api/base_module.rb",
    "lib/bixby_common/api/bundle_repository.rb",
    "lib/bixby_common/api/json_request.rb",
    "lib/bixby_common/api/json_response.rb",
    "lib/bixby_common/command_response.rb",
    "lib/bixby_common/command_spec.rb",
    "lib/bixby_common/exception/bundle_not_found.rb",
    "lib/bixby_common/exception/command_not_found.rb",
    "lib/bixby_common/exception/encryption_error.rb",
    "lib/bixby_common/util/crypto_util.rb",
    "lib/bixby_common/util/hashify.rb",
    "lib/bixby_common/util/http_client.rb",
    "lib/bixby_common/util/jsonify.rb",
    "test/helper.rb",
    "test/support/test_bundle/bin/cat",
    "test/support/test_bundle/bin/echo",
    "test/support/test_bundle/digest",
    "test/support/test_bundle/manifest.json",
    "test/test_bixby_common.rb",
    "test/test_command_response.rb",
    "test/test_command_spec.rb",
    "test/test_jsonify.rb",
    "test/util/test_http_client.rb"
  ]
  s.homepage = "http://github.com/chetan/bixby-common"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Bixby Common"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<multi_json>, [">= 0"])
      s.add_runtime_dependency(%q<httpi>, [">= 0"])
      s.add_runtime_dependency(%q<systemu>, [">= 0"])
      s.add_development_dependency(%q<yard>, ["~> 0.8"])
      s.add_development_dependency(%q<bundler>, ["~> 1.1"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.3"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<minitest>, [">= 0"])
      s.add_development_dependency(%q<test-unit>, [">= 0"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<turn>, [">= 0"])
      s.add_development_dependency(%q<test_guard>, [">= 0"])
    else
      s.add_dependency(%q<multi_json>, [">= 0"])
      s.add_dependency(%q<httpi>, [">= 0"])
      s.add_dependency(%q<systemu>, [">= 0"])
      s.add_dependency(%q<yard>, ["~> 0.8"])
      s.add_dependency(%q<bundler>, ["~> 1.1"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<minitest>, [">= 0"])
      s.add_dependency(%q<test-unit>, [">= 0"])
      s.add_dependency(%q<webmock>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<turn>, [">= 0"])
      s.add_dependency(%q<test_guard>, [">= 0"])
    end
  else
    s.add_dependency(%q<multi_json>, [">= 0"])
    s.add_dependency(%q<httpi>, [">= 0"])
    s.add_dependency(%q<systemu>, [">= 0"])
    s.add_dependency(%q<yard>, ["~> 0.8"])
    s.add_dependency(%q<bundler>, ["~> 1.1"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<minitest>, [">= 0"])
    s.add_dependency(%q<test-unit>, [">= 0"])
    s.add_dependency(%q<webmock>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<turn>, [">= 0"])
    s.add_dependency(%q<test_guard>, [">= 0"])
  end
end

