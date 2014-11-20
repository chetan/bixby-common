source "https://rubygems.org"

gem "bixby-auth", "~> 0.1"

gem "faye-websocket", "~> 0.7"
gem "multi_json", "~> 1.8"
gem "httpi", "~> 2.1"
gem "logging", "~> 1.8"

gem "semver2", "~> 3.3"

group :development do
  gem "yard", "~> 0.8"
  gem "bundler", "~> 1.1"
  gem "jeweler", "~> 2.0", :git => "https://github.com/chetan/jeweler.git", :branch => "bixby"
  gem "pry", "~> 0.9"

  gem "test_guard", "~> 0.2", :git => "https://github.com/chetan/test_guard.git"
  gem 'rb-inotify', "~> 0.9", :require => false
  gem 'rb-fsevent', "~> 0.9", :require => false
  gem 'rb-fchange', "~> 0.0", :require => false
end

group :test do
  gem "simplecov",  :platforms => [:mri_19, :mri_20, :rbx], :git => "https://github.com/chetan/simplecov.git", :branch => "inline_nocov"
  gem "easycov",    :github => "chetan/easycov"
  gem "micron",     :github => "chetan/micron"
  gem "coveralls",  :require => false

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

