require 'fastlane/action'
require 'fastlane_core'
require 'fastlane'
require 'openssl'
require 'date'
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
      puts("func: read_param_from_file")
      filename = "#{params_folder_path}/#{name}"
      if File.exist? "#{filename}"
          File.read("#{filename}").strip
      end
    end

    def save_param_to_file(name, value)
      puts("func: save_param_to_file")
      filename = "#{params_folder_path}/#{name}"
      Dir.mkdir(params_folder_path) unless File.exists?(params_folder_path)
      File.open(filename,"w") do |f|
        f.write(value)
        end
    end

    def saved_param_filename(name) 
      "#{params_folder_path}/#{name}"
    end

    def create_temp_keychain()
      puts("func: create_temp_keychain")
      Actions::CreateKeychainAction.run(
        name: @@envHelper.keychain_name,
        password: @@envHelper.keychain_password,
        unlock: true,
        timeout: 3600,
        lock_when_sleeps: true
      )
    end

    def unlock_keychain(options)
      puts("func: unlock_keychain")
      Actions::UnlockKeychainAction.run(
			  path: options[:keychain_path],
			  password: options[:keychain_password]
      )
    end

    def delete_keychain(options)
      puts("func: delete_keychain")
      Actions::DeleteKeychainAction.run(
			  name: options[:name]
      )
    end

    def update_url_schemes(options)
      puts("func: update_url_schemes")
      Actions::UpdateUrlSchemesAction.run(
        path: "#{options[:plist_path]}",
        update_url_schemes: proc do |schemes|
          schemes + ["#{options[:scheme]}"]
        end
      )
    end

    def get_plist_value(options)
      puts("func: get_plist_value")
      Actions::GetInfoPlistValueAction.run(
        path: options[:plist_path],
        key: options[:key]
      )
    end

    def update_app_identifier(options)
      puts("func: update_app_identifier")
      Actions::UpdateAppIdentifierAction.run(
        xcodeproj: options[:xcodeproj],
        plist_path: options[:plist_path],
        app_identifier: options[:app_identifier]
      )
    end
    
    def update_info_plist_versions(options)
      puts("func: update_info_plist_versions")
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
      puts("func: reset_info_plist_bundle_identifier")
      Actions::UpdateInfoPlistAction.run(
        xcodeproj: options[:xcodeproj],
        plist_path: options[:plist_path],
        block: lambda do |plist|
          plist['CFBundleIdentifier'] = "$(PRODUCT_BUNDLE_IDENTIFIER)"
        end
      )
    end

    def create_app_on_dev_portal(options)
      puts("func: create_app_on_dev_portal")
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
      
    def create_provisioning_profile(options)
      puts("func: create_provisioning_profile")
      # create download and install new provisioning profile for the app
      sh("fastlane ios create_provisioning_profile " \
          "username:\"#{options[:username]}\" " \
          "app_identifier:\"#{options[:bundle_identifier]}\" " \
          "team_id:\"#{options[:team_id]}\" " \
          "provisioning_name:\"#{options[:bundle_identifier]} prov profile\" " \
          "cert_owner_name:\"#{options[:team_name]}\" " \
          "filename:\"#{options[:bundle_identifier]}.mobileprovision\" " \
          "platform:\"#{@@envHelper.platform_name}\" "
      )
      
      # delete Invalid provisioning profiles for the same app
      delete_invalid_provisioning_profiles(options)
    end
      
    def delete_invalid_provisioning_profiles(options)
      puts("func: delete_invalid_provisioning_profiles")

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
      
    def import_certificate(options) 
      puts("func: import_certificate")
      Actions::ImportCertificateAction.run(
        certificate_path: options[:certificate_path],
        certificate_password: options[:certificate_password],
        keychain_name: options[:keychain_name],
        keychain_password: options[:keychain_password]
      )
    end

    def create_push_certificate(options)
      puts("func: create_push_certificate")
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
      puts("func: build_app")
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

    def validate_distribution_certificate_expiration(options)
      puts("func: validate_distribution_certificate_expiration")
      error_message = "Distrubution Certificate expired"
      begin
        expire_date = sh("openssl pkcs12 " \
          "-in #{options[:certificate_path]} " \
          "-nokeys " \
          "-passin pass:#{options[:certificate_password]} " \
          "| openssl x509 -noout -enddate " \
          "| grep notAfter " \
          "| sed -e 's#notAfter=##'"
        )

        raise error_message unless Date.parse(expire_date) > Date.new
      rescue => ex
        raise error_message
      end
    end

    def validate_distribution_certificate_password(options)
      puts("func: validate_distribution_certificate_password")
      error_message = "Incorrect password for Distrubution Certificate"
      begin
        result = sh("openssl pkcs12 " \
          "-in #{options[:certificate_path]} " \
          "-nokeys " \
          "-passin pass:#{options[:certificate_password]} " \
          "| grep -c 'BEGIN CERTIFICATE'"
        )
        raise error_message unless result.lines.last.to_i() > 0
      rescue => ex
        raise error_message
      end  
    end


    def validate_distribution_certificate_and_provisioning_profile_team_id(options)
      puts("func: validate_distribution_certificate_and_provisioning_profile_team_id")
      error_message = "Unable to fetch Team ID from distribution certificate"
      begin
        result = sh("openssl pkcs12 " \
          "-in #{options[:certificate_path]} " \
          "-nokeys " \
          "-passin pass:#{options[:certificate_password]} " \
          "| openssl x509 -noout -subject " \
          "| awk -F'[=,/]' '{print $3}'``"

        )
        raise error_message unless result.length > 0

        # get provisioning profile team identifier
        provisioning_profile_team_identifier = sh("echo $(/usr/libexec/PlistBuddy -c 'Print :TeamIdentifier' /dev/stdin <<< $(security cms -D -i \"#{options[:provisioning_profile_path]}\") | sed -e 1d -e '$d')")

        # remove white spaces 
        provisioning_profile_team_identifier = provisioning_profile_team_identifier.chomp.strip
        distribution_certificate_team_identifier = result.chomp.strip

        # raise exc if no match
        error_message = "Provisioning Profile is not signed with provided Distribution Certificate"
        raise "#{error_message} (#{distribution_certificate_team_identifier} != #{provisioning_profile_team_identifier})" unless distribution_certificate_team_identifier == provisioning_profile_team_identifier
      rescue => ex
        raise ex.message
      end 
      
      
    end
end