# frozen_string_literal: true

class EnterpriseDebugAppExtensions < AppExtensions
  def group_name(app_bundle_identifier)
    "group.#{app_bundle_identifier}"
  end

  def extension_prepare(options)
    username = options[:username]
    team_id = options[:team_id]
    team_name = options[:team_name]
    app_bundle_identifier = options[:app_bundle_identifier]
    extension_type = options[:extension_type]
    extension_target_name = options[:extension_target_name]
    extension_app_name = options[:extension_app_name]
    extension_bundle_identifier = options[:extension_bundle_identifier]
    extension_info_plist_inner_path = options[:extension_info_plist_inner_path]
    extension_info_plist_path = options[:extension_info_plist_path]

    build_type = 'debug'
    entension_enabled = false
    # getting the indication if extension is enabled
    plist_content = get_plist_content("#{@projectHelper.customizations_folder_path}/FeaturesCustomization.plist")
    supported_app_extensions = plist_content['SupportedAppExtensions']
    unless supported_app_extensions.nil?
      puts("supported_app_extensions: #{supported_app_extensions}")
      supported_extension_for_type = supported_app_extensions[extension_type.to_s]
      puts("supported_extension_for_type: #{supported_extension_for_type}")

      unless supported_extension_for_type.nil?
        entension_enabled = supported_extension_for_type["#{build_type}_enabled"]
      end
    end

    if entension_enabled
      prepare_notification_extension(
        build_type: build_type,
        extension_type: extension_type,
        extension_target_name: extension_target_name,
        extension_bundle_identifier: extension_bundle_identifier,
        extension_info_plist_inner_path: extension_info_plist_inner_path,
        extension_info_plist_path: extension_info_plist_path
      )

      # create app for the notifications
      create_app_on_dev_portal(
        username: username,
        team_id: team_id,
        app_name: extension_app_name,
        bundle_identifier: extension_bundle_identifier,
        app_index: extension_type
      )

      # create group for app and notification extension
      sh("bundle exec fastlane produce group -g #{group_name(app_bundle_identifier)} -n '#{@@envHelper.bundle_identifier} Group' -u #{username} ")

      # add the app and the notification extension to the created group
      sh("bundle exec fastlane produce associate_group #{group_name(app_bundle_identifier)} -a #{app_bundle_identifier} -u #{username} ")
      sh("bundle exec fastlane produce associate_group #{group_name(app_bundle_identifier)} -a #{extension_bundle_identifier} -u #{username} -i 1")

      # create provisioning profile for the notifications app
      enterprise_debug_create_provisioning_profile(
        username: username,
        team_id: team_id,
        team_name: team_name,
        bundle_identifier: extension_bundle_identifier
      )

      # add group to entitlements
      update_group_identifiers(
        target: @projectHelper.name.to_s,
        build_type: 'Release',
        groups: [group_name(app_bundle_identifier).to_s]
      )

      update_group_identifiers(
        target: extension_target_name.to_s,
        build_type: 'Release',
        groups: [group_name(app_bundle_identifier).to_s]
      )

      add_extension_to_project(
        extension_target_name.to_s
      )

    else
      # notification extension disabled
      sh("echo '#{extension_type} disabled'")
    end
  end

  def update_group_identifiers(options)
    target = options[:target]
    build_type = options[:build_type]
    groups = options[:groups]
    file_path = "#{@projectHelper.path}/#{target}/Entitlements/#{target}-#{build_type}.entitlements"

    @fastlane.update_app_group_identifiers(
      entitlements_file: file_path.to_s,
      app_group_identifiers: groups
    )
  end
end
