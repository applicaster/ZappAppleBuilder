
    def isTvOS 
        ENV["device_target"] == "apple_tv" ? true : false
    end

    def device_target
        ENV["device_target"]
    end

    def version_name 
        ENV["version_name"]
    end

    def build_version
        ENV["build_version"]
    end

    def store 
        ENV["store"]
    end

    def appCenterDeviceIdentifier 
        ENV["device_target"] == "apple_tv" ? "tvos" : "ios"
    end 

    def accountsAccountId
        ENV["accounts_account_id"]
    end

    def s3BucketName
        ENV["S3_BUCKET_NAME"]
    end

    def awsRegion
        ENV["AWS_REGION"]
    end

    def project_scheme
        ENV["device_target"] == "apple_tv" ? "ZappTvOS" : "ZappiOS"
    end

    def build_configuration 
        "Release"
    end

    def project_name 
        ENV["project_name"]
    end
    
    def keychain_name 
        "zapp-apple-build.keychain"
    end

    def keychain_password 
        "circle"
    end

    def project_name 
        "ZappApple"
    end

    def project_path 
        "#{ENV['PWD']}/#{ENV['project_name']}.xcodeproj"
    end

    def project_folder
        ENV['PWD']
    end

    def app_name_notifications 
        "#{ENV['bundle_identifier']}.notification"
    end 

    def app_name 
        ENV['app_name']
    end 