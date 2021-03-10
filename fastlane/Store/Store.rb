# frozen_string_literal: true

require 'fastlane/action'
require 'fastlane_core'
import 'Base/BuildType.rb'

class Store < BuildType
  def build_type
    'store'
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

    if @@env_helper.is_tvos
      export_options = {
        compileBitcode: true,
        provisioningProfiles: {
          @@env_helper.bundle_identifier => main_prov_profile_specifier
        }
      }
    else
      notification_service_extension_prov_profile_specifier = @app_extensions_helper.provisioning_profile_uuid(@app_extensions_helper.notification_service_extension_key)
      notification_content_extension_prov_profile_specifier = @app_extensions_helper.provisioning_profile_uuid(@app_extensions_helper.notification_content_extension_key)

      export_options = {
        compileBitcode: true,
        provisioningProfiles: {
          @@env_helper.bundle_identifier => main_prov_profile_specifier,
          @app_extensions_helper.notification_service_extension_bundle_identifier => notification_service_extension_prov_profile_specifier.to_s,
          @app_extensions_helper.notification_content_extension_bundle_identifier => notification_content_extension_prov_profile_specifier.to_s
        }
      }
    end

    build_export_options = 'store_build_export_options'
    save_param_to_file(build_export_options, export_options.to_plist)

    build_app(
      clean: true,
      workspace: @project_helper.xcworkspace_relative_path.to_s,
      scheme: @project_helper.scheme,
      configuration: @@env_helper.build_configuration,
      include_bitcode: true,
      include_symbols: true,
      output_directory: "#{circle_artifacts_folder_path}/Store",
      buildlog_path: "#{circle_artifacts_folder_path}/Store",
      output_name: "#{@project_helper.scheme}-Store",
      build_path: @project_helper.build_path,
      derived_data_path: @project_helper.build_path,
      xcargs: "DEVELOPMENT_TEAM='#{team_id}' "\
           "NOTIFICATION_SERVICE_EXTENSION_PROV_PROFILE_SPECIFIER='#{notification_service_extension_prov_profile_specifier}' "\
           "NOTIFICATION_CONTENT_EXTENSION_PROV_PROFILE_SPECIFIER='#{notification_content_extension_prov_profile_specifier}' "\
           "DEBUG_INFORMATION_FORMAT='dwarf-with-dsym' "\
           "MAIN_PROV_PROFILE_SPECIFIER='#{main_prov_profile_specifier}'",
      export_team_id: team_id,
      export_method: 'app-store',
      export_options: saved_param_filename(build_export_options)
    )

    copy_artifacts(
      target_path: "#{circle_artifacts_folder_path}/Store",
      artifacts: [
        'Credentials/dist.mobileprovision',
        'Credentials/dist.p12'
      ]
    )

    # set appstore api key
    puts('Setting AppStore API Key')
    add_appstoreconnect_api_key(
      appstore_api_key_folder: appstore_api_key_folder,
      appstore_api_key_id: appstore_api_key_id,
      appstore_api_issuer_id: appstore_api_issuer_id
    )

    puts('Starting app delivery to AppStoreConnect')
    deliver_output = capture_stream($stdout) do
      @fastlane.deliver(
        ipa: "#{circle_artifacts_folder_path}/Store/#{@project_helper.scheme}-Store.ipa",
        platform: @@env_helper.is_tvos ? 'appletvos' : 'ios',
        force: true,
        skip_screenshots: true,
        skip_metadata: true,
        precheck_include_in_app_purchases: false,
        run_precheck_before_submit: false,
        ignore_language_directory_validation: true
      )
    end

    # print deliver output
    puts("Deliver output: #{deliver_output}")

    # raise an error if the delover output has an error
    raise 'Error posting the app to the App Store Connect' if deliver_output.include?('ERROR ITMS-')

    # upload to ms app center
    upload_application(
      bundle_identifier: @@env_helper.bundle_identifier,
      build_type: 'Store',
      zapp_build_type: 'release'
    )
  end

  def download_signing_files
    current(__callee__.to_s)

    # create new dir for files
    sh("mkdir -p \"#{@project_helper.credentials_folder_path}\"")
    # download p12 and provisioning profile
    sh("curl -sL \"#{@@env_helper.provisioning_profile_url}\" --output \"#{@project_helper.distribution_provisioning_profile_path}\"")
    sh("curl -sL \"#{@@env_helper.distribution_key_url}\" --output \"#{@project_helper.distribution_certificate_path}\"")

    # create new dir for private key
    sh("mkdir -p \"#{appstore_api_key_folder}\"")
    # download appstore api key
    sh("curl -sL \"#{appstore_api_key_url}\" --output \"#{appstore_api_key_folder}/AuthKey_#{appstore_api_key_id}.p8\"")
  end

  def perform_signing_validation
    current(__callee__.to_s)
    super

    validate(
      certificate_path: @project_helper.distribution_certificate_path,
      certificate_password: @@env_helper.distribution_key_password,
      provisioning_profile_path: @project_helper.distribution_provisioning_profile_path,
      version_number: @@env_helper.version_name,
      appstore_api_key_folder: appstore_api_key_folder,
      appstore_api_key_id: appstore_api_key_id,
      appstore_api_issuer_id: appstore_api_issuer_id
    )
  end

  def prepare_signing
    current(__callee__.to_s)
    # fetch values
    provisioning_profile = get_provisioning_profile_content(@project_helper.distribution_provisioning_profile_path)
    team_id_value = provisioning_profile['Entitlements']['com.apple.developer.team-identifier']
    team_name_value = provisioning_profile['TeamName']
    provisioning_profile_uuid_value = provisioning_profile['UUID']
    provisioning_profile_app_groups_value = provisioning_profile['Entitlements']['com.apple.security.application-groups']

    # save values
    save_param_to_file("#{@@env_helper.bundle_identifier}_PROFILE_UDID", provisioning_profile_uuid_value.to_s)
    save_param_to_file("#{@@env_helper.bundle_identifier}_TEAM_ID", team_id_value.to_s)
    save_param_to_file("#{@@env_helper.bundle_identifier}_TEAM_NAME", team_name_value.to_s)
    save_param_to_file("#{@@env_helper.bundle_identifier}_APP_GROUPS", provisioning_profile_app_groups_value.to_json)

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

    # add support for push notifications
    if @project_helper.plugins_for_type('push_provider').count > 0
      @project_helper.change_system_capability(
        capability: 'com.apple.Push',
        old: 0,
        new: 1
      )
    else
      # if not plugin attached - delete notifications entitlements if exists
      remove_key_from_entitlements(@project_helper.name.to_s, 'Release', 'aps-environment')
      # remove remote notification background mode
      remove_background_modes(
        xcodeproj: @project_helper.xcodeproj_path,
        plist_path: @project_helper.plist_inner_path,
        modes_to_remove: [
          {
            name: 'remote-notification'
          }
        ]
      )
    end

    # set info plist SupportedAppGroups param for app target
    set_info_plist_supported_groups_param(
      xcodeproj: @project_helper.xcodeproj_path,
      plist_path: @project_helper.plist_inner_path,
      app_groups: get_app_provisioning_profile_app_groups(@@env_helper.bundle_identifier)
    )

    # add AccessWiFi if needed
    add_wifi_system_capability_if_needed

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

  def appstore_api_key_url
    (ENV['appstore_api_key_url']).to_s
  end

  def appstore_api_key_id
    (ENV['appstore_api_key_id']).to_s
  end

  def appstore_api_issuer_id
    (ENV['appstore_api_issuer_id']).to_s
  end

  def appstore_api_key_folder
    './private_keys'
  end

  def is_enterprise_build
    current(__callee__.to_s)

    provisioning_profile = get_provisioning_profile_content(@project_helper.distribution_provisioning_profile_path)
    provisioning_profile_is_enterprise = provisioning_profile['ProvisionsAllDevices']

    puts("Checking if the provisioning profile related to Enterprise account - #{provisioning_profile_is_enterprise}".colorize(:red))

    if provisioning_profile_is_enterprise == true
      ENV['debug_distribution_key_password'] = ENV['distribution_key_password']
      ENV['debug_distribution_key_url'] = ENV['distribution_key_url']
      ENV['debug_provisioning_profile_url'] = ENV['provisioning_profile_url']
    end

    provisioning_profile_is_enterprise
  end
end
