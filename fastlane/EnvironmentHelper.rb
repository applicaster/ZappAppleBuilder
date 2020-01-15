
    def device_target
        ENV["device_target"]
    end

    def platform_name
        device_target == "apple_tv" ? "tvos" : "ios"
    end

    def isTvOS
        device_target == "apple_tv" ? true : false
    end

    def appCenterDeviceIdentifier
        "#{platform_name}"
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

    def accountsAccountId
        ENV["accounts_account_id"]
    end

    def s3BucketName
        ENV["S3_BUCKET_NAME"]
    end

    def awsRegion
        ENV["AWS_REGION"]
    end

    def build_configuration
        "Release"
    end

    def keychain_name
        "zapp-apple-build.keychain"
    end

    def keychain_password
        "circle"
    end

    def project_name
        device_target == "apple_tv" ? "ZappTvOS" : "ZappiOS"
    end

    def project_folder_name
        "#{project_name}"
    end

    def project_scheme
        "#{project_name}"
    end

    def project_path
        "#{ENV['PWD']}/#{project_folder_name}"
    end

    def xcodeproj_path
        "#{project_path}/#{project_name}.xcodeproj"
    end

    def xcworkspace_relative_path
        "#{project_folder_name}/#{project_name}.xcworkspace"
    end

    def project_info_plist_inner_path
        "#{project_name}/Info.plist"
    end

    def project_info_plist_path
        "#{project_path}/#{project_info_plist_inner_path}"
    end

    def app_name
        ENV['app_name']
    end

    def bundle_identifier
        ENV['bundle_identifier']
    end
    def app_name_notifications
        "#{bundle_identifier}.notification"
    end
