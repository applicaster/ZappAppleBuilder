import "Enterprise/Types/Debug/AppExtensions.rb"
import "Enterprise/BuildTypeEnterprise.rb"

class EnterpriseDebug < BuildTypeEnterprise
  def prepare_environment
    super
		prepare_signing()
		prepare_build()
		@@appCenterHelper.fetch_identifiers("#{app_bundle_identifier}")
	end
			
  def build()
    # get provisioning profiles specifiers
    main_prov_profile_specifier = "#{ENV["#{app_bundle_identifier}_PROFILE_UDID"]}"
    notification_service_extension_prov_profile_specifier = "#{ENV["#{notifications_service_extension_bundle_identifier}_PROFILE_UDID"]}"
    notification_content_extension_prov_profile_specifier = "#{ENV["#{notifications_content_extension_bundle_identifier}_PROFILE_UDID"]}"

    
    gym(
      workspace: "#{@@projectHelper.xcworkspace_relative_path}",
      scheme: @@projectHelper.scheme,
      configuration: build_configuration,
      include_bitcode: true,
      include_symbols: true,
      output_directory: "CircleArtifacts/Enterprise",
      buildlog_path: "CircleArtifacts/Enterprise",
      output_name: "#{@@projectHelper.scheme}-Enterprise",
      build_path: @@projectHelper.build_path,
      derived_data_path: @@projectHelper.build_path,
      xcargs: "RELEASE_SWIFT_OPTIMIZATION_LEVEL='-Onone' "\
              "-UseModernBuildSystem=NO "\
              "RELEASE_COPY_PHASE_STRIP=NO "\
              "DEBUG_ENABLED_GCC='DEBUG=1' "\
              "DEBUG_ENABLED_SWIFT='-DDEBUG' "\
              "DEBUG_ENABLED_SCRIPTS='Debug' "\
              "PROVISIONING_PROFILE='#{main_prov_profile_specifier}' "\
              "NOTIFICATION_SERVICE_EXTENSION_PROV_PROFILE_SPECIFIER='#{notification_service_extension_prov_profile_specifier}' "\
              "NOTIFICATION_CONTENT_EXTENSION_PROV_PROFILE_SPECIFIER='#{notification_content_extension_prov_profile_specifier}' "\
              "DEBUG_INFORMATION_FORMAT='dwarf-with-dsym'",
      export_method: "enterprise",
      export_team_id: team_id,
      export_options: {
        compileBitcode: true,
        provisioningProfiles: {
          app_bundle_identifier => "#{main_prov_profile_specifier}",
          notifications_service_extension_bundle_identifier => "#{notification_service_extension_prov_profile_specifier}",
          notifications_content_extension_bundle_identifier => "#{notification_content_extension_prov_profile_specifier}"
        }
      }
    )

		perform_post_build_procedures()
  end

  def perform_post_build_procedures()
		base_ent_perform_post_build_procedures()

    # upload to ms app center
    upload_application(app_bundle_identifier,
      "Enterprise",
      "debug"
    )
	end

  def prepare_build()
    prepare_app_for_build()

    # update app base parameters in FeaturesCustomization.json
    update_parameters_in_feature_optimization_json()

    #update firebase configuration
    @@firebaseHelper.add_configuration_file("enterprise")

    # update app identifier to the enterprise one
    @@projectHelper.plist_reset_to_bundle_identifier_placeholder(@@projectHelper.xcodeproj_path, @@projectHelper.plist_inner_path)
		Actions::UpdateAppIdentifierAction.run(
			xcodeproj: @@projectHelper.xcodeproj_path,
			plist_path: @@projectHelper.plist_inner_path,
			app_identifier: app_bundle_identifier
		)
 
    # update ms_app_center app secret
    @@appCenterHelper.update_app_secret(app_bundle_identifier)

    # update project team identifier for all targets
    Actions::UpdateProjectTeamAction.run(
      path: @@projectHelper.xcodeproj_path,
      teamid: team_id
    )

    # create main app on developer portal with new identifier
    create_app_on_dev_portal(
      username,
      team_id,
      devportal_app_name,
      app_bundle_identifier,
      "1"
    )

    # create and save the push notifications certificate in build artifacts
    create_push_certificate(
      username,
      team_id,
      devportal_app_name,
      app_bundle_identifier,
      @@envHelper.accountsAccountId
    )

    # create provisioning profile for the main app
    create_provisioning_profile(
      username,
      team_id,
      team_name,
      app_bundle_identifier
    )

    # prepare app extensions
    prepare_extensions()

    # add debug ribbon
    add_debug_ribbon_to_app_icon
  end

  def prepare_signing()
    create_temp_keychain()

    Actions::ImportCertificateAction.run(
      certificate_path: certificate_path,
      certificate_password: ENV['KEY_PASSWORD'],
      keychain_name: @@envHelper.keychain_name,
      keychain_password: @@envHelper.keychain_password
    )
    sh("bundle exec fastlane fastlane-credentials add --username #{username} --password '#{password}'")
    ENV['FASTLANE_PASSWORD']=password
  end

  def perform_signing_validation

	end

	def prepare_extensions()
		prepare_notification_content_extension()
		prepare_notification_service_extension()
	end

  def prepare_notification_content_extension()
    base_ent_debug_app_extension_prepare(
      @@appExtensions.notification_content_extension_key,
      @@appExtensions.notification_content_extension_target_name,
      @@appExtensions.notifications_content_extension_app_name,
      @@appExtensions.notifications_content_extension_bundle_identifier,
      @@appExtensions.notification_content_extension_info_plist_inner_path,
      @@appExtensions.notification_content_extension_info_plist_path
    )
  end

  def prepare_notification_service_extension()
    base_ent_debug_app_extension_prepare(
      @@appExtensions.notification_service_extension_key,
      @@appExtensions.notification_service_extension_target_name,
      @@appExtensions.notifications_service_extension_app_name,
      @@appExtensions.notifications_service_extension_bundle_identifier,
      @@appExtensions.notification_service_extension_info_plist_inner_path,
      @@appExtensions.notification_service_extension_info_plist_path
    )
  end

  def add_debug_ribbon_to_app_icon
    sh("sh #{@@envHelper.root_path}/Scripts/add-debug-ribbon-to-app-icon.sh #{ENV['PWD']} #{@@projectHelper.name} #{@@envHelper.platform_name}")
  end

  def app_bundle_prefix
      "com.applicaster.ent."
  end

  def app_bundle_identifier
      "#{app_bundle_prefix}#{ENV["bundle_identifier"]}"
  end

  def certificate_path
      "#{@@envHelper.root_path}/Zapp-Signing/Enterprise/dist.p12"
  end

  def username
      "#{ENV['APPLE_DEV_ENT_USER']}"
  end

  def password
      "#{ENV['APPLE_DEV_ENT_PASS']}"
  end

  def team_id
      "#{ENV['APPLE_DEV_ENT_TEAM_ID']}"
  end

  def team_name
      "#{ENV['APPLE_DEV_ENT_TEAM_NAME']}"
  end

  def devportal_app_name
      "#{@@envHelper.bundle_identifier}"
  end

  def notifications_service_extension_app_name
      "#{devportal_app_name}.#{notification_service_extension_target_name}"
  end

  def notifications_content_extension_app_name
      "#{devportal_app_name}.#{notification_content_extension_target_name}"
  end

  def notifications_service_extension_bundle_identifier
      "#{app_bundle_identifier}.#{notification_service_extension_target_name}"
  end

  def notifications_content_extension_bundle_identifier
      "#{app_bundle_identifier}.#{notification_content_extension_target_name}"
  end
end