# Gemfile
source 'https://rubygems.org'

gem 'fastlane', '= 2.148.1'
gem 'cocoapods', '= 1.9.1'

# Zapp SDK creation process
gem 'zapp_sdk_tasks', '= 0.5.0'

 plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
 eval_gemfile(plugins_path) if File.exist?(plugins_path)
