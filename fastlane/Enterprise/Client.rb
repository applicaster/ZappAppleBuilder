import "Enterprise/Base/Base.rb"

fastlane_require 'dotenv'

platform :ios do

	lane :enterprise_client do

		prepare_client_enterprise_app_signing()
		prepare_client_enterprise_app_for_build()

		# get provisioning profiles specifiers
		main_prov_profile_specifier = enterprise_client_app_provisioning_profile_uuid
		notification_service_extension_prov_profile_specifier = app_extension_provisioning_profile_uuid(notification_service_extension_key)
		notification_content_extension_prov_profile_specifier = app_extension_provisioning_profile_uuid(notification_content_extension_key)

		build_path = "#{ENV['PWD']}/build"
		gym(
			workspace: "#{xcworkspace_relative_path}",
			scheme: project_scheme,
			configuration: build_configuration,
			include_bitcode: true,
			include_symbols: true,
			output_directory: "CircleArtifacts/Enterprise",
			buildlog_path: "CircleArtifacts/Enterprise",
			output_name: "#{project_scheme}-Enterprise",
			build_path: build_path,
			derived_data_path: build_path,
			xcargs: "RELEASE_SWIFT_OPTIMIZATION_LEVEL='-O' "\
					"-UseModernBuildSystem=NO "\
					"RELEASE_COPY_PHASE_STRIP=NO "\
					"PROVISIONING_PROFILE='#{main_prov_profile_specifier}' "\
					"NOTIFICATION_SERVICE_EXTENSION_PROV_PROFILE_SPECIFIER='#{notification_service_extension_prov_profile_specifier}' "\
					"NOTIFICATION_CONTENT_EXTENSION_PROV_PROFILE_SPECIFIER='#{notification_content_extension_prov_profile_specifier}' "\
					"DEBUG_INFORMATION_FORMAT='dwarf-with-dsym'",
			export_method: "enterprise",
			export_team_id: enterprise_client_team_id,
			export_options: {
						compileBitcode: false,
						provisioningProfiles: {
						bundle_identifier => "#{main_prov_profile_specifier}",
						notification_service_extension_bundle_identifier => "#{notification_service_extension_prov_profile_specifier}",
						notification_content_extension_bundle_identifier => "#{notification_content_extension_prov_profile_specifier}"
						}
			}
		)

		perform_post_build_procedures()
	end

	def perform_post_build_procedures()
		base_ent_perform_post_build_procedures()

		# upload to ms app center
		upload_application(bundle_identifier,
			"Enterprise",
			"release"
		)
	end

	def prepare_client_enterprise_app_signing()

		# create new dir for files
		sh("mkdir -p \"#{enterprise_credentials_folder}\"")
		# download p12 and provisioning profile
		sh("curl -sL \"#{ENV['provisioning_profile_url']}\" --output \"#{enterprise_credentials_folder}#{distribution_provisioning_profile_filename}\"")
		sh("curl -sL \"#{ENV['distribution_key_url']}\" --output \"#{enterprise_credentials_folder}#{distribution_certificate_filename}\"")

		# fetch values
		ENV['ENTERPRISE_CLIENT_TEAM_ID'] = sh("echo $(/usr/libexec/PlistBuddy -c 'Print :Entitlements:com.apple.developer.team-identifier' /dev/stdin <<< $(security cms -D -i \"#{enterprise_credentials_folder}#{distribution_provisioning_profile_filename}\")) | tr -d '\040\011\012\015'")
		ENV['ENTERPRISE_CLIENT_TEAM_NAME'] = sh("echo $(/usr/libexec/PlistBuddy -c 'Print :TeamName' /dev/stdin <<< $(security cms -D -i \"#{enterprise_credentials_folder}#{distribution_provisioning_profile_filename}\")) | tr -d '\011\012\015'")
		ENV['ENTERPRISE_CLIENT_PROVISIONING_PROFILE_UUID'] = sh("echo $(/usr/libexec/PlistBuddy -c 'Print :UUID' /dev/stdin <<< $(security cms -D -i \"#{enterprise_credentials_folder}#{distribution_provisioning_profile_filename}\")) | tr -d '\040\011\012\015'")

		# install provisioning profile
		sh("mkdir -p ~/Library/MobileDevice/'Provisioning Profiles'")
		sh("cp #{enterprise_credentials_folder}#{distribution_provisioning_profile_filename} ~/Library/MobileDevice/'Provisioning Profiles'/#{enterprise_client_app_provisioning_profile_uuid}.mobileprovision")

		base_ent_prepare_enterprise_app_signing(
      		store_username,
      		store_password,
      		store_password
		)

		unlock_keychain(
			path: keychain_name,
			password: keychain_password
		)
	end

	def prepare_client_enterprise_app_for_build()
		base_ent_prepare_enterprise_app_for_build()

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

		prepare_enterprise_app_extensions()
  	end

	def prepare_enterprise_app_extensions()
		prepare_enterprise_app_notification_service_extension()
		prepare_enterprise_app_notification_content_extension()
	end


	def prepare_enterprise_app_notification_service_extension()
		extension_type = notification_service_extension_key
		entension_enabled = sh("echo $(/usr/libexec/PlistBuddy -c \"Print :SupportedAppExtensions:#{extension_type}:enterprise_enabled\" #{customizations_folder_path}/FeaturesCustomization.plist 2>/dev/null | grep -c true)")
    	if entension_enabled.to_i() > 0
			# print extension enabled
			sh("echo '#{extension_type} enabled'")

			# update app identifier, versions of the notification extension
			info_plist_update_values(
				notification_service_extension_target_name,
				notification_service_extension_bundle_identifier
			)

			# save app identifier of the notification extension
			ENV['identifier_notifications'] = get_info_plist_value(path: "#{notification_service_extension_info_plist_path}", key: "CFBundleIdentifier")
			# change app groups support on project file
			project_change_system_capability(
				"com.apple.ApplicationGroups.iOS",
				0,
				1
			)

			# update app identifier for to the notification extension
			info_plist_reset_to_bundle_identifier_placeholder(xcodeproj_path, notification_service_extension_info_plist_inner_path)
			update_app_identifier(
				xcodeproj: xcodeproj_path,
				plist_path: notification_service_extension_info_plist_inner_path,
				app_identifier: notification_service_extension_bundle_identifier
			)

		else
			# notification extension disabled
			sh("echo 'Push Notification extension disabled'")
			# remove extension from build dependency and scripts step
			app_extensions_remove_from_project(
				"#{notification_service_extension_target_name}"
			)
		end
	end

	def prepare_enterprise_app_notification_content_extension()
		extension_type = notification_content_extension_key
		entension_enabled = sh("echo $(/usr/libexec/PlistBuddy -c \"Print :SupportedAppExtensions:#{extension_type}:enterprise_enabled\" #{customizations_folder_path}/FeaturesCustomization.plist 2>/dev/null | grep -c true)")
    	if entension_enabled.to_i() > 0
			# print extension enabled
			sh("echo '#{extension_type} enabled'")

			# update app identifier, versions of the notification extension
			info_plist_update_values(
				notification_content_extension_target_name,
				notification_content_extension_bundle_identifier
			)

			# save app identifier of the notification extension
			ENV['identifier_notifications'] = get_info_plist_value(path: "#{notification_content_extension_info_plist_path}", key: "CFBundleIdentifier")
			# change app groups support on project file
			project_change_system_capability(
				"com.apple.ApplicationGroups.iOS",
				0,
				1
			)

			# update app identifier for to the notification extension
			info_plist_reset_to_bundle_identifier_placeholder(xcodeproj_path, notification_content_extension_info_plist_inner_path)
			update_app_identifier(
				xcodeproj: xcodeproj_path,
				plist_path: notification_content_extension_info_plist_inner_path,
				app_identifier: notification_content_extension_bundle_identifier
			)

		else
			# notification extension disabled
			sh("echo 'Push Notification extension disabled'")
			# remove extension from build dependency and scripts step
			app_extensions_remove_from_project(
				"#{notification_content_extension_target_name}"
			)
		end
	end

	def enterprise_credentials_folder
	    "#{project_path}/Credentials/"
	end

	def enterprise_distribution_certificate_password
	  "#{ENV['distribution_key_password']}"
	end

	def enterprise_client_app_provisioning_profile_uuid
	  "#{ENV['ENTERPRISE_CLIENT_PROVISIONING_PROFILE_UUID']}"
	end

	def enterprise_client_team_id
		"#{ENV['ENTERPRISE_CLIENT_TEAM_ID']}"
	end

	def enterprise_client_team_name
		"#{ENV['ENTERPRISE_CLIENT_TEAM_NAME']}"
	end
end
