source "http://rubygems.org"

gem "multi_json"
gem "oj"
gem "curb"
gem "systemu"

group :development do
  gem "yard", "~> 0.8"
  gem "bundler", "~> 1.1"
  gem "jeweler", "~> 1.8.3"

  gem "simplecov",    :platforms => :mri_19
  gem "rcov",         :platforms => :mri_18

  gem "minitest",     :platforms => :mri_19
  gem "test-unit",    :platforms => :mri_18

  gem "turn"

  gem "test_guard", :git => "https://github.com/chetan/test_guard.git"
  gem 'rb-fsevent', '~> 0.9.1' if RbConfig::CONFIG['target_os'] =~ /darwin(1.+)?$/i
  gem 'rb-inotify', '~> 0.8.8', :github => 'mbj/rb-inotify' if RbConfig::CONFIG['target_os'] =~ /linux/i
  gem 'wdm',        '~> 0.0.3' if RbConfig::CONFIG['target_os'] =~ /mswin|mingw/i
end

