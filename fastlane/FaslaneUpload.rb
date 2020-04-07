platform :ios do
    before_all do
        device_family = ENV["device_target"]
        ENV["DEVICE_FAMILY"] = "1,2"
        if device_family == "iphone"
        ENV["DEVICE_FAMILY"] = "1"
        end
        if device_family == "ipad"
        ENV["DEVICE_FAMILY"] = "2"
        end

        unless ENV['bundle_identifier'].to_s.strip.empty?          
            if isTvOS
                puts("Installing S3 AWS")
                sh("sudo pip install awscli")
            else 
                puts("Fetching App Center identifiers ms_app_center:fetch_identifiers[#{ENV['bundle_identifier']}]")
                sh("bundle exec rake ms_app_center:fetch_identifiers[#{ENV['bundle_identifier']}]")
            end
        else 
            puts("Skipping the step, no bundle_identifier available.")
        end
    end

    def upload_application(bundle_identifier, distribute_type, build_configuration)
        if isTvOS 
            puts("Upload application to S3")
            s3DestinationPathParams = s3_upload_path(bundle_identifier)
            s3DistanationPath = "#{s3BucketName}/#{s3DestinationPathParams}"
            sh("aws --region #{awsRegion} s3 sync ../CircleArtifacts/#{distribute_type} s3://#{s3DistanationPath} --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers --delete")
            save_build_params_for_type(bundle_identifier, distribute_type, nil, nil)
        else
            puts("Upload application to MS App Center")
            ms_app_center_upload_app(bundle_identifier, distribute_type, build_configuration)
        end
    end

    def update_app_secret(bundle_identifier)
        
        if isTvOS == false 
            puts("Update MS App Center's secret")
            ms_app_center_update_app_secret(bundle_identifier)
        end
    end

    lane :publish_builds_to_zapp do
        # update zapp with new uploaded version
        version_id = "#{ENV['version_id']}"
        command = "bundle exec rake publish_to_zapp:update_zapp_version[\"#{version_id}\"]"
        sh("#{command}")
      end
end