# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "devops_common"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chetan Sarva"]
  s.date = "2012-02-06"
  s.description = "Devops Common files/libs"
  s.email = "chetan@pixelcop.net"
  s.files = [
    "Rakefile",
    "VERSION",
    "devops_common.gemspec",
    "lib/common/api/json_request.rb",
    "lib/common/api/json_response.rb",
    "lib/common/api/modules/base_module.rb",
    "lib/common/api/modules/bundle_repository.rb",
    "lib/common/api/modules/inventory.rb",
    "lib/common/api/modules/provisioning.rb",
    "lib/common/command_spec.rb",
    "lib/common/exception/bundle_not_found.rb",
    "lib/common/exception/command_not_found.rb",
    "lib/common/util/http_client.rb",
    "lib/common/util/jsonify.rb"
  ]
  s.homepage = "http://github.com/chetan/devops"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Devops Common"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

