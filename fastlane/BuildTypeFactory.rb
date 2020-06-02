import "Base/Helpers/EnvironmentHelper.rb"

class BuildTypeFactory

    def create()
        case build_type()
        when "enterprise"
            EnterpriseClient.new
        when "store"
            Store.new
        when "debug"
            EnterpriseDebug.new
        end
    end

    def build_type
        envHelper = EnvironmentHelper.new

        if envHelper.distribution_key_url.to_s.strip.empty? 
            "debug"
        else
            if envHelper.with_release == 'true'
                "store"
            else
                "enterprise"
            end
        end
    end
end