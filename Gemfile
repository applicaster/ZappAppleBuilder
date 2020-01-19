# Gemfile
source 'https://rubygems.org'

gem 'fastlane', '= 2.140.0'
gem 'cocoapods', '= 1.8.4'

# Zapp SDK creation process
gem 'zapp_sdk_tasks', '= 0.5.0'

 plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
 eval_gemfile(plugins_path) if File.exist?(plugins_path)
