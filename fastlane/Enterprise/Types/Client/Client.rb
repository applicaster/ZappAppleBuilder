# frozen_string_literal: true

import 'Enterprise/BuildTypeEnterprise.rb'

class EnterpriseClient < BuildTypeEnterprise
  def build_type
    'enterprise'
  end

  def prepare_environment
    current(__callee__.to_s)
    super
    prepare_signing
    prepare_build
    @@appCenterHelper.fetch_identifiers(@@envHelper.bundle_identifier)
  end

  def build
    current(__callee__.to_s)
    # get provisioning profiles specifiers
    main_prov_profile_specifier = provisioning_profile_uuid
    notification_service_extension_prov_profile_specifier = @@appExtensions.provisioning_profile_uuid(@@appExtensions.notification_service_extension_key)
    notification_content_extension_prov_profile_specifier = @@appExtensions.provisioning_profile_uuid(@@appExtensions.notification_content_extension_key)

    puts("main_prov_profile_specifier: #{provisioning_profile_uuid}")

    export_options = {
      compileBitcode: true,
      provisioningProfiles: {
        @@envHelper.bundle_identifier => main_prov_profile_specifier.to_s,
        @@appExtensions.notification_service_extension_bundle_identifier => notification_service_extension_prov_profile_specifier.to_s,
        @@appExtensions.notification_content_extension_bundle_identifier => notification_content_extension_prov_profile_specifier.to_s
      }
    }

    build_export_options = 'enterprise_client_build_export_options'
    save_param_to_file(build_export_options, export_options.to_plist)

    build_app(
      workspace: @@projectHelper.xcworkspace_relative_path.to_s,
      scheme: @@projectHelper.scheme,
      configuration: @@envHelper.build_configuration,
      include_bitcode: true,
      include_symbols: true,
      output_directory: "#{circle_artifacts_folder_path}/Enterprise",
      buildlog_path: "#{circle_artifacts_folder_path}/Enterprise",
      output_name: "#{@@projectHelper.scheme}-Enterprise",
      build_path: @@projectHelper.build_path,
      derived_data_path: @@projectHelper.build_path,
      xcargs: '-UseModernBuildSystem=NO '\
           "PROVISIONING_PROFILE='#{main_prov_profile_specifier}' "\
           "NOTIFICATION_SERVICE_EXTENSION_PROV_PROFILE_SPECIFIER='#{notification_service_extension_prov_profile_specifier}' "\
           "NOTIFICATION_CONTENT_EXTENSION_PROV_PROFILE_SPECIFIER='#{notification_content_extension_prov_profile_specifier}' "\
           "DEBUG_INFORMATION_FORMAT='dwarf-with-dsym'",
      export_method: 'enterprise',
      export_team_id: team_id,
      export_options: saved_param_filename(build_export_options)
    )

    perform_post_build_procedures
  end

  def perform_post_build_procedures
    current(__callee__.to_s)
    super

    # upload to ms app center
    upload_application(
      bundle_identifier: @@envHelper.bundle_identifier,
      build_type: 'Enterprise',
      zapp_build_type: 'debug'
    )
  end

  def download_signing_files
    current(__callee__.to_s)
    # create new dir for files
    sh("mkdir -p \"#{@@projectHelper.credentials_folder_path}\"")
    # download p12 and provisioning profile
    sh("curl -sL \"#{@@envHelper.provisioning_profile_url}\" --output \"#{@@projectHelper.distribution_provisioning_profile_path}\"")
    sh("curl -sL \"#{@@envHelper.distribution_key_url}\" --output \"#{@@projectHelper.distribution_certificate_path}\"")
  end

  def perform_signing_validation
    current(__callee__.to_s)
    download_signing_files

    validate_distribution_certificate(
      certificate_path: @@projectHelper.distribution_certificate_path,
      certificate_password: @@envHelper.distribution_key_password
    )

    validate_distribution_certificate_and_provisioning_profile_team_id(
      certificate_path: @@projectHelper.distribution_certificate_path,
      certificate_password: @@envHelper.distribution_key_password,
      provisioning_profile_path: @@projectHelper.distribution_provisioning_profile_path
    )

    validate_provisioning_profile(
      provisioning_profile_path: @@projectHelper.distribution_provisioning_profile_path
    )
  end

  def prepare_signing
    current(__callee__.to_s)
    # fetch values
    team_id_value = sh("echo $(/usr/libexec/PlistBuddy -c 'Print :Entitlements:com.apple.developer.team-identifier' /dev/stdin <<< $(security cms -D -i \"#{@@projectHelper.distribution_provisioning_profile_path}\")) | tr -d '\040\011\012\015'")
    team_name_value = sh("echo $(/usr/libexec/PlistBuddy -c 'Print :TeamName' /dev/stdin <<< $(security cms -D -i \"#{@@projectHelper.distribution_provisioning_profile_path}\")) | tr -d '\011\012\015'")
    provisioning_profile_uuid_value = sh("echo $(/usr/libexec/PlistBuddy -c 'Print :UUID' /dev/stdin <<< $(security cms -D -i \"#{@@projectHelper.distribution_provisioning_profile_path}\")) | tr -d '\040\011\012\015'")

    # save values
    save_param_to_file("#{@@envHelper.bundle_identifier}_PROFILE_UDID", provisioning_profile_uuid_value.to_s)
    save_param_to_file("#{@@envHelper.bundle_identifier}_TEAM_ID", team_id_value.to_s)
    save_param_to_file("#{@@envHelper.bundle_identifier}_TEAM_NAME", team_name_value.to_s)

    # install provisioning profile
    sh("mkdir -p ~/Library/MobileDevice/'Provisioning Profiles'")
    sh("cp #{@@projectHelper.distribution_provisioning_profile_path} ~/Library/MobileDevice/'Provisioning Profiles'/#{provisioning_profile_uuid}.mobileprovision")

    import_certificate(
      certificate_path: @@projectHelper.distribution_certificate_path,
      certificate_password: @@envHelper.distribution_key_password,
      keychain_name: @@envHelper.keychain_name,
      keychain_password: @@envHelper.keychain_password
    )
  end

  def prepare_build
    current(__callee__.to_s)
    prepare_app_for_build

    # update app base parameters in FeaturesCustomization.json
    update_parameters_in_feature_optimization_json

    # update ms_app_center app secret
    @@appCenterHelper.update_app_secret(@@envHelper.bundle_identifier.to_s)

    # update firebase configuration
    @@firebaseHelper.add_configuration_file('production')

    # update app identifier to the store one
    reset_info_plist_bundle_identifier(
      xcodeproj: @@projectHelper.xcodeproj_path,
      plist_path: @@projectHelper.plist_inner_path
    )
    update_app_identifier(
      xcodeproj: @@projectHelper.xcodeproj_path,
      plist_path: @@projectHelper.plist_inner_path,
      app_identifier: @@envHelper.bundle_identifier
    )

    # update project team identifier for all targets
    update_project_team(
      xcodeproj: @@projectHelper.xcodeproj_path,
      teamid: team_id
    )

    # add support for push notifications
    @@projectHelper.change_system_capability(
      capability: 'com.apple.Push',
      old: 0,
      new: 1
    )

    prepare_extensions
  end

  def prepare_extensions
    current(__callee__.to_s)

    build_type = 'release'
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

  def team_id
    read_param_from_file("#{@@envHelper.bundle_identifier}_TEAM_ID")
  end

  def team_name
    read_param_from_file("#{@@envHelper.bundle_identifier}_TEAM_NAME")
  end

  def provisioning_profile_uuid
    read_param_from_file("#{@@envHelper.bundle_identifier}_PROFILE_UDID")
  end
end
