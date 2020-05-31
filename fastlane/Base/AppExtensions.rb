
def app_extensions_remove_from_project(target_name)
    app_extensions_update_zapp_app_target do |target|
        target.dependencies.reject! do |dependency|
            dependency.target.name == "#{target_name}"
        end

        target.build_phases.reject! do |phase|
        phase.is_a?(Xcodeproj::Project::Object::PBXCopyFilesBuildPhase) && phase.name == "Embed App Extensions"
        end
    end
end

def app_extensions_update_zapp_app_target()
    require 'xcodeproj'
  
    project = Xcodeproj::Project.open("#{xcodeproj_path}")
    target = project.native_targets.find {|s| s.name == "#{project_scheme}" }
  
    yield(target)
  
    project.save
end

def app_extensions_prepare_notification_extension(
    build_type,
    extension_type,
    extension_target_name,
    extension_bundle_identifier,
    extension_info_plist_inner_path,
    extension_info_plist_path
    )
    entension_enabled = sh("echo $(/usr/libexec/PlistBuddy -c \"Print :SupportedAppExtensions:#{extension_type}:#{build_type}_enabled\" #{customizations_folder_path}/FeaturesCustomization.plist 2>/dev/null | grep -c true)")
    if entension_enabled.to_i() > 0
        # print extension enabled
        sh("echo '#{extension_type} enabled'")

        # update app identifier, versions of the notification extension
        info_plist_update_values(
            extension_target_name,
            extension_bundle_identifier
        )

        # save app identifier of the notification extension
        ENV["#{extension_bundle_identifier}"] = get_info_plist_value(path: "#{extension_info_plist_path}", key: "CFBundleIdentifier")
        # change app groups support on project file
        project_change_system_capability(
            "com.apple.ApplicationGroups.iOS",
            0,
            1
        )

        # update app identifier for to the notification extension
        info_plist_reset_to_bundle_identifier_placeholder(xcodeproj_path, extension_info_plist_inner_path)
        update_app_identifier(
            xcodeproj: xcodeproj_path,
            plist_path: extension_info_plist_inner_path,
            app_identifier: extension_bundle_identifier
        )
    else
        # notification extension disabled
        sh("echo '#{extension_type} disabled'")
        # remove extension from build dependency and scripts step
        app_extensions_remove_from_project(
            "#{extension_target_name}"
        )
    end
end

def app_extension_provisioning_profile_uuid(extension_type)
    sh("echo $(/usr/libexec/PlistBuddy -c \"Print :SupportedAppExtensions:#{extension_type}:provisioning_profile_uuid\" #{customizations_folder_path}/FeaturesCustomization.plist 2>/dev/null) | tr -d '\040\011\012\015'")
end

# notification service extension
def notification_service_extension_key
    "NOTIFICATION_SERVICE_EXTENSION"
end

def notification_service_extension_target_name
    "NotificationServiceExtension"
end

def notification_service_extension_info_plist_path
    "#{project_path}/#{notification_service_extension_target_name}/Info.plist"
end

def notification_service_extension_info_plist_inner_path
    "#{notification_service_extension_target_name}/Info.plist"
end

def notification_service_extension_bundle_identifier
    "#{bundle_identifier}.#{notification_service_extension_target_name}"
end

# notification content extension
def notification_content_extension_key
    "NOTIFICATION_CONTENT_EXTENSION"
end

def notification_content_extension_target_name
    "NotificationContentExtension"
end

def notification_content_extension_info_plist_path
    "#{project_path}/#{notification_content_extension_target_name}/Info.plist"
end

def notification_content_extension_info_plist_inner_path
    "#{notification_content_extension_target_name}/Info.plist"
end

def notification_content_extension_bundle_identifier
    "#{bundle_identifier}.#{notification_content_extension_target_name}"
end
