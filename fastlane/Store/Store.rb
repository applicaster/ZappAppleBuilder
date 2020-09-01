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

    if @@envHelper.isTvOS
      export_options = {
        compileBitcode: true,
        provisioningProfiles: {
          @@envHelper.bundle_identifier => main_prov_profile_specifier
        }
      }
    else 
      notification_service_extension_prov_profile_specifier = @appExtensions.provisioning_profile_uuid(@appExtensions.notification_service_extension_key)
      notification_content_extension_prov_profile_specifier = @appExtensions.provisioning_profile_uuid(@appExtensions.notification_content_extension_key)
    
      export_options = {
        compileBitcode: true,
        provisioningProfiles: {
          @@envHelper.bundle_identifier => main_prov_profile_specifier,
          @appExtensions.notification_service_extension_bundle_identifier => notification_service_extension_prov_profile_specifier.to_s,
          @appExtensions.notification_content_extension_bundle_identifier => notification_content_extension_prov_profile_specifier.to_s
        }
      }
    end

    build_export_options = 'store_build_export_options'
    save_param_to_file(build_export_options, export_options.to_plist)

    build_app(
      clean: true,
      workspace: @projectHelper.xcworkspace_relative_path.to_s,
      scheme: @projectHelper.scheme,
      configuration: @@envHelper.build_configuration,
      include_bitcode: true,
      include_symbols: true,
      output_directory: "#{circle_artifacts_folder_path}/Store",
      buildlog_path: "#{circle_artifacts_folder_path}/Store",
      output_name: "#{@projectHelper.scheme}-Store",
      build_path: @projectHelper.build_path,
      derived_data_path: @projectHelper.build_path,
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

    puts('Starting app delivery to AppStoreConnect using altool')
    deliver_output = capture_stream($stdout) do
      @fastlane.altool(
        altool_username: itunesconnect_username.to_s,
        altool_password: itunesconnect_password.to_s,
        altool_app_type: @@envHelper.isTvOS ? 'appletvos' : 'ios',
        altool_ipa_path: "#{circle_artifacts_folder_path}/Store/#{@projectHelper.scheme}-Store.ipa",
        altool_output_format: 'xml'
      )
    end

    # print deliver output
    puts("Altool output: #{deliver_output}")

    # raise an error if the delover output has an error
    raise 'Error posting the app to the App Store Connect' if deliver_output.include?('ERROR ITMS-')

    # upload to ms app center
    upload_application(
      bundle_identifier: @@envHelper.bundle_identifier,
      build_type: 'Store',
      zapp_build_type: 'release'
    )
  end

  def download_signing_files
    current(__callee__.to_s)
    # create new dir for files
    sh("mkdir -p \"#{@projectHelper.credentials_folder_path}\"")
    # download p12 and provisioning profile
    sh("curl -sL \"#{@@envHelper.provisioning_profile_url}\" --output \"#{@projectHelper.distribution_provisioning_profile_path}\"")
    sh("curl -sL \"#{@@envHelper.distribution_key_url}\" --output \"#{@projectHelper.distribution_certificate_path}\"")
  end

  def perform_signing_validation
    current(__callee__.to_s)
    download_signing_files

    validate(
      certificate_path: @projectHelper.distribution_certificate_path,
      certificate_password: @@envHelper.distribution_key_password,
      provisioning_profile_path: @projectHelper.distribution_provisioning_profile_path,
      version_number: @@envHelper.version_name,
      appstore_username: itunesconnect_username,
      appstore_password: itunesconnect_password
    )
  end

  def prepare_signing
    current(__callee__.to_s)
    # fetch values
    provisioning_profile = get_provisioning_profile_content(@projectHelper.distribution_provisioning_profile_path)
    team_id_value = provisioning_profile['Entitlements']['com.apple.developer.team-identifier']
    team_name_value = provisioning_profile['TeamName']
    provisioning_profile_uuid_value = provisioning_profile['UUID']
    provisioning_profile_app_groups_value = provisioning_profile['Entitlements']['com.apple.security.application-groups']

    # save values
    save_param_to_file("#{@@envHelper.bundle_identifier}_PROFILE_UDID", provisioning_profile_uuid_value.to_s)
    save_param_to_file("#{@@envHelper.bundle_identifier}_TEAM_ID", team_id_value.to_s)
    save_param_to_file("#{@@envHelper.bundle_identifier}_TEAM_NAME", team_name_value.to_s)
    save_param_to_file("#{@@envHelper.bundle_identifier}_APP_GROUPS", provisioning_profile_app_groups_value.to_json)

    # install provisioning profile
    sh("mkdir -p ~/Library/MobileDevice/'Provisioning Profiles'")
    sh("cp #{@projectHelper.distribution_provisioning_profile_path} ~/Library/MobileDevice/'Provisioning Profiles'/#{provisioning_profile_uuid}.mobileprovision")

    import_certificate(
      certificate_path: @projectHelper.distribution_certificate_path,
      certificate_password: @@envHelper.distribution_key_password,
      keychain_name: @@envHelper.keychain_name,
      keychain_password: @@envHelper.keychain_password
    )

    sh("bundle exec fastlane fastlane-credentials add --username #{itunesconnect_username} --password '#{itunesconnect_password}'")
    ENV['FASTLANE_PASSWORD'] = itunesconnect_password
  end

  def prepare_build
    current(__callee__.to_s)
    # update app base parameters in FeaturesCustomization.json
    update_parameters_in_feature_optimization_json

    # update ms_app_center app secret
    @appCenterHelper.update_app_secret(@@envHelper.bundle_identifier.to_s)

    # update firebase configuration
    @firebaseHelper.add_configuration_file('production')

    # update app identifier to the store one
    reset_info_plist_bundle_identifier(
      xcodeproj: @projectHelper.xcodeproj_path,
      plist_path: @projectHelper.plist_inner_path
    )
    update_app_identifier(
      xcodeproj: @projectHelper.xcodeproj_path,
      plist_path: @projectHelper.plist_inner_path,
      app_identifier: @@envHelper.bundle_identifier
    )

    # add support for push notifications
    if @projectHelper.plugins_for_type('push_provider').count > 0
      @projectHelper.change_system_capability(
        capability: 'com.apple.Push',
        old: 0,
        new: 1
      )
    else
      # if not plugin attached - delete notifications entitlements if exists
      remove_key_from_entitlements(@projectHelper.name.to_s, 'Release', 'aps-environment')
      # remove remote notification background mode
      remove_background_modes(
        xcodeproj: @projectHelper.xcodeproj_path,
        plist_path: @projectHelper.plist_inner_path,
        modes_to_remove: [
          {
            name: 'remote-notification'
          }
        ]
      )
    end

    # set info plist SupportedAppGroups param for app target
    set_info_plist_supported_groups_param(
      xcodeproj: @projectHelper.xcodeproj_path,
      plist_path: @projectHelper.plist_inner_path,
      app_groups: get_app_provisioning_profile_app_groups
    )

    # add AccessWiFi if needed
    add_wifi_system_capability_if_needed

    prepare_extensions
  end

  def prepare_extensions
    current(__callee__.to_s)
    build_type = 'release'
    @appExtensions.prepare_notification_extension(
      build_type: build_type,
      extension_type: @appExtensions.notification_service_extension_key,
      extension_target_name: @appExtensions.notification_service_extension_target_name,
      extension_bundle_identifier: @appExtensions.notification_service_extension_bundle_identifier,
      extension_info_plist_inner_path: @appExtensions.notification_service_extension_info_plist_inner_path,
      extension_info_plist_path: @appExtensions.notification_service_extension_info_plist_path
    )

    @appExtensions.prepare_notification_extension(
      build_type: build_type,
      extension_type: @appExtensions.notification_content_extension_key,
      extension_target_name: @appExtensions.notification_content_extension_target_name,
      extension_bundle_identifier: @appExtensions.notification_content_extension_bundle_identifier,
      extension_info_plist_inner_path: @appExtensions.notification_content_extension_info_plist_inner_path,
      extension_info_plist_path: @appExtensions.notification_content_extension_info_plist_path
    )
  end

  def itunesconnect_username
    (ENV['itunes_connect_user']).to_s
  end

  def itunesconnect_password
    (ENV['itunes_connect_password']).to_s
  end
end
