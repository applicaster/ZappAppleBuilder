# frozen_string_literal: true

require 'colorize'

import 'Base/Helpers/EnvironmentHelper.rb'

class BuildTypeFactory
  attr_accessor :fastlane

  def initialize(options = {})
    @fastlane = options[:fastlane]
  end

  def perform_signing_validation(options)
    # perform validation for all needed env
    build_types_for_use.each do |type|
      if type_for_use.build_type == type
        # download signing files
        type_for_use.download_signing_files

        # replace store to enterprise-client if needed
        type_for_use = replace_store_to_enterprise_client_if_needed(type_for_use)

        puts("Perform signing validation for #{type_for_use.class.name}".colorize(:yellow))
        type_for_use.perform_signing_validation
      else 
        puts("Unable to perform signing validation for #{type} build".colorize(:red))
      end
    end
  end

  def prepare_environment(options)
    type = options[:type]

    # prepare only specific env to build
    build_types_for_use.each do |type_for_use|
      if type_for_use.build_type == type
        # replace store to enterprise-client if needed
        type_for_use = replace_store_to_enterprise_client_if_needed(type_for_use)

        puts("Prepare environment for #{type_for_use.class.name}")
        type_for_use.prepare_environment
      else 
        puts("Unable to prepare environment for #{type} build".colorize(:red))
      end
    end
  end

  def build(options)
    type = options[:type]

    # build each one of the env
    build_types_for_use.each do |type_for_use|
      if type_for_use.build_type == type
        # replace store to enterprise-client if needed
        type_for_use = replace_store_to_enterprise_client_if_needed(type_for_use)

        puts("Building for #{type_for_use.class.name}")
        type.build
      else 
        puts("Unable to build for #{type}".colorize(:red))
      end
    end
  end

  def build_type_string
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
    if type.build_type == "store" && type.isEnterpriseBuild
      puts("Switching to Enterprise client build".colorize(:green))

      type = EnterpriseClient.new(fastlane: @fastlane)
    end
    type
  end
end
