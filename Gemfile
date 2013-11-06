source "https://rubygems.org"

gem "faye-websocket"
gem "multi_json"
gem "httpi"
gem "logging"

gem "api-auth", :git => "https://github.com/chetan/api_auth.git", :branch => "bixby"

gem "semver2"

group :development do
  gem "yard", "~> 0.8"
  gem "bundler", "~> 1.1"
  gem "jeweler", :git => "https://github.com/chetan/jeweler.git", :branch => "bixby"
  gem "pry"

  gem "test_guard", :git => "https://github.com/chetan/test_guard.git"
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
end

group :test do
  gem "simplecov",  :platforms => [:mri_19, :mri_20, :rbx], :git => "https://github.com/chetan/simplecov.git", :branch => "inline_nocov"
  gem "easycov",    :github => "chetan/easycov"
  gem "micron",     :github => "chetan/micron"
  gem "coveralls", :require => false

  gem "webmock",    :require => false
  gem "mocha",      :require => false

  # for some tests
  gem "mixlib-shellout"

  # platform specific gemms
  # not sure we need to include these at all
  gem "json",         :platforms => [:mri, :jruby]
  gem "oj",           :platforms => [:mri, :rbx]

  gem "httpclient",   :platforms => [:jruby]
  gem "curb",         :platforms => [:mri, :rbx]

  gem "jruby-openssl", :platforms => [:jruby]
end

