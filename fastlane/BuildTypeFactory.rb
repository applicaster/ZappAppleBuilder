# frozen_string_literal: true

require 'colorize'

import 'Base/Helpers/EnvironmentHelper.rb'

class BuildTypeFactory
  attr_accessor :fastlane

  def initialize(options = {})
    @fastlane = options[:fastlane]
  end

  def prepare_environment
    # prepare only specific env to build
    prepare_environment_build_types_for_use.each do |type|

      # replace store to enterprise-client if needed
      type = replace_store_to_enterprise_client_if_needed(type)

      puts("Prepare environment for #{type.class.name}")
      type.prepare_environment
    end
  end

  def perform_signing_validation
    # perform validation for all needed env
    build_types_for_use.each do |type|
      # download signing files
      type.download_signing_files

      # replace store to enterprise-client if needed
      type = replace_store_to_enterprise_client_if_needed(type)

      puts("Perform signing validation for #{type.class.name}".colorize(:yellow))
      type.perform_signing_validation
    end
  end

  def build
    # build each one of the env
    build_types_for_use.each do |type|
      # replace store to enterprise-client if needed
      type = replace_store_to_enterprise_client_if_needed(type)

      puts("Building for #{type.class.name}")

      # prepare env if this is not the initially requested build type (like store + debug =>> prepare debug)
      type.prepare_environment if build_type != type.build_type
      type.build
    end
  end

  def build_type
    envHelper = EnvironmentHelper.new
    if !envHelper.distribution_key_url.to_s.strip.empty? && envHelper.with_release == 'true'
      'store'
    else
      if !envHelper.debug_distribution_key_url.to_s.strip.empty?
        'enterprise' # enterprise client release/debug depending on provided provisioning
      else
        'debug'
      end
    end
  end

  def prepare_environment_build_types_for_use
    buildtypes = []
    case build_type
    when 'enterprise'
      buildtypes = [
        EnterpriseClient.new(fastlane: @fastlane)
      ]
    when 'store'
      buildtypes = [
        Store.new(fastlane: @fastlane)
      ]
    when 'debug'
      buildtypes = [
        EnterpriseDebug.new(fastlane: @fastlane)
      ]
    end
    buildtypes
  end

  def build_types_for_use
    buildtypes = []
    case build_type
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
    if type.build_type == "store" && type.isEnterpriseBuild
      puts("Switching to Enterprise client build".colorize(:red))

      type = EnterpriseClient.new(fastlane: @fastlane)
    end
    type
  end
end
