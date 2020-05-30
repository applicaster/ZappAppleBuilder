# import "Base/Base.rb"

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
