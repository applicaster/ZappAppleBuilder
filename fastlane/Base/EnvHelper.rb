
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

    def customizations_folder_path
        "#{ENV['PWD']}/ZappApple/Customization"
    end

    def circle_artifacts_folder_path
        "#{ENV['PWD']}/CircleArtifacts"
    end

    def project_path
        "#{ENV['PWD']}/#{project_folder_name}"
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

    def distribution_provisioning_profile_filename
      "dist.mobileprovision"
    end

    def distribution_certificate_filename
      "dist.p12"
    end

    def s3_hostname
      ENV["s3_hostname"]
    end
