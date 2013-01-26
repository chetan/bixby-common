source "http://rubygems.org"

gem "multi_json"
gem "httpi",        :git => "https://github.com/chetan/httpi.git",
                    :branch => "chunked_responses"

gem "systemu",      :git => "https://github.com/chetan/systemu.git",
                    :branch => "forkbomb"

gem "logging"

group :development do
  gem "yard", "~> 0.8"
  gem "bundler", "~> 1.1"
  gem "jeweler", "~> 1.8.3"
  gem "pry"

  gem "simplecov",    :platforms => [:mri_19, :rbx]
  gem "rcov",         :platforms => :mri_18

  gem "minitest",     :platforms => [:mri_19, :rbx]
  gem "test-unit",    :platforms => :mri_18
  gem "webmock",      :require => false
  gem "mocha",        :require => false

  gem "turn"

  gem "test_guard", :git => "https://github.com/chetan/test_guard.git"

  # platform specific gemms
  # not sure we need to include these at all
  gem "json",         :platforms => [:jruby]
  gem "oj",           :platforms => [:mri, :rbx]

  gem "httpclient",   :platforms => [:jruby]
  gem "curb",         :platforms => [:mri, :rbx]

  gem "jruby-openssl", :platforms => [:jruby]
end

