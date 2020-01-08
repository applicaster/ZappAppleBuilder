# Gemfile
source 'https://rubygems.org'

gem 'fastlane', '= 2.133.0'
gem 'cocoapods', '= 1.8.4'

# Zapp SDK creation process
gem 'zapp_sdk_tasks', '= 0.4.1'

 plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
 eval_gemfile(plugins_path) if File.exist?(plugins_path)