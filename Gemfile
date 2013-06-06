source "https://rubygems.org"

gem "multi_json"
gem "httpi",        :git => "https://github.com/chetan/httpi.git",
                    :branch => "chunked_responses"

gem "logging"

group :development do
  gem "yard", "~> 0.8"
  gem "bundler", "~> 1.1"
  gem "jeweler", :git => "https://github.com/chetan/jeweler.git", :branch => "bixby"
  gem "pry"

  gem "simplecov",    :platforms => [:mri_19, :mri_20, :rbx], :git => "https://github.com/chetan/simplecov.git", :branch => "inline_nocov"
  gem "rcov",         :platforms => :mri_18

  gem "minitest",     "~> 4.0", :platforms => [:mri_19, :mri_20, :rbx]
  gem "test-unit",    :platforms => :mri_18
  gem "webmock",      :require => false
  gem "mocha",        :require => false

  gem "turn"

  gem "test_guard", :git => "https://github.com/chetan/test_guard.git"
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false

  # platform specific gemms
  # not sure we need to include these at all
  gem "json",         :platforms => [:mri, :jruby]
  gem "oj",           :platforms => [:mri, :rbx]

  gem "httpclient",   :platforms => [:jruby]
  gem "curb",         :platforms => [:mri, :rbx]

  gem "jruby-openssl", :platforms => [:jruby]
end

