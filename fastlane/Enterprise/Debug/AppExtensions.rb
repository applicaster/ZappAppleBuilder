
def base_ent_debug_app_extension_prepare(
    extension_type, 
    extension_target_name, 
    extension_app_name, 
    extension_bundle_identifier, 
    extension_info_plist_inner_path
)
    # getting the indication if extension is enabled
    entension_enabled = sh("echo $(/usr/libexec/PlistBuddy -c \"Print :SupportedAppExtensions:#{extension_type}:enterprise_enabled\" #{customizations_folder_path}/FeaturesCustomization.plist 2>/dev/null | grep -c true)")
    if entension_enabled.to_i() > 0
      # print extension enabled
      sh("echo '#{extension_type} enabled'")

      # update app identifier, versions of the notification extension
      info_plist_update_values(
        extension_target_name,
        extension_bundle_identifier
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
      sh("bundle exec fastlane produce group -g #{base_ent_app_group_name} -n '#{ENV['bundle_identifier']} Group' -u #{enterprise_debug_username} ")

      # add the app and the notification extension to the created group
      sh("bundle exec fastlane produce associate_group #{base_ent_app_group_name} -a #{enterprise_debug_app_bundle_identifier} -u #{enterprise_debug_username} ")
      sh("bundle exec fastlane produce associate_group #{base_ent_app_group_name} -a #{extension_bundle_identifier} -u #{enterprise_debug_username} -i 1")
      
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
        ["#{base_ent_app_group_name}"]
      )

      # update app identifier for to the notification extension
      info_plist_reset_to_bundle_identifier_placeholder(xcodeproj_path, extension_info_plist_inner_path)
      update_app_identifier(
        xcodeproj: xcodeproj_path,
        plist_path: extension_info_plist_inner_path,
        app_identifier: extension_bundle_identifier
      )

      base_ent_update_group_identifiers(
        "#{extension_target_name}",
        "Release",
        ["#{base_ent_app_group_name}"]
      )
      # change app groups support on project file
      project_change_system_capability(
        "com.apple.ApplicationGroups.iOS",
        0,
        1
      )
    else
      # print extension disabled
      sh("echo '#{extension_type} disabled'")
      # remove extension from build dependency and scripts step
      app_extensions_remove_from_project(
        extension_target_name
      )
    end
  end