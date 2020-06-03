import "Base/Helpers/BaseHelper.rb"

class ProjectHelper < BaseHelper
    def change_system_capability(capability, old_value, new_value)
        project = "#{xcodeproj_path}/project.pbxproj"
        regex = /(#{capability} = {\s+enabled\s=\s)#{old_value}(;\s+};)/
        substitue = %Q(\\1#{new_value}\\2)
        new_content = File.read(project).gsub!(regex, substitue)
        File.write(project, new_content) if new_content
    end

    def xcodeproj_path
        "#{path}/#{name}.xcodeproj"
    end

    def xcworkspace_relative_path
        "../#{folder_name}/#{name}.xcworkspace"
    end

    def folder_name
        "#{name}"
    end
    
    def scheme
        "#{name}"
    end

    def name
        @@envHelper.device_target == "apple_tv" ? "ZappTvOS" : "ZappiOS"
    end

    def path
        "#{@@envHelper.root_path}/#{folder_name}"
    end

    def credentials_folder_path
        "#{path}/Credentials/"
    end

    def customizations_folder_path
        "#{@@envHelper.root_path}/ZappApple/Customization"
    end

    def build_path
        "#{@@envHelper.root_path}/build"
    end

    def distribution_certificate_filename
        "dist.p12"
    end

    def distribution_certificate_path
        "#{credentials_folder_path}#{distribution_certificate_filename}"
    end


    def distribution_provisioning_profile_filename
        "dist.mobileprovision"
    end

    def distribution_provisioning_profile_path
        "#{credentials_folder_path}#{distribution_provisioning_profile_filename}"
    end

    def update_features_customization(param_name, param_value)
        Actions::sh("/usr/libexec/PlistBuddy -c \"Set #{param_name} #{param_value}\" #{customizations_folder_path}/FeaturesCustomization.plist")
        puts "#{param_name} value was updated successfully in FeaturesCustomization.plist"
    end
      
    def plist_update_version_values(target_name, target_bundle_identifier)
        # update app identifier, versions of the extension
        bundle_version = Actions::GetInfoPlistValueAction.run(
          path: plist_path,
          key: "CFBundleVersion"
        )
        bundle_short_version = Actions::GetInfoPlistValueAction.run(
          path: plist_path,
          key: "CFBundleShortVersionString"
        )
        
        Actions::UpdateInfoPlistAction.run(
          xcodeproj: xcodeproj_path,
          plist_path: "#{target_name}/Info.plist",
          block: lambda do |plist|
            plist['CFBundleVersion'] = bundle_version
            plist['CFBundleShortVersionString'] = bundle_short_version
          end
        )
    
        # update app identifier to the enterprise one
        Actions::UpdateAppIdentifierAction.run(
          xcodeproj: xcodeproj_path,
          plist_path: "#{target_name}/Info.plist",
          app_identifier: target_bundle_identifier
        )  
    end
    
    def plist_reset_to_bundle_identifier_placeholder(proj_path, info_plist_path)
        Actions::UpdateInfoPlistAction.run(
            xcodeproj: proj_path,
            plist_path: info_plist_path,
            block: lambda do |plist|
                plist['CFBundleIdentifier'] = "$(PRODUCT_BUNDLE_IDENTIFIER)"
            end
        )
    end

    def plist_path
        "#{path}/#{plist_inner_path}"
    end

    def plist_inner_path
        "#{name}/Info.plist"
    end
end
