import "Enterprise/Base/Base.rb"
import "Enterprise/Debug/AppExtensions.rb"

fastlane_require 'dotenv'

platform :ios do

  lane :enterprise_debug_prepare_env do
    unless bundle_identifier.to_s.strip.empty?
      prepare_enterprise_debug_app_for_build_project_only
    else 
      puts("Skipping the step, no required variables")
  end
    
  end
  
  lane :enterprise_debug do

    ms_app_center_fetch_identifiers()
    prepare_enterprise_debug_app_signing()
    prepare_enterprise_debug_app_for_build()

    # get provisioning profiles specifiers
    main_prov_profile_specifier = "#{ENV["#{enterprise_debug_app_bundle_identifier}_PROFILE_UDID"]}"
    notification_service_extension_prov_profile_specifier = "#{ENV["#{enterprise_debug_app_notifications_service_extension_bundle_identifier}_PROFILE_UDID"]}"
    notification_content_extension_prov_profile_specifier = "#{ENV["#{enterprise_debug_app_notifications_content_extension_bundle_identifier}_PROFILE_UDID"]}"

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
      export_team_id: enterprise_debug_team_id,
      export_options: {
        compileBitcode: true,
        provisioningProfiles: {
          enterprise_debug_app_bundle_identifier => "#{main_prov_profile_specifier}",
          enterprise_debug_app_notifications_service_extension_bundle_identifier => "#{notification_service_extension_prov_profile_specifier}",
          enterprise_debug_app_notifications_content_extension_bundle_identifier => "#{notification_content_extension_prov_profile_specifier}"
        }
      }
    )

		perform_post_build_procedures()

  end

  def perform_post_build_procedures()
		base_ent_perform_post_build_procedures()

    # upload to ms app center
    upload_application(enterprise_debug_app_bundle_identifier,
      "Enterprise",
      "debug"
    )
	end

  def prepare_enterprise_debug_app_for_build_project_only
    base_ent_prepare_enterprise_app_for_build()

    # update app base parameters in FeaturesCustomization.json
    update_parameters_in_feature_optimization_json()

    #update firebase configuration
    firebase_add_configuration_file("enterprise")

    # update app identifier to the enterprise one
    info_plist_reset_to_bundle_identifier_placeholder(xcodeproj_path, project_info_plist_inner_path)
    update_app_identifier(
      xcodeproj: xcodeproj_path,
      plist_path: project_info_plist_inner_path,
      app_identifier: enterprise_debug_app_bundle_identifier
    )
  end

  def prepare_enterprise_debug_app_for_build()
    prepare_enterprise_debug_app_for_build_project_only()

    # update ms_app_center app secret
    ms_app_center_update_app_secret(enterprise_debug_app_bundle_identifier)

    # update project team identifier for all targets
    update_project_team(
      path: xcodeproj_path,
      teamid: enterprise_debug_team_id
    )

    # create main app on developer portal with new identifier
    base_ent_create_app_on_dev_portal(
      enterprise_debug_username,
      enterprise_debug_team_id,
      enterprise_debug_app_devportal_app_name,
      enterprise_debug_app_bundle_identifier,
      "1"
    )

    # create and save the push notifications certificate in build artifacts
    base_ent_create_push_certificate(
      enterprise_debug_username,
      enterprise_debug_team_id,
      enterprise_debug_app_devportal_app_name,
      enterprise_debug_app_bundle_identifier,
      accountsAccountId
    )

    # create provisioning profile for the main app
    base_ent_create_provisioning_profile(
      enterprise_debug_username,
      enterprise_debug_team_id,
      enterprise_debug_team_name,
      enterprise_debug_app_bundle_identifier
    )

    # prepare app extensions
    prepare_enterprise_debug_app_extensions()

    # add debug ribbon
    add_debug_ribbon_to_app_icon
  end

  def prepare_enterprise_debug_app_signing()
    base_ent_prepare_enterprise_debug_app_signing(
      enterprise_debug_username,
      enterprise_debug_password,
      ENV['APPLE_DEV_ENT_PASS'],
      enterprise_debug_certificate_path
    )
  end

	def prepare_enterprise_debug_app_extensions()
		prepare_enterprise_debug_app_notification_content_extension()
		prepare_enterprise_debug_app_notification_service_extension()
	end

  def prepare_enterprise_debug_app_notification_content_extension()
    base_ent_debug_app_extension_prepare(
      notification_content_extension_key,
      notification_content_extension_target_name,
      enterprise_debug_app_notifications_content_extension_app_name,
      enterprise_debug_app_notifications_content_extension_bundle_identifier,
      notification_content_extension_info_plist_inner_path,
      notification_content_extension_info_plist_path
    )
  end

  def prepare_enterprise_debug_app_notification_service_extension()
    base_ent_debug_app_extension_prepare(
      notification_service_extension_key,
      notification_service_extension_target_name,
      enterprise_debug_app_notifications_service_extension_app_name,
      enterprise_debug_app_notifications_service_extension_bundle_identifier,
      notification_service_extension_info_plist_inner_path,
      notification_service_extension_info_plist_path
    )
  end

  def add_debug_ribbon_to_app_icon
    sh("sh #{ENV['PWD']}/Scripts/add-debug-ribbon-to-app-icon.sh #{ENV['PWD']} #{project_name} #{platform_name}")
  end

  def enterprise_debug_app_bundle_prefix
      "com.applicaster.ent."
  end

  def enterprise_debug_app_bundle_identifier
      "#{enterprise_debug_app_bundle_prefix}#{ENV["bundle_identifier"]}"
  end

  def enterprise_debug_certificate_path
      "#{ENV['PWD']}/Zapp-Signing/Enterprise/dist.p12"
  end

  def enterprise_debug_username
      "#{ENV['APPLE_DEV_ENT_USER']}"
  end

  def enterprise_debug_password
      "#{ENV['APPLE_DEV_ENT_PASS']}"
  end

  def enterprise_debug_team_id
      "#{ENV['APPLE_DEV_ENT_TEAM_ID']}"
  end

  def enterprise_debug_team_name
      "#{ENV['APPLE_DEV_ENT_TEAM_NAME']}"
  end

  def enterprise_debug_app_devportal_app_name
      "#{ENV['bundle_identifier']}"
  end

  def enterprise_debug_app_notifications_service_extension_app_name
      "#{enterprise_debug_app_devportal_app_name}.#{notification_service_extension_target_name}"
  end

  def enterprise_debug_app_notifications_content_extension_app_name
      "#{enterprise_debug_app_devportal_app_name}.#{notification_content_extension_target_name}"
  end

  def enterprise_debug_app_notifications_service_extension_bundle_identifier
      "#{enterprise_debug_app_bundle_identifier}.#{notification_service_extension_target_name}"
  end

  def enterprise_debug_app_notifications_content_extension_bundle_identifier
    "#{enterprise_debug_app_bundle_identifier}.#{notification_content_extension_target_name}"
  end
end
