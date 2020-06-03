import "Base/BuildType.rb"

class Store < BuildType
	@team_id = ""
	@team_name = ""
	@provisioning_profile_uuid = ""

	def prepare_environment
		super
		prepare_signing()
		prepare_build()
		@@appCenterHelper.fetch_identifiers(@@envHelper.bundle_identifier)
	end
	
	def build()
		# get provisioning profiles specifiers
		main_prov_profile_specifier = @provisioning_profile_uuid
		notification_service_extension_prov_profile_specifier = app_extension_provisioning_profile_uuid(@@appExtensions.notification_service_extension_key)
		notification_content_extension_prov_profile_specifier = app_extension_provisioning_profile_uuid(@@appExtensions.notification_content_extension_key)
		
		unlock_keychain(
			path: @@envHelper.keychain_name,
			password: @@envHelper.keychain_password
		)
	
		build_app(
			clean: true,
			workspace: "#{@@projectHelper.xcworkspace_relative_path}",
			scheme: @@projectHelper.scheme,
			configuration: @@envHelper.build_configuration,
			include_bitcode: true,
			include_symbols: true,
			output_directory: "CircleArtifacts/Store",
			buildlog_path: "CircleArtifacts/Store",
			output_name: "#{@@projectHelper.scheme}-Store",
			build_path: @@projectHelper.build_path,
			derived_data_path: @@projectHelper.build_path,
			xcargs: "DEVELOPMENT_TEAM='#{@team_id}' "\
					"-UseModernBuildSystem=NO "\
					"NOTIFICATION_SERVICE_EXTENSION_PROV_PROFILE_SPECIFIER='#{notification_service_extension_prov_profile_specifier}' "\
					"NOTIFICATION_CONTENT_EXTENSION_PROV_PROFILE_SPECIFIER='#{notification_content_extension_prov_profile_specifier}' "\
					"DEBUG_INFORMATION_FORMAT='dwarf-with-dsym' "\
					"PROVISIONING_PROFILE_SPECIFIER='#{main_prov_profile_specifier}'",
			export_team_id: @team_id,
			export_method: "app-store",
			export_options: {
				compileBitcode: true,
				provisioningProfiles: {
					@@envHelper.bundle_identifier => main_prov_profile_specifier,
					@@appExtensions.notification_service_extension_bundle_identifier => "#{notification_service_extension_prov_profile_specifier}",
					@@appExtensions.notification_content_extension_bundle_identifier => "#{notification_content_extension_prov_profile_specifier}"
				}
			}
		)
	
		delete_keychain(name: @@envHelper.keychain_name)
	
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
				altool_username: "#{itunesconnect_username}",
				altool_password: "#{itunesconnect_password}",
				altool_app_type: "appletvos",
				altool_ipa_path: "CircleArtifacts/Store/#{@@projectHelper.scheme}-Store.ipa",
				altool_output_format: "xml",
			)
		}
	
		# print deliver output
		puts("Altool output: #{deliver_output}")
	
		# raise an error if the delover output has an error
		raise RuntimeError, 'Error posting the app to the App Store Connect' if deliver_output.include?('ERROR ITMS-')
	
		# upload to ms app center
		upload_application(@@envHelper.bundle_identifier,
			"Store",
			"release"
		)
	end
	
	def download_signing_files()
		# create new dir for files
		sh("mkdir -p \"#{@@projectHelper.credentials_folder_path}\"")
		# download p12 and provisioning profile
		sh("curl -sL \"#{@@envHelper.provisioning_profile_url}\" --output \"#{@@projectHelper.distribution_provisioning_profile_path}\"")
		sh("curl -sL \"#{@@envHelper.distribution_key_url}\" --output \"#{@@projectHelper.distribution_certificate_path}\"")
	end
	
	def perform_signing_validation
		download_signing_files()
		provisioning_profile_expiration_date = sh("echo $(/usr/libexec/PlistBuddy -c 'Print :ExpirationDate' /dev/stdin <<< $(security cms -D -i \"#{@@projectHelper.distribution_provisioning_profile_path}\")) | tr -d '\040\011\012\015'")
		provisioning_profile_team_identifier = sh("echo $(/usr/libexec/PlistBuddy -c 'Print :Entitlements:com.apple.developer.team-identifier' /dev/stdin <<< $(security cms -D -i \"#{@@projectHelper.distribution_provisioning_profile_path}\")) | tr -d '\040\011\012\015'")
		provisioning_profile_aps_environment = sh("echo $(/usr/libexec/PlistBuddy -c 'Print :Entitlements:aps-environment' /dev/stdin <<< $(security cms -D -i \"#{@@projectHelper.distribution_provisioning_profile_path}\")) | tr -d '\040\011\012\015'")
		provisioning_profile_application_dentifier = sh("echo $(/usr/libexec/PlistBuddy -c 'Print :Entitlements:com.apple.developer.application-identifier' /dev/stdin <<< $(security cms -D -i \"#{@@projectHelper.distribution_provisioning_profile_path}\")) | tr -d '\040\011\012\015'")
	end
	
	def prepare_signing()
		# fetch values
		@team_id = sh("echo $(/usr/libexec/PlistBuddy -c 'Print :Entitlements:com.apple.developer.team-identifier' /dev/stdin <<< $(security cms -D -i \"#{@@projectHelper.distribution_provisioning_profile_path}\")) | tr -d '\040\011\012\015'")
		@team_name = sh("echo $(/usr/libexec/PlistBuddy -c 'Print :TeamName' /dev/stdin <<< $(security cms -D -i \"#{@@projectHelper.distribution_provisioning_profile_path}\")) | tr -d '\011\012\015'")
		@provisioning_profile_uuid = sh("echo $(/usr/libexec/PlistBuddy -c 'Print :UUID' /dev/stdin <<< $(security cms -D -i \"#{@@projectHelper.distribution_provisioning_profile_path}\")) | tr -d '\040\011\012\015'")
	
		# install provisioning profile
		sh("mkdir -p ~/Library/MobileDevice/'Provisioning Profiles'")
		sh("cp #{@@projectHelper.distribution_provisioning_profile_path} ~/Library/MobileDevice/'Provisioning Profiles'/#{@provisioning_profile_uuid}.mobileprovision")
	
		create_temp_keychain()
	
		Actions::ImportCertificateAction.run(
			certificate_path: @@projectHelper.distribution_certificate_path,
			certificate_password: @@envHelper.distribution_key_password,
			keychain_name: @@envHelper.keychain_name,
			keychain_password: @@envHelper.keychain_password
		)
	
		sh("bundle exec fastlane fastlane-credentials add --username #{itunesconnect_username} --password '#{itunesconnect_password}'")
		ENV['FASTLANE_PASSWORD']=itunesconnect_password
	end
	
	def prepare_build()
		# update app base parameters in FeaturesCustomization.json
		update_parameters_in_feature_optimization_json()
	
		# update ms_app_center app secret
		@@appCenterHelper.update_app_secret("#{@@envHelper.bundle_identifier}")
	
		# update firebase configuration
		@@firebaseHelper.add_configuration_file("production")
	
		# update app identifier to the store one
		@@projectHelper.plist_reset_to_bundle_identifier_placeholder(@@projectHelper.xcodeproj_path, @@projectHelper.plist_inner_path)
		Actions::UpdateAppIdentifierAction.run(
			xcodeproj: @@projectHelper.xcodeproj_path,
			plist_path: @@projectHelper.plist_inner_path,
			app_identifier: @@envHelper.bundle_identifier
		)
	
		# add support for push notifications
		@@projectHelper.change_system_capability(
			"com.apple.Push",
			0,
			1
		)
	
		# add AccessWiFi if needed
		add_wifi_system_capability_if_needed()
	
		prepare_extensions()
	end
	
	def prepare_extensions()
		build_type = "release"
		@@appExtensions.prepare_notification_extension(
			build_type,
			@@appExtensions.notification_service_extension_key,
			@@appExtensions.notification_service_extension_target_name,
			@@appExtensions.notification_service_extension_bundle_identifier,
			@@appExtensions.notification_service_extension_info_plist_inner_path,
			@@appExtensions.notification_service_extension_info_plist_path
		)
	
		@@appExtensions.prepare_notification_extension(
			build_type,
			@@appExtensions.notification_content_extension_key,
			@@appExtensions.notification_content_extension_target_name,
			@@appExtensions.notification_content_extension_bundle_identifier,
			@@appExtensions.notification_content_extension_info_plist_inner_path,
			@@appExtensions.notification_content_extension_info_plist_path
		)
	end
	
	def itunesconnect_username
		"#{ENV['itunes_connect_user']}"
	end

	def itunesconnect_password
		"#{ENV['itunes_connect_password']}"
	end
end
