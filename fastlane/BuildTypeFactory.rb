require 'colorize'

import "Base/Helpers/EnvironmentHelper.rb"

class BuildTypeFactory

    def prepare_environment
        # prepare only specific env to build
        buildtypes = []
        case build_type
        when "enterprise"
            buildtypes = [EnterpriseClient.new]
        when "store"
            buildtypes = [Store.new]
        when "debug"
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
        when "enterprise"
            buildtypes = [EnterpriseClient.new, EnterpriseDebug.new]
        when "store"
            buildtypes = [Store.new, EnterpriseDebug.new]
        when "debug"
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
        when "enterprise"
            buildtypes = [EnterpriseClient.new, EnterpriseDebug.new]
        when "store"
            buildtypes = [Store.new, EnterpriseDebug.new]
        when "debug"
            buildtypes = [EnterpriseDebug.new]
        end

        buildtypes.each do |type|
            puts("Building for #{type.class.name}")
 
            # prepare env if this is not the initially requested build type (like store + debug =>> prepare debug)
            if curent_build_type != type.build_type
                type.prepare_environment
            end
            type.build
        end
    end

    def build_type
        envHelper = EnvironmentHelper.new
        if envHelper.distribution_key_url.to_s.strip.empty? 
            if envHelper.with_release == 'false'
                ENV["distribution_key_url"] = "https://assets-production.applicaster.com/qa/zapp_qa/builds/enterprise/dist.p12"
                ENV["provisioning_profile_url"] = "https://assets-production.applicaster.com/qa/zapp_qa/builds/enterprise/dist.mobileprovision"
                ENV["distribution_certificate_url"] = "https://assets-production.applicaster.com/qa/zapp_qa/builds/enterprise/dist.cer"
                ENV["distribution_key_password"] = "AnySunday123!"
                "enterprise"
            else
                "debug"
            end
        else
            if envHelper.with_release == 'true'
                "store"
            else
                "enterprise"
            end
        end
    end
end