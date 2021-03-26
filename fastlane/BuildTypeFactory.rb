# frozen_string_literal: true

require 'colorize'

import 'Base/Helpers/EnvironmentHelper.rb'

class BuildTypeFactory
  @@env_helper = EnvironmentHelper.new

  attr_accessor :fastlane

  def initialize(options = {})
    @fastlane = options[:fastlane]
  end

  def perform_signing_validation(options)
    type_to_validate = options[:type]

    Dir.chdir(@@env_helper.root_path.to_s) do
      # perform validation for all needed env
      build_types_for_use.each do |type_for_use|
        if type_for_use.build_type == type_to_validate
          # download signing files
          type_for_use.download_signing_files

          # replace store to enterprise-client if needed
          type_for_use = replace_store_to_enterprise_client_if_needed(type_for_use)

          puts("Perform signing validation for #{type_for_use.class.name}".colorize(:yellow))
          type_for_use.perform_signing_validation
        else
          puts("Skipping signing validation for #{type_for_use} build".colorize(:red))
        end
      end
    end
  end

  def prepare_environment(options)
    type_to_prepare = options[:type]

    Dir.chdir(@@env_helper.root_path.to_s) do
      # prepare only specific env to build
      build_types_for_use.each do |type_for_use|
        if type_for_use.build_type == type_to_prepare
          # replace store to enterprise-client if needed
          type_for_use = replace_store_to_enterprise_client_if_needed(type_for_use)

          puts("Prepare environment for #{type_for_use.class.name}")
          type_for_use.prepare_environment
        else
          puts("Skipping preparing environment for #{type_for_use} build".colorize(:red))
        end
      end
    end
  end

  def build(options)
    type_to_build = options[:type]

    Dir.chdir(@@env_helper.root_path.to_s) do
      # build each one of the env
      build_types_for_use.each do |type_for_use|
        if type_for_use.build_type == type_to_build
          # replace store to enterprise-client if needed
          type_for_use = replace_store_to_enterprise_client_if_needed(type_for_use)

          puts("Building for #{type_for_use.class.name}")
          type_for_use.build
        else
          puts("Skipping build for #{type_for_use}".colorize(:red))
        end
      end
    end
  end

  def build_type_string
    if !@@env_helper.distribution_key_url.to_s.strip.empty? && @@env_helper.with_release == 'true'
      'store'
    elsif !@@env_helper.debug_distribution_key_url.to_s.strip.empty?
      # enterprise client release/debug depending on provided provisioning
      'enterprise'
    else
      'debug'
    end
  end

  def build_types_for_use
    buildtypes = []
    case build_type_string
    when 'enterprise'
      buildtypes = [
        EnterpriseClient.new(fastlane: @fastlane),
        EnterpriseDebug.new(fastlane: @fastlane)
      ]
    when 'store'
      buildtypes = [
        Store.new(fastlane: fastlane),
        EnterpriseDebug.new(fastlane: @fastlane)
      ]
    when 'debug'
      buildtypes = [
        EnterpriseDebug.new(fastlane: @fastlane)
      ]
    end
    buildtypes
  end

  def replace_store_to_enterprise_client_if_needed(type)
    if type.build_type == 'store' && type.is_enterprise_build
      puts('Switching to Enterprise client build'.colorize(:green))

      type = EnterpriseClient.new(fastlane: @fastlane)
    end
    type
  end
end
