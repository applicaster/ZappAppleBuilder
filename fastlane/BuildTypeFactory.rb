# frozen_string_literal: true

require 'colorize'

import 'Base/Helpers/EnvironmentHelper.rb'

class BuildTypeFactory
  def prepare_environment
    # prepare only specific env to build
    buildtypes = []
    case build_type
    when 'enterprise'
      buildtypes = [EnterpriseClient.new]
    when 'store'
      buildtypes = [Store.new]
    when 'debug'
      buildtypes = [EnterpriseDebug.new]
    end

    buildtypes.each do |type|
      puts("Prepare environment for #{type.class.name}")
      type.prepare_environment
    end
  end

  def perform_signing_validation
    # perform validation for all needed env
    buildtypes = []
    case build_type
    when 'enterprise'
      buildtypes = [EnterpriseClient.new, EnterpriseDebug.new]
    when 'store'
      buildtypes = [Store.new, EnterpriseDebug.new]
    when 'debug'
      buildtypes = [EnterpriseDebug.new]
    end

    buildtypes.each do |type|
      puts("Perform signing validation for #{type.class.name}".colorize(:yellow))
      type.perform_signing_validation
    end
  end

  def build
    # build each one of the env
    buildtypes = []
    curent_build_type = build_type
    case curent_build_type
    when 'enterprise'
      buildtypes = [EnterpriseClient.new, EnterpriseDebug.new]
    when 'store'
      buildtypes = [Store.new, EnterpriseDebug.new]
    when 'debug'
      buildtypes = [EnterpriseDebug.new]
    end

    buildtypes.each do |type|
      puts("Building for #{type.class.name}")

      # prepare env if this is not the initially requested build type (like store + debug =>> prepare debug)
      type.prepare_environment if curent_build_type != type.build_type
      type.build
    end
  end

  def build_type
    envHelper = EnvironmentHelper.new
    if envHelper.distribution_key_url.to_s.strip.empty?
      'debug'
    else
      if envHelper.with_release == 'true'
        'store'
      else
        'enterprise'
      end
    end
  end
end
