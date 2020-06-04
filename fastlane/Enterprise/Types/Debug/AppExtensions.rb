class EnterpriseDebugAppExtensions < AppExtensions
  def group_name(app_bundle_identifier)
    "group.#{app_bundle_identifier}"
  end
  
  def extension_prepare(
      enterprise_debug_username,
      enterprise_debug_team_id,
      enterprise_debug_team_name,
      enterprise_debug_app_bundle_identifier,
      extension_type, 
      extension_target_name, 
      extension_app_name, 
      extension_bundle_identifier, 
      extension_info_plist_inner_path,
      extension_info_plist_path
    )
    build_type = "debug"
    # getting the indication if extension is enabled
    entension_enabled = sh("echo $(/usr/libexec/PlistBuddy -c \"Print :SupportedAppExtensions:#{extension_type}:#{build_type}_enabled\" #{@@projectHelper.customizations_folder_path}/FeaturesCustomization.plist 2>/dev/null | grep -c true)")
    if entension_enabled.to_i() > 0
  
      prepare_notification_extension(
        build_type,
        extension_type,
        extension_target_name,
        extension_bundle_identifier,
        extension_info_plist_inner_path,
        extension_info_plist_path
      )
  
      # create app for the notifications
      create_app_on_dev_portal(
        username: enterprise_debug_username,
        team_id: enterprise_debug_team_id,
        app_name: extension_app_name,
        bundle_identifier: extension_bundle_identifier,
        app_index: extension_type
      )
  
      # create group for app and notification extension
      sh("bundle exec fastlane produce group -g #{group_name(enterprise_debug_app_bundle_identifier)} -n '#{@@envHelper.bundle_identifier} Group' -u #{enterprise_debug_username} ")
  
      # add the app and the notification extension to the created group
      sh("bundle exec fastlane produce associate_group #{group_name(enterprise_debug_app_bundle_identifier)} -a #{enterprise_debug_app_bundle_identifier} -u #{enterprise_debug_username} ")
      sh("bundle exec fastlane produce associate_group #{group_name(enterprise_debug_app_bundle_identifier)} -a #{extension_bundle_identifier} -u #{enterprise_debug_username} -i 1")
      
      # create provisioning profile for the notifications app
      enterprise_debug_create_provisioning_profile(
        username: enterprise_debug_username,
        team_id: enterprise_debug_team_id,
        team_name: enterprise_debug_team_name,
        bundle_identifier: extension_bundle_identifier
      )
      
      # add group to entitlements
      update_group_identifiers(
        "#{@@projectHelper.name}",
        "Release",
        ["#{group_name(enterprise_debug_app_bundle_identifier)}"]
      )
  
      update_group_identifiers(
        "#{extension_target_name}",
        "Release",
        ["#{group_name(enterprise_debug_app_bundle_identifier)}"]
      )

      add_extension_to_project(
        "#{extension_target_name}"
    )
    end
  end  

  def update_group_identifiers(target, build_type, groups)
    file_path = "#{@@projectHelper.path}/#{target}/Entitlements/#{target}-#{build_type}.entitlements"
  
    Actions::UpdateAppGroupIdentifiersAction.run(
      entitlements_file: "#{file_path}",
      app_group_identifiers: groups
    )
  end
end