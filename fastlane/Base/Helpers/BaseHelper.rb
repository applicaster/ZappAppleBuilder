require 'fastlane/action'
require 'fastlane_core'
require 'fastlane'
import "Base/Helpers/EnvironmentHelper.rb"

class BaseHelper 
    @@envHelper = EnvironmentHelper.new

    def sh(command)
        Actions::sh(command)
    end

    def params_folder_path
       "#{@@envHelper.root_path}/fastlane/.fastlane_params"
    end
    def read_param_from_file(name)
        filename = "#{params_folder_path}/#{name}"
        if File.exist? "#{filename}"
           File.read("#{filename}").strip
        end
    end

    def save_param_to_file(name, value)
        filename = "#{params_folder_path}/#{name}"
        Dir.mkdir(params_folder_path) unless File.exists?(params_folder_path)
        File.open(filename,"w") do |f|
          f.write(value)
         end
    end

    def saved_param_filename(name) 
      "#{params_folder_path}/#{name}"
    end


    def create_app_on_dev_portal(username, team_id, app_name, app_bundle, app_index)
        # create app on developer portal with new identifier for notification extension
        Actions::ProduceAction.run(
          username: "#{username}",
          app_identifier: "#{app_bundle}",
          team_id: "#{team_id}",
          app_name: "#{app_name}",
          language: "English",
          app_version: "1.0",
          sku: "#{app_bundle}.#{app_index}",
          skip_itc: true,
          enable_services: {
            app_group: "on",
            associated_domains: "on",
            data_protection: "complete",
            in_app_purchase: "on",
            push_notification: "on",
            access_wifi: "on"
          }
        )
    end
      
    def create_provisioning_profile(username, team_id, team_name, app_bundle)
        # create download and install new provisioning profile for the app
        sh("fastlane ios create_provisioning_profile " \
            "username:\"#{username}\" " \
            "app_identifier:\"#{app_bundle}\" " \
            "team_id:\"#{team_id}\" " \
            "provisioning_name:\"#{app_bundle} prov profile\" " \
            "cert_owner_name:\"#{team_name}\" " \
            "filename:\"#{app_bundle}.mobileprovision\" " \
            "platform:\"#{@@envHelper.platform_name}\" "
        )
        
        # delete Invalid provisioning profiles for the same app
        delete_invalid_provisioning_profiles(username, team_id, app_bundle)
    end
      
    def delete_invalid_provisioning_profiles(username, team_id, app_bundle)
        password = ENV['FASTLANE_PASSWORD']
        Spaceship::Portal.login(username, password)
        Spaceship::Portal.client.team_id = team_id
      
        profiles = Spaceship::Portal::ProvisioningProfile.all.find_all do |profile|
          (profile.status == "Invalid" or profile.status == "Expired") && profile.app.bundle_id == app_bundle
        end
      
        profiles.each do |profile|
          sh("echo 'Deleting #{profile.name}, status: #{profile.status}'")
          profile.delete!
        end
    end
      
    def create_push_certificate(username, team_id, team_name, app_bundle, p12_password)
        Actions::GetPushCertificateAction.run(
          username: "#{username}",
          team_id: "#{team_id}",
          team_name: "#{team_name}",
          app_identifier: "#{app_bundle}",
          generate_p12: true,
          p12_password: "#{p12_password}",
          pem_name: "apns",
          save_private_key: false,
          output_path: "./CircleArtifacts",
          active_days_limit: 30
        )
      
        command = "bundle exec "\
        "rake upload_enterprise_push:upload_certificate["\
        "#{ENV['accounts_account_id']},"\
        "#{ENV['bundle_identifier']},"\
        "#{circle_artifacts_folder_path},"\
        "apns.p12]"
      
        sh("#{command}")
    end

    def circle_artifacts_folder_path
        "#{@@envHelper.root_path}/CircleArtifacts"
    end

    def build_app(options)
      sh("fastlane gym " \
        "--workspace \"#{options[:workspace]}\" " \
        "--scheme \"#{options[:scheme]}\" " \
        "--configuration \"#{options[:configuration]}\" " \
        "--include_bitcode #{options[:include_bitcode]} " \
        "--include_symbols #{options[:include_symbols]} " \
        "--output_directory \"#{options[:output_directory]}\" " \
        "--buildlog_path \"#{options[:buildlog_path]}\" " \
        "--output_name \"#{options[:output_name]}\" " \
        "--build_path \"#{options[:build_path]}\" " \
        "--derived_data_path \"#{options[:derived_data_path]}\" " \
        "--xcargs \"#{options[:xcargs]}\" " \
        "--export_method \"#{options[:export_method]}\" " \
        "--export_team_id \"#{options[:export_team_id]}\" " \
        "--export_options \"#{options[:export_options]}\" " 
    )
    end
end