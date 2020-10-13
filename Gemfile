# frozen_string_literal: true

# Gemfile
source 'https://rubygems.org'

gem 'cocoapods', '= 1.9.3'
gem 'colorize', '= 0.8.1'
gem 'configure_extensions', '= 1.0.1'
gem 'fastlane', '= 2.163.0'
# Zapp SDK creation process
gem 'zapp_sdk_tasks', '= 0.6.0'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
