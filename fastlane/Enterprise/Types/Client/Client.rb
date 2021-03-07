# frozen_string_literal: true

import 'Enterprise/BuildTypeEnterprise.rb'

class EnterpriseClient < BuildTypeEnterprise
  def build_type
    'enterprise'
  end

  def build_configuration
    if read_param_from_file("#{@@env_helper.bundle_identifier}_ISDEBUG").to_s.downcase == 'true'
      'Debug'
    else
      super
    end
  end

  def prepare_environment
    current(__callee__.to_s)
    super
    prepare_signing
    prepare_build
  end

  def build
    current(__callee__.to_s)
    # get provisioning profiles specifiers
    main_prov_profile_specifier = provisioning_profile_uuid
    notification_service_extension_prov_profile_specifier = @app_extensions_helper.provisioning_profile_uuid(@app_extensions_helper.notification_service_extension_key)
    notification_content_extension_prov_profile_specifier = @app_extensions_helper.provisioning_profile_uuid(@app_extensions_helper.notification_content_extension_key)

    puts("main_prov_profile_specifier: #{provisioning_profile_uuid}")

    export_options = {
      compileBitcode: true,
      provisioningProfiles: {
        @@env_helper.bundle_identifier => main_prov_profile_specifier.to_s,
        @app_extensions_helper.notification_service_extension_bundle_identifier => notification_service_extension_prov_profile_specifier.to_s,
        @app_extensions_helper.notification_content_extension_bundle_identifier => notification_content_extension_prov_profile_specifier.to_s
      }
    }

    build_export_options = 'enterprise_client_build_export_options'
    save_param_to_file(build_export_options, export_options.to_plist)

    build_app(
      workspace: @project_helper.xcworkspace_relative_path.to_s,
      scheme: @project_helper.scheme,
      configuration: build_configuration,
      include_bitcode: true,
      include_symbols: true,
      output_directory: "#{circle_artifacts_folder_path}/Enterprise",
      buildlog_path: "#{circle_artifacts_folder_path}/Enterprise",
      output_name: "#{@project_helper.scheme}-Enterprise",
      build_path: @project_helper.build_path,
      derived_data_path: @project_helper.build_path,
      xcargs: "MAIN_PROV_PROFILE_SPECIFIER='#{main_prov_profile_specifier}' "\
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
      bundle_identifier: @@env_helper.bundle_identifier,
      build_type: 'Enterprise',
      zapp_build_type: zapp_build_type
    )
  end

  def download_signing_files
    current(__callee__.to_s)
    # create new dir for files
    sh("mkdir -p \"#{@project_helper.credentials_folder_path}\"")
    # download p12 and provisioning profile
    sh("curl -sL \"#{@@env_helper.debug_provisioning_profile_url}\" --output \"#{@project_helper.distribution_provisioning_profile_path}\"")
    sh("curl -sL \"#{@@env_helper.debug_distribution_key_url}\" --output \"#{@project_helper.distribution_certificate_path}\"")
  end

  def perform_signing_validation
    current(__callee__.to_s)
    super
    validate(
      certificate_path: @project_helper.distribution_certificate_path,
      certificate_password: @@env_helper.debug_distribution_key_password,
      provisioning_profile_path: @project_helper.distribution_provisioning_profile_path
    )
  end

  def prepare_signing
    current(__callee__.to_s)
    # fetch values
    provisioning_profile = get_provisioning_profile_content(@project_helper.distribution_provisioning_profile_path)
    team_id_value = provisioning_profile['Entitlements']['com.apple.developer.team-identifier']
    team_name_value = provisioning_profile['TeamName']
    provisioning_profile_uuid_value = provisioning_profile['UUID']
    provisioning_profile_debug = provisioning_profile['Entitlements']['get-task-allow']
    provisioning_profile_app_groups_value = provisioning_profile['Entitlements']['com.apple.security.application-groups']

    # save values
    save_param_to_file("#{@@env_helper.bundle_identifier}_PROFILE_UDID", provisioning_profile_uuid_value.to_s)
    save_param_to_file("#{@@env_helper.bundle_identifier}_TEAM_ID", team_id_value.to_s)
    save_param_to_file("#{@@env_helper.bundle_identifier}_TEAM_NAME", team_name_value.to_s)
    save_param_to_file("#{@@env_helper.bundle_identifier}_ISDEBUG", provisioning_profile_debug.to_s)
    save_param_to_file("#{@@env_helper.bundle_identifier}_APP_GROUPS", provisioning_profile_app_groups_value.to_s)

    # install provisioning profile
    sh("mkdir -p ~/Library/MobileDevice/'Provisioning Profiles'")
    sh("cp #{@project_helper.distribution_provisioning_profile_path} ~/Library/MobileDevice/'Provisioning Profiles'/#{provisioning_profile_uuid}.mobileprovision")

    import_certificate(
      certificate_path: @project_helper.distribution_certificate_path,
      certificate_password: @@env_helper.distribution_key_password,
      keychain_name: @@env_helper.keychain_name,
      keychain_password: @@env_helper.keychain_password
    )
  end

  def prepare_build
    current(__callee__.to_s)
    prepare_ent_app_for_build

    # update app base parameters in FeaturesCustomization.json
    update_parameters_in_feature_optimization_json

    # update ms_app_center app secret
    @app_center_helper.update_app_secret(@@env_helper.bundle_identifier.to_s)

    # update firebase configuration
    @firebase_helper.add_configuration_file('production')

    # update app identifier to the store one
    reset_info_plist_bundle_identifier(
      xcodeproj: @project_helper.xcodeproj_path,
      plist_path: @project_helper.plist_inner_path
    )
    update_app_identifier(
      xcodeproj: @project_helper.xcodeproj_path,
      plist_path: @project_helper.plist_inner_path,
      app_identifier: @@env_helper.bundle_identifier
    )

    # update project team identifier for all targets
    update_project_team(
      xcodeproj: @project_helper.xcodeproj_path,
      teamid: team_id
    )

    # add support for push notifications
    @project_helper.change_system_capability(
      capability: 'com.apple.Push',
      old: 0,
      new: 1
    )

    # set info plist SupportedAppGroups param for app target
    set_info_plist_supported_groups_param(
      xcodeproj: @project_helper.xcodeproj_path,
      plist_path: @project_helper.plist_inner_path,
      app_groups: get_app_provisioning_profile_app_groups(@@env_helper.bundle_identifier)
    )

    prepare_extensions
  end

  def prepare_extensions
    current(__callee__.to_s)

    build_type = 'release'
    @app_extensions_helper.prepare_notification_extension(
      build_type: build_type,
      extension_type: @app_extensions_helper.notification_service_extension_key,
      extension_target_name: @app_extensions_helper.notification_service_extension_target_name,
      extension_bundle_identifier: @app_extensions_helper.notification_service_extension_bundle_identifier,
      extension_info_plist_inner_path: @app_extensions_helper.notification_service_extension_info_plist_inner_path,
      extension_info_plist_path: @app_extensions_helper.notification_service_extension_info_plist_path,
      app_bunlde_identifier: @@env_helper.bundle_identifier
    )

    @app_extensions_helper.prepare_notification_extension(
      build_type: build_type,
      extension_type: @app_extensions_helper.notification_content_extension_key,
      extension_target_name: @app_extensions_helper.notification_content_extension_target_name,
      extension_bundle_identifier: @app_extensions_helper.notification_content_extension_bundle_identifier,
      extension_info_plist_inner_path: @app_extensions_helper.notification_content_extension_info_plist_inner_path,
      extension_info_plist_path: @app_extensions_helper.notification_content_extension_info_plist_path,
      app_bunlde_identifier: @@env_helper.bundle_identifier
    )
  end

  def zapp_build_type
    @@env_helper.with_release == 'true' ? 'release' : 'debug'
  end
end
