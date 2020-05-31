def base_ent_debug_app_group_name
  "group.#{enterprise_debug_app_bundle_identifier}"
end

def base_ent_debug_app_extension_prepare(
    extension_type, 
    extension_target_name, 
    extension_app_name, 
    extension_bundle_identifier, 
    extension_info_plist_inner_path,
    extension_info_plist_path

  )
  build_type = "debug"
  # getting the indication if extension is enabled
  entension_enabled = sh("echo $(/usr/libexec/PlistBuddy -c \"Print :SupportedAppExtensions:#{extension_type}:#{build_type}_enabled\" #{customizations_folder_path}/FeaturesCustomization.plist 2>/dev/null | grep -c true)")
  if entension_enabled.to_i() > 0

    app_extensions_prepare_notification_extension(
      build_type,
      extension_type,
      extension_target_name,
      extension_bundle_identifier,
      extension_info_plist_inner_path,
      extension_info_plist_path
    )

    # create app for the notifications
    base_ent_create_app_on_dev_portal(
      enterprise_debug_username,
      enterprise_debug_team_id,
      extension_app_name,
      extension_bundle_identifier,
      "2"
    )

    # create group for app and notification extension
    sh("bundle exec fastlane produce group -g #{base_ent_debug_app_group_name} -n '#{ENV['bundle_identifier']} Group' -u #{enterprise_debug_username} ")

    # add the app and the notification extension to the created group
    sh("bundle exec fastlane produce associate_group #{base_ent_debug_app_group_name} -a #{enterprise_debug_app_bundle_identifier} -u #{enterprise_debug_username} ")
    sh("bundle exec fastlane produce associate_group #{base_ent_debug_app_group_name} -a #{extension_bundle_identifier} -u #{enterprise_debug_username} -i 1")
    
    # create provisioning profile for the notifications app
    base_ent_create_provisioning_profile(
      enterprise_debug_username,
      enterprise_debug_team_id,
      enterprise_debug_team_name,
      extension_bundle_identifier
    )
    
    # add group to entitlements
    base_ent_update_group_identifiers(
      "#{project_name}",
      "Release",
      ["#{base_ent_debug_app_group_name}"]
    )

    base_ent_update_group_identifiers(
      "#{extension_target_name}",
      "Release",
      ["#{base_ent_debug_app_group_name}"]
    )
  end
end

  