fastlane_require 'dotenv'
fastlane_require 'spaceship'

import "Base/Base.rb"

platform :ios do

	lane :store do

		prepare_store_app_signing()
		prepare_store_app_for_build()

		# get provisioning profiles specifiers
		main_prov_profile_specifier = store_app_provisioning_profile_uuid
		notification_service_extension_prov_profile_specifier = app_extension_provisioning_profile_uuid(notification_service_extension_key)
		notification_content_extension_prov_profile_specifier = app_extension_provisioning_profile_uuid(notification_content_extension_key)

		build_path = "#{ENV['PWD']}/build"

		unlock_keychain(
			path: keychain_name,
			password: keychain_password
		)

		build_app(
		  clean: true,
		  workspace: "#{xcworkspace_relative_path}",
		  scheme: project_scheme,
		  configuration: build_configuration,
		  include_bitcode: true,
		  include_symbols: true,
		  output_directory: "CircleArtifacts/Store",
		  buildlog_path: "CircleArtifacts/Store",
		  output_name: "#{project_scheme}-Store",
		  build_path: build_path,
		  derived_data_path: build_path,
		  xcargs: "DEVELOPMENT_TEAM='#{store_team_id}' "\
					"-UseModernBuildSystem=NO "\
					"NOTIFICATION_SERVICE_EXTENSION_PROV_PROFILE_SPECIFIER='#{notification_service_extension_prov_profile_specifier}' "\
					"NOTIFICATION_CONTENT_EXTENSION_PROV_PROFILE_SPECIFIER='#{notification_content_extension_prov_profile_specifier}' "\
					"DEBUG_INFORMATION_FORMAT='dwarf-with-dsym' "\
					"PROVISIONING_PROFILE_SPECIFIER='#{main_prov_profile_specifier}'",
		  export_team_id: store_team_id,
		  export_method: "app-store",
		  export_options: {
				compileBitcode: true,
				provisioningProfiles: {
					bundle_identifier => main_prov_profile_specifier,
				  	notification_service_extension_bundle_identifier => "#{notification_service_extension_prov_profile_specifier}",
				  	notification_content_extension_bundle_identifier => "#{notification_content_extension_prov_profile_specifier}"
				}
		  }
		)

		delete_keychain(name: keychain_name)

		copy_artifacts(
			target_path: "CircleArtifacts/Store",
			artifacts: [
			 "Credentials/dist.mobileprovision",
			 "Credentials/dist.p12"
			]
		)

		puts("Starting app delivery to AppStoreConnect using altool")
		deliver_output = capture_stream($stdout) {
			altool(
				altool_username: "#{store_username}",
				altool_password: "#{store_password}",
				altool_app_type: "appletvos",
				altool_ipa_path: "CircleArtifacts/Store/#{project_scheme}-Store.ipa",
				altool_output_format: "xml",
			)
		}

		# print deliver output
		puts("Altool output: #{deliver_output}")

		# raise an error if the delover output has an error
		raise RuntimeError, 'Error posting the app to the App Store Connect' if deliver_output.include?('ERROR ITMS-')

		# upload to ms app center
		upload_application(bundle_identifier,
			"Store",
			"release"
		)
	end

	def prepare_store_app_signing()
		# create new dir for files
		sh("mkdir -p \"#{store_credentials_folder}\"")
		# download p12 and provisioning profile
		sh("curl -sL \"#{ENV['provisioning_profile_url']}\" --output \"#{store_credentials_folder}#{distribution_provisioning_profile_filename}\"")
		sh("curl -sL \"#{ENV['distribution_key_url']}\" --output \"#{store_credentials_folder}#{distribution_certificate_filename}\"")

		# fetch values
		ENV['STORE_TEAM_ID'] = sh("echo $(/usr/libexec/PlistBuddy -c 'Print :Entitlements:com.apple.developer.team-identifier' /dev/stdin <<< $(security cms -D -i \"#{store_credentials_folder}#{distribution_provisioning_profile_filename}\")) | tr -d '\040\011\012\015'")
		ENV['STORE_TEAM_NAME'] = sh("echo $(/usr/libexec/PlistBuddy -c 'Print :TeamName' /dev/stdin <<< $(security cms -D -i \"#{store_credentials_folder}#{distribution_provisioning_profile_filename}\")) | tr -d '\011\012\015'")
		ENV['STORE_PROVISIONING_PROFILE_UUID'] = sh("echo $(/usr/libexec/PlistBuddy -c 'Print :UUID' /dev/stdin <<< $(security cms -D -i \"#{store_credentials_folder}#{distribution_provisioning_profile_filename}\")) | tr -d '\040\011\012\015'")

		# install provisioning profile
		sh("mkdir -p ~/Library/MobileDevice/'Provisioning Profiles'")
		sh("cp #{store_credentials_folder}#{distribution_provisioning_profile_filename} ~/Library/MobileDevice/'Provisioning Profiles'/#{store_app_provisioning_profile_uuid}.mobileprovision")

		create_temp_keychain()

		import_certificate(
			certificate_path: "#{store_credentials_folder}#{distribution_certificate_filename}",
			certificate_password: store_distribution_certificate_password,
			keychain_name: keychain_name,
			keychain_password: keychain_password
		)

		sh("bundle exec fastlane fastlane-credentials add --username #{store_username} --password '#{store_password}'")
		ENV['FASTLANE_PASSWORD']=store_password
	end

	def prepare_store_app_for_build()
		# update app base parameters in FeaturesCustomization.json
		update_parameters_in_feature_optimization_json()

		# update ms_app_center app secret
		ms_app_center_update_app_secret("#{bundle_identifier}")

		# update firebase configuration
		firebase_add_configuration_file("production")

		# update app identifier to the store one
		info_plist_reset_to_bundle_identifier_placeholder(xcodeproj_path, project_info_plist_inner_path)
		update_app_identifier(
			xcodeproj: xcodeproj_path,
			plist_path: project_info_plist_inner_path,
			app_identifier: bundle_identifier
		)

		# add support for push notifications
		project_change_system_capability(
			"com.apple.Push",
			0,
			1
		)

		# add AccessWiFi if needed
		add_wifi_system_capability_if_needed()

		prepare_store_app_extensions()
  	end

	def prepare_store_app_extensions()
		build_type = "store"
		app_extensions_prepare_notification_extension(
			build_type,
			notification_service_extension_key,
			notification_service_extension_target_name,
			notification_service_extension_bundle_identifier,
			notification_service_extension_info_plist_inner_path,
			notification_service_extension_info_plist_path
		)

		app_extensions_prepare_notification_extension(
			build_type,
			notification_content_extension_key,
			notification_content_extension_target_name,
			notification_content_extension_bundle_identifier,
			notification_content_extension_info_plist_inner_path,
			notification_content_extension_info_plist_path
		)
	end

	def store_username
		"#{ENV['itunes_connect_user']}"
	end

	def store_password
		"#{ENV['itunes_connect_password']}"
	end

	def store_team_id
		"#{ENV['STORE_TEAM_ID']}"
	end

	def store_team_name
		"#{ENV['STORE_TEAM_NAME']}"
	end

	def store_distribution_certificate_password
		"#{ENV['distribution_key_password']}"
	end

	def store_credentials_folder
			"#{project_path}/Credentials/"
	end

	def store_app_provisioning_profile_uuid
		"#{ENV['STORE_PROVISIONING_PROFILE_UUID']}"
	end

end
