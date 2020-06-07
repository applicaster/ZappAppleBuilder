require 'fastlane/action'
require 'fastlane'

import "Base/Helpers/ProjectHelper.rb"

class AppExtensions < BaseHelper
    @@projectHelper = ProjectHelper.new

    def remove_from_project(target_name)
        update_app_target do |target|
            target.dependencies.reject! do |dependency|
                dependency.target.name == "#{target_name}"
            end
        end
    end
    
    def update_app_target()
        require 'xcodeproj'
      
        project = Xcodeproj::Project.open("#{@@projectHelper.xcodeproj_path}")
        target = project.native_targets.find {|s| s.name == "#{@@projectHelper.scheme}" }
      
        yield(target)
      
        project.save
    end
    
    def prepare_notification_extension(
        build_type,
        extension_type,
        extension_target_name,
        extension_bundle_identifier,
        extension_info_plist_inner_path,
        extension_info_plist_path
        )
        entension_enabled = sh("echo $(/usr/libexec/PlistBuddy -c \"Print :SupportedAppExtensions:#{extension_type}:#{build_type}_enabled\" #{@@projectHelper.customizations_folder_path}/FeaturesCustomization.plist 2>/dev/null | grep -c true)")
        if entension_enabled.to_i() > 0
            # print extension enabled
            sh("echo '#{extension_type} enabled'")
    
            # update app identifier, versions of the notification extension
            @@projectHelper.plist_update_version_values(
                target_name: extension_target_name,
                plist_path: extension_info_plist_path,
                bundle_identifier: extension_bundle_identifier
            )
    
            # save app identifier of the notification extension
            ENV["#{extension_bundle_identifier}"] = get_plist_value(
                plist_path: "#{extension_info_plist_path}", 
                key: "CFBundleIdentifier"
            )
            # change app groups support on project file
            @@projectHelper.change_system_capability(
                capability: "com.apple.ApplicationGroups.iOS",
                old: 0,
                new: 1
            )
    
            # update app identifier for to the notification extension
            reset_info_plist_bundle_identifier(
                xcodeproj: @@projectHelper.xcodeproj_path,
                plist_path: extension_info_plist_inner_path
            )
            update_app_identifier(
                xcodeproj: @@projectHelper.xcodeproj_path,
                plist_path: extension_info_plist_inner_path,
                app_identifier: extension_bundle_identifier
            )

        else
            # notification extension disabled
            sh("echo '#{extension_type} disabled'")
        end
    end
    
    def add_extension_to_project(target_name)
        sh("configure_extensions add #{@@projectHelper.xcodeproj_path} #{@@projectHelper.name} #{target_name}")
    end
    
    def provisioning_profile_uuid(extension_type)
        sh("echo $(/usr/libexec/PlistBuddy -c \"Print :SupportedAppExtensions:#{extension_type}:provisioning_profile_uuid\" #{@@projectHelper.customizations_folder_path}/FeaturesCustomization.plist 2>/dev/null) | tr -d '\040\011\012\015'")
    end
    
    # notification service extension
    def notification_service_extension_key
        "NOTIFICATION_SERVICE_EXTENSION"
    end
    
    def notification_service_extension_target_name
        "NotificationServiceExtension"
    end
    
    def notification_service_extension_info_plist_path
        "#{@@projectHelper.path}/#{notification_service_extension_target_name}/Info.plist"
    end
    
    def notification_service_extension_info_plist_inner_path
        "#{notification_service_extension_target_name}/Info.plist"
    end
    
    def notification_service_extension_bundle_identifier
        "#{@@envHelper.bundle_identifier}.#{notification_service_extension_target_name}"
    end
    
    # notification content extension
    def notification_content_extension_key
        "NOTIFICATION_CONTENT_EXTENSION"
    end
    
    def notification_content_extension_target_name
        "NotificationContentExtension"
    end
    
    def notification_content_extension_info_plist_path
        "#{@@projectHelper.path}/#{notification_content_extension_target_name}/Info.plist"
    end
    
    def notification_content_extension_info_plist_inner_path
        "#{notification_content_extension_target_name}/Info.plist"
    end
    
    def notification_content_extension_bundle_identifier
        "#{@@envHelper.bundle_identifier}.#{notification_content_extension_target_name}"
    end
end