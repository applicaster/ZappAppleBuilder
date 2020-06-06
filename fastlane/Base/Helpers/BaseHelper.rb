require 'fastlane/action'
require 'fastlane_core'
require 'fastlane'
require 'openssl'
require 'date'
require 'colorize'

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
      current(__callee__.to_s)
      filename = "#{params_folder_path}/#{name}"
      if File.exist? "#{filename}"
          File.read("#{filename}").strip
      end
    end

    def save_param_to_file(name, value)
      current(__callee__.to_s)
      filename = "#{params_folder_path}/#{name}"
      Dir.mkdir(params_folder_path) unless File.exists?(params_folder_path)
      File.open(filename,"w") do |f|
        f.write(value)
        end
    end

    def saved_param_filename(name) 
      "#{params_folder_path}/#{name}"
    end

    def delete_keychain(options)
      current(__callee__.to_s)
      Actions::DeleteKeychainAction.run(
			  name: options[:name]
      )
    end

    def update_url_schemes(options)
      current(__callee__.to_s)
      Actions::UpdateUrlSchemesAction.run(
        path: "#{options[:plist_path]}",
        update_url_schemes: proc do |schemes|
          schemes + ["#{options[:scheme]}"]
        end
      )
    end

    def get_plist_value(options)
      current(__callee__.to_s)
      Actions::GetInfoPlistValueAction.run(
        path: options[:plist_path],
        key: options[:key]
      )
    end

    def update_app_identifier(options)
      current(__callee__.to_s)
      Actions::UpdateAppIdentifierAction.run(
        xcodeproj: options[:xcodeproj],
        plist_path: options[:plist_path],
        app_identifier: options[:app_identifier]
      )
    end
    
    def update_info_plist_versions(options)
      current(__callee__.to_s)
      Actions::UpdateInfoPlistAction.run(
        xcodeproj: options[:xcodeproj],
        plist_path: options[:plist_path],
        block: lambda do |plist|
          plist['CFBundleVersion'] = options[:bundle_version]
          plist['CFBundleShortVersionString'] =  options[:bundle_short_version]
        end
      )
    end

    def reset_info_plist_bundle_identifier(options)
      current(__callee__.to_s)
      Actions::UpdateInfoPlistAction.run(
        xcodeproj: options[:xcodeproj],
        plist_path: options[:plist_path],
        block: lambda do |plist|
          plist['CFBundleIdentifier'] = "$(PRODUCT_BUNDLE_IDENTIFIER)"
        end
      )
    end

    def update_project_team(options)
      current(__callee__.to_s)
      Actions::UpdateProjectTeamAction.run(
        path: options[:xcodeproj],
        teamid: options[:teamid]
      )
    end

    def create_app_on_dev_portal(options)
      current(__callee__.to_s)
      # create app on developer portal with new identifier for notification extension
      Actions::ProduceAction.run(
        username: "#{options[:username]}",
        app_identifier: "#{options[:bundle_identifier]}",
        team_id: "#{options[:team_id]}",
        app_name: "#{options[:app_name]}",
        language: "English",
        app_version: "1.0",
        sku: "#{options[:bundle_identifier]}.#{options[:app_index]}",
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
      
    def enterprise_debug_create_provisioning_profile(options)
      current(__callee__.to_s)
      sh("fastlane sigh " \
        "--username \"#{options[:username]}\" " \
        "--app_identifier \"#{options[:bundle_identifier]}\" " \
        "--team_id \"#{options[:team_id]}\" " \
        "--provisioning_name \"#{options[:bundle_identifier]} prov profile\" " \
        "--cert_owner_name \"#{options[:team_name]}\" " \
        "--filename \"#{options[:bundle_identifier]}.mobileprovision\" " \
        "--platform \"#{@@envHelper.platform_name}\" "
      )

      provisioning_profile_uuid = sh("echo $(/usr/libexec/PlistBuddy -c 'Print :UUID' /dev/stdin <<< $(security cms -D -i \"#{@@envHelper.root_path}/fastlane/#{options[:bundle_identifier]}.mobileprovision\")) | tr -d '\040\011\012\015'")
      save_param_to_file("#{options[:bundle_identifier]}_PROFILE_UDID", "#{provisioning_profile_uuid}")

      # delete Invalid provisioning profiles for the same app
      delete_invalid_provisioning_profiles(options)
    end
      
    def delete_invalid_provisioning_profiles(options)
      current(__callee__.to_s)

      password = ENV['FASTLANE_PASSWORD']
      Spaceship::Portal.login(options[:username], options[:password])
      Spaceship::Portal.client.team_id = options[:team_id]
    
      profiles = Spaceship::Portal::ProvisioningProfile.all.find_all do |profile|
        (profile.status == "Invalid" or profile.status == "Expired") && profile.app.bundle_id == options[:bundle_identifier]
      end
    
      profiles.each do |profile|
        sh("echo 'Deleting #{profile.name}, status: #{profile.status}'")
        profile.delete!
      end
    end

    def copy_artifacts(options)
      current(__callee__.to_s)
      Actions::CopyArtifactsAction.run(
        target_path: options[:target_path],
        artifacts: options[:artifacts]
      )
    end
      
    def import_certificate(options) 
      current(__callee__.to_s)
      Actions::ImportCertificateAction.run(
        certificate_path: options[:certificate_path],
        certificate_password: options[:certificate_password],
        keychain_name: options[:keychain_name],
        keychain_password: options[:keychain_password]
      )
    end

    def create_push_certificate(options)
      current(__callee__.to_s)
      Actions::GetPushCertificateAction.run(
        username: "#{options[:username]}",
        team_id: "#{options[:team_id]}",
        team_name: "#{options[:team_name]}",
        app_identifier: "#{options[:bundle_identifier]}",
        generate_p12: true,
        p12_password: "#{options[:p12_password]}",
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
      current(__callee__.to_s)
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

    def current(name)
      puts "#method: #{name}".colorize(:white ).colorize( :background => :blue)
    end
end