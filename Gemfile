# frozen_string_literal: true

# Gemfile
source 'https://rubygems.org'

gem 'cocoapods', '= 1.10.0'
gem 'colorize', '= 0.8.1'
gem 'configure_extensions'
gem 'fastlane', '= 2.171.0'
gem 'faraday', '~> 1.0'
# Zapp SDK creation process
gem 'zapp_sdk_tasks', '= 0.6.0'


plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
