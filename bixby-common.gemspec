# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: bixby-common 0.7.1 ruby lib

Gem::Specification.new do |s|
  s.name = "bixby-common"
  s.version = "0.7.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Chetan Sarva"]
  s.date = "2015-06-29"
  s.description = "Bixby Common files/libs"
  s.email = "chetan@pixelcop.net"
  s.extra_rdoc_files = [
    "LICENSE"
  ]
  s.files = [
    ".coveralls.yml",
    ".document",
    ".travis.yml",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "Rakefile",
    "VERSION",
    "bixby-common.gemspec",
    "lib/bixby-common.rb",
    "lib/bixby-common/api/api_channel.rb",
    "lib/bixby-common/api/encrypted_json_request.rb",
    "lib/bixby-common/api/http_channel.rb",
    "lib/bixby-common/api/json_request.rb",
    "lib/bixby-common/api/json_response.rb",
    "lib/bixby-common/api/rpc_handler.rb",
    "lib/bixby-common/api/signed_json_request.rb",
    "lib/bixby-common/bixby.rb",
    "lib/bixby-common/command_response.rb",
    "lib/bixby-common/command_spec.rb",
    "lib/bixby-common/exception/bundle_not_found.rb",
    "lib/bixby-common/exception/command_exception.rb",
    "lib/bixby-common/exception/command_not_found.rb",
    "lib/bixby-common/exception/encryption_error.rb",
    "lib/bixby-common/util/crypto_util.rb",
    "lib/bixby-common/util/debug.rb",
    "lib/bixby-common/util/hashify.rb",
    "lib/bixby-common/util/http_client.rb",
    "lib/bixby-common/util/jsonify.rb",
    "lib/bixby-common/util/log.rb",
    "lib/bixby-common/util/log/filtering_layout.rb",
    "lib/bixby-common/util/log/logger.rb",
    "lib/bixby-common/util/signal.rb",
    "lib/bixby-common/util/thread_dump.rb",
    "lib/bixby-common/util/thread_pool.rb",
    "lib/bixby-common/util/thread_pool/task.rb",
    "lib/bixby-common/util/thread_pool/worker.rb",
    "lib/bixby-common/websocket/api_channel.rb",
    "lib/bixby-common/websocket/async_response.rb",
    "lib/bixby-common/websocket/message.rb",
    "lib/bixby-common/websocket/request.rb",
    "lib/bixby-common/websocket/response.rb",
    "test/api/http_channel_test.rb",
    "test/base.rb",
    "test/bixby_common_test.rb",
    "test/command_response_test.rb",
    "test/command_spec_test.rb",
    "test/helper.rb",
    "test/sample_handler.rb",
    "test/side_effect.rb",
    "test/support/repo/vendor/test_bundle/bin/cat",
    "test/support/repo/vendor/test_bundle/bin/cat.json",
    "test/support/repo/vendor/test_bundle/bin/echo",
    "test/support/repo/vendor/test_bundle/digest",
    "test/support/repo/vendor/test_bundle/manifest.json",
    "test/util/crypto_util_test.rb",
    "test/util/http_client_test.rb",
    "test/util/jsonify_test.rb",
    "test/util/log_test.rb",
    "test/util/signal_test.rb",
    "test/util/thread_pool_test.rb",
    "test/websocket/api_channel_test.rb",
    "test/websocket/async_response_test.rb",
    "test/websocket/request_test.rb",
    "test/websocket/response_test.rb"
  ]
  s.homepage = "http://github.com/chetan/bixby-common"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.6"
  s.summary = "Bixby Common"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<bixby-auth>, ["~> 0.1"])
      s.add_runtime_dependency(%q<faye-websocket>, ["~> 0.7"])
      s.add_runtime_dependency(%q<multi_json>, ["~> 1.8"])
      s.add_runtime_dependency(%q<httpi>, ["~> 2.1"])
      s.add_runtime_dependency(%q<logging>, ["~> 1.8"])
      s.add_runtime_dependency(%q<semver2>, ["~> 3.3"])
      s.add_development_dependency(%q<yard>, ["~> 0.8"])
      s.add_development_dependency(%q<bundler>, ["~> 1.1"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0"])
      s.add_development_dependency(%q<pry>, ["~> 0.9"])
      s.add_development_dependency(%q<test_guard>, ["~> 0.2"])
      s.add_development_dependency(%q<rb-inotify>, ["~> 0.9"])
      s.add_development_dependency(%q<rb-fsevent>, ["~> 0.9"])
      s.add_development_dependency(%q<rb-fchange>, ["~> 0.0"])
    else
      s.add_dependency(%q<bixby-auth>, ["~> 0.1"])
      s.add_dependency(%q<faye-websocket>, ["~> 0.7"])
      s.add_dependency(%q<multi_json>, ["~> 1.8"])
      s.add_dependency(%q<httpi>, ["~> 2.1"])
      s.add_dependency(%q<logging>, ["~> 1.8"])
      s.add_dependency(%q<semver2>, ["~> 3.3"])
      s.add_dependency(%q<yard>, ["~> 0.8"])
      s.add_dependency(%q<bundler>, ["~> 1.1"])
      s.add_dependency(%q<jeweler>, ["~> 2.0"])
      s.add_dependency(%q<pry>, ["~> 0.9"])
      s.add_dependency(%q<test_guard>, ["~> 0.2"])
      s.add_dependency(%q<rb-inotify>, ["~> 0.9"])
      s.add_dependency(%q<rb-fsevent>, ["~> 0.9"])
      s.add_dependency(%q<rb-fchange>, ["~> 0.0"])
    end
  else
    s.add_dependency(%q<bixby-auth>, ["~> 0.1"])
    s.add_dependency(%q<faye-websocket>, ["~> 0.7"])
    s.add_dependency(%q<multi_json>, ["~> 1.8"])
    s.add_dependency(%q<httpi>, ["~> 2.1"])
    s.add_dependency(%q<logging>, ["~> 1.8"])
    s.add_dependency(%q<semver2>, ["~> 3.3"])
    s.add_dependency(%q<yard>, ["~> 0.8"])
    s.add_dependency(%q<bundler>, ["~> 1.1"])
    s.add_dependency(%q<jeweler>, ["~> 2.0"])
    s.add_dependency(%q<pry>, ["~> 0.9"])
    s.add_dependency(%q<test_guard>, ["~> 0.2"])
    s.add_dependency(%q<rb-inotify>, ["~> 0.9"])
    s.add_dependency(%q<rb-fsevent>, ["~> 0.9"])
    s.add_dependency(%q<rb-fchange>, ["~> 0.0"])
  end
end

