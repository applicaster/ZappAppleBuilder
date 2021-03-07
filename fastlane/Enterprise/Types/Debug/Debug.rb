# frozen_string_literal: true

require 'fastlane_core'
require 'plist'

import 'Enterprise/Types/Debug/AppExtensions.rb'
import 'Enterprise/BuildTypeEnterprise.rb'

class EnterpriseDebug < BuildTypeEnterprise
  attr_accessor :enterprise_debug_app_extensions_helper

  def initialize(options = {})
    super
    @enterprise_debug_app_extensions_helper = EnterpriseDebugAppExtensions.new(fastlane: @fastlane,
                                                                     project_helper: @project_helper)
  end

  def build_type
    'debug'
  end

  def download_signing_files
    super
  end

  def prepare_environment
    current(__callee__.to_s)
    super
    prepare_signing
    prepare_build
  end

  def fetch_app_center_identifiers
    @app_center_helper.fetch_identifiers(app_bundle_identifier.to_s)
  end

  def build
    current(__callee__.to_s)
    # get provisioning profiles specifiers
    main_prov_profile_specifier = read_param_from_file("#{app_bundle_identifier}_PROFILE_UDID")
    notification_service_extension_prov_profile_specifier = read_param_from_file("#{notifications_service_extension_bundle_identifier}_PROFILE_UDID")
    notification_content_extension_prov_profile_specifier = read_param_from_file("#{notifications_content_extension_bundle_identifier}_PROFILE_UDID")

    export_options = {
      compileBitcode: true,
      provisioningProfiles: {
        app_bundle_identifier => main_prov_profile_specifier.to_s,
        notifications_service_extension_bundle_identifier => notification_service_extension_prov_profile_specifier.to_s,
        notifications_content_extension_bundle_identifier => notification_content_extension_prov_profile_specifier.to_s
      }
    }

    build_export_options = 'enterprise_debug_build_export_options'
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
      xcargs: "RELEASE_SWIFT_OPTIMIZATION_LEVEL='-Onone' "\
              'RELEASE_COPY_PHASE_STRIP=NO '\
              "DEBUG_ENABLED_GCC='DEBUG=1' "\
              "DEBUG_ENABLED_SWIFT='-DDEBUG' "\
              "DEBUG_ENABLED_SCRIPTS='Debug' "\
              "MAIN_PROV_PROFILE_SPECIFIER='#{main_prov_profile_specifier}' "\
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
      bundle_identifier: app_bundle_identifier,
      build_type: 'Enterprise',
      zapp_build_type: 'debug'
    )

    # delete temp keychain
    delete_keychain(
      name: @@env_helper.keychain_name
    )

    # delete Invalid provisioning profiles for app
    delete_invalid_provisioning_profiles(
      username: username,
      team_id: team_id,
      team_name: team_name,
      bundle_identifier: app_bundle_identifier
    )

    # delete Invalid provisioning profiles for notification service extension
    delete_invalid_provisioning_profiles(
      username: username,
      team_id: team_id,
      team_name: team_name,
      bundle_identifier: notifications_service_extension_bundle_identifier
    )

    # delete Invalid provisioning profiles for notification content extension
    delete_invalid_provisioning_profiles(
      username: username,
      team_id: team_id,
      team_name: team_name,
      bundle_identifier: notifications_content_extension_bundle_identifier
    )
  end

  def prepare_build
    prepare_ent_app_for_build

    # update app base parameters in FeaturesCustomization.json
    update_parameters_in_feature_optimization_json

    # update firebase configuration
    @firebase_helper.add_configuration_file('enterprise')

    # update app identifier to the enterprise one
    reset_info_plist_bundle_identifier(
      xcodeproj: @project_helper.xcodeproj_path,
      plist_path: @project_helper.plist_inner_path
    )
    update_app_identifier(
      xcodeproj: @project_helper.xcodeproj_path,
      plist_path: @project_helper.plist_inner_path,
      app_identifier: app_bundle_identifier
    )

    # update ms_app_center app secret
    @app_center_helper.update_app_secret(app_bundle_identifier)

    # update project team identifier for all targets
    update_project_team(
      xcodeproj: @project_helper.xcodeproj_path,
      teamid: team_id
    )

    unless username.empty? && password.empty?
      # create main app on developer portal with new identifier
      create_app_on_dev_portal(
        username: username,
        team_id: team_id,
        app_name: devportal_app_name,
        bundle_identifier: app_bundle_identifier,
        app_index: '1'
      )

      # create and save the push notifications certificate in build artifacts
      create_push_certificate(
        username: username,
        team_id: team_id,
        app_name: devportal_app_name,
        bundle_identifier: app_bundle_identifier,
        p12_password: @@env_helper.accounts_account_id
      )

      prepare_app_group

      enterprise_debug_create_provisioning_profile(
        username: username,
        team_id: team_id,
        team_name: team_name,
        bundle_identifier: app_bundle_identifier
      )

      # save APP_GROUPS param
      save_param_to_file("#{app_bundle_identifier}_APP_GROUPS", [group_name(app_bundle_identifier).to_s].to_json)

      # set info plist SupportedAppGroups param for app target
      set_info_plist_supported_groups_param(
        xcodeproj: @project_helper.xcodeproj_path,
        plist_path: @project_helper.plist_inner_path,
        app_groups: [group_name(app_bundle_identifier).to_s]
      )

      # prepare app extensions
      prepare_extensions
    end

    # add debug ribbon
    add_debug_ribbon_to_app_icon
  end

  def prepare_signing
    unless username.empty? && password.empty?
      current(__callee__.to_s)
      import_certificate(
        certificate_path: certificate_path,
        certificate_password: ENV['KEY_PASSWORD'],
        keychain_name: @@env_helper.keychain_name,
        keychain_password: @@env_helper.keychain_password
      )
      sh("bundle exec fastlane fastlane-credentials add --username #{username} --password '#{password}'")
      ENV['FASTLANE_PASSWORD'] = password
    end
  end

  def perform_signing_validation
    current(__callee__.to_s)
    super

    validate(
      certificate_path: certificate_path,
      certificate_password: ENV['KEY_PASSWORD']
    )
  end

  def prepare_extensions
    current(__callee__.to_s)
    prepare_notification_content_extension
    prepare_notification_service_extension
  end

  def prepare_app_group
    current(__callee__.to_s)

    # create group for app
    sh("bundle exec fastlane produce group -g #{group_name(app_bundle_identifier)} -n '#{@@env_helper.bundle_identifier} Group' -u #{username} ")
    # add the app to the created group
    sh("bundle exec fastlane produce associate_group #{group_name(app_bundle_identifier)} -a #{app_bundle_identifier} -u #{username} ")

    # add group to entitlements for app target
    update_group_identifiers(
      path: @project_helper.path,
      target: @project_helper.name.to_s,
      build_type: 'Release',
      groups: [group_name(app_bundle_identifier).to_s]
    )
  end

  def prepare_notification_content_extension
    current(__callee__.to_s)
    @enterprise_debug_app_extensions_helper.extension_prepare(
      username: username,
      team_id: team_id,
      team_name: team_name,
      app_bundle_identifier: app_bundle_identifier,
      extension_type: @app_extensions_helper.notification_content_extension_key,
      extension_target_name: @app_extensions_helper.notification_content_extension_target_name,
      extension_app_name: notifications_content_extension_app_name,
      extension_bundle_identifier: notifications_content_extension_bundle_identifier,
      extension_info_plist_inner_path: @app_extensions_helper.notification_content_extension_info_plist_inner_path,
      extension_info_plist_path: @app_extensions_helper.notification_content_extension_info_plist_path
    )
  end

  def prepare_notification_service_extension
    current(__callee__.to_s)
    @enterprise_debug_app_extensions_helper.extension_prepare(
      username: username,
      team_id: team_id,
      team_name: team_name,
      app_bundle_identifier: app_bundle_identifier,
      extension_type: @app_extensions_helper.notification_service_extension_key,
      extension_target_name: @app_extensions_helper.notification_service_extension_target_name,
      extension_app_name: notifications_service_extension_app_name,
      extension_bundle_identifier: notifications_service_extension_bundle_identifier,
      extension_info_plist_inner_path: @app_extensions_helper.notification_service_extension_info_plist_inner_path,
      extension_info_plist_path: @app_extensions_helper.notification_service_extension_info_plist_path
    )
  end

  def add_debug_ribbon_to_app_icon
    current(__callee__.to_s)
    sh("sh #{@@env_helper.root_path}/Scripts/add-debug-ribbon-to-app-icon.sh #{ENV['PWD']} #{@project_helper.name} #{@@env_helper.platform_name}")
  end

  def app_bundle_prefix
    'com.applicaster.ent.'
  end

  def app_bundle_identifier
    "#{app_bundle_prefix}#{ENV['bundle_identifier']}"
  end

  def certificate_path
    "#{@@env_helper.root_path}/Zapp-Signing/Enterprise/dist.p12"
  end

  def username
    (ENV['APPLE_DEV_ENT_USER']).to_s
  end

  def password
    (ENV['APPLE_DEV_ENT_PASS']).to_s
  end

  def team_id
    (ENV['APPLE_DEV_ENT_TEAM_ID']).to_s
  end

  def team_name
    (ENV['APPLE_DEV_ENT_TEAM_NAME']).to_s
  end

  def devportal_app_name
    @@env_helper.bundle_identifier.to_s
  end

  def notifications_service_extension_app_name
    "#{devportal_app_name}.#{@app_extensions_helper.notification_service_extension_target_name}"
  end

  def notifications_content_extension_app_name
    "#{devportal_app_name}.#{@app_extensions_helper.notification_content_extension_target_name}"
  end

  def notifications_service_extension_bundle_identifier
    "#{app_bundle_identifier}.#{@app_extensions_helper.notification_service_extension_target_name}"
  end

  def notifications_content_extension_bundle_identifier
    "#{app_bundle_identifier}.#{@app_extensions_helper.notification_content_extension_target_name}"
  end
end
