# frozen_string_literal: true

import 'Base/Helpers/BaseHelper.rb'
import 'Base/Helpers/AssetsCatalogHelper.rb'

class ProjectHelper < BaseHelper
  attr_accessor :assets_catalog_helper

  def initialize(options = {})
    super
    @assets_catalog_helper = AssetsCatalogHelper.new(fastlane: @fastlane)
  end

  def change_system_capability(options)
    current(__callee__.to_s)

    project = "#{xcodeproj_path}/project.pbxproj"
    regex = /(#{options[:capability]} = {\s+enabled\s=\s)#{options[:old]}(;\s+};)/
    substitue = %(\\1#{options[:new]}\\2)
    new_content = File.read(project).gsub!(regex, substitue)
    File.write(project, new_content) if new_content
  end

  def xcodeproj_path
    "#{path}/#{xcodeproj_name}"
  end

  def xcodeproj_name
    "#{name}.xcodeproj"
  end

  def xcworkspace_relative_path
    "#{folder_name}/#{name}.xcworkspace"
  end

  def folder_name
    name.to_s
  end

  def scheme
    name.to_s
  end

  def name
    @@env_helper.device_target == 'apple_tv' ? 'ZappTvOS' : 'ZappiOS'
  end

  def path
    "#{@@env_helper.root_path}/#{folder_name}"
  end

  def credentials_folder_path
    "#{path}/Credentials/"
  end

  def customizations_folder_path
    "#{@@env_helper.root_path}/ZappApple/Customization"
  end

  def build_path
    "#{@@env_helper.root_path}/build"
  end

  def distribution_certificate_filename
    'dist.p12'
  end

  def distribution_certificate_path
    "#{credentials_folder_path}#{distribution_certificate_filename}"
  end

  def distribution_provisioning_profile_filename
    'dist.mobileprovision'
  end

  def distribution_provisioning_profile_path
    "#{credentials_folder_path}#{distribution_provisioning_profile_filename}"
  end

  def update_features_customization(options)
    current(__callee__.to_s)

    sh("/usr/libexec/PlistBuddy -c \"Set #{options[:name]} #{options[:value]}\" #{customizations_folder_path}/FeaturesCustomization.plist")
    puts "#{options[:name]} value was updated successfully in FeaturesCustomization.plist"
  end

  def plist_update_version_values(options)
    current(__callee__.to_s)

    update_info_plist_versions(
      xcodeproj: xcodeproj_path,
      plist_path: "#{options[:target_name]}/Info.plist",
      bundle_version: @@env_helper.build_version,
      bundle_short_version: @@env_helper.version_name
    )

    # update app identifier to the enterprise one
    update_app_identifier(
      xcodeproj: xcodeproj_path,
      plist_path: "#{options[:target_name]}/Info.plist",
      app_identifier: (options[:bundle_identifier]).to_s
    )
  end

  def plugins_for_type(type)
    json = get_json_content("#{path}/#{folder_name}/Resources/plugin_configurations.json")
    json.select { |a| a['plugin']['type'] == type }
  end

  def plist_path
    "#{path}/#{plist_inner_path}"
  end

  def plist_inner_path
    "#{name}/Info.plist"
  end

  def organize_resources_to_assets_catalog
    current(__callee__.to_s)
    @assets_catalog_helper.organize_resources_to_assets_catalog(
      assets_catalog: 'Assets.xcassets',
      path: "#{path}/#{folder_name}",
      platform: @@env_helper.platform_name
    )
  end
end
