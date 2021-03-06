# frozen_string_literal: true

require 'fastlane/action'
require 'fastlane'

import 'Base/Helpers/ProjectHelper.rb'

class AppExtensions < BaseHelper
  attr_accessor :project_helper

  def initialize(options = {})
    super
    @project_helper = options[:project_helper]
  end

  def remove_app_extensions_targets_from_project(options)
    puts('Removing notifications extensions from project, enabled extensions will be added on build step')
    extension_target_names = [
      notification_content_extension_target_name,
      notification_service_extension_target_name
    ]

    extension_target_names.each do |extension_target_name|
      remove_from_project(extension_target_name, options)
    end
  end

  def remove_from_project(target_name, options)
    puts "Removing #{target_name}"
    update_app_target(options) do |target|
      target.dependencies.reject! do |dependency|
        dependency.target.name == target_name.to_s
      end
    end
  end

  def update_app_target(options)
    project_path = options[:project_path]
    project_scheme = options[:project_scheme]

    require 'xcodeproj'

    project = Xcodeproj::Project.open(project_path)
    target = project.native_targets.find { |s| s.name == project_scheme }

    yield(target)

    project.save
  end

  def prepare_notification_extension(options)
    build_type = options[:build_type]
    extension_type = options[:extension_type]
    extension_target_name = options[:extension_target_name]
    extension_bundle_identifier = options[:extension_bundle_identifier]
    extension_info_plist_inner_path = options[:extension_info_plist_inner_path]
    extension_info_plist_path = options[:extension_info_plist_path]
    app_bunlde_identifier = options[:app_bunlde_identifier]

    extension_enabled = false
    plist_content = get_plist_content("#{@project_helper.customizations_folder_path}/FeaturesCustomization.plist")
    supported_app_extensions = plist_content['SupportedAppExtensions']
    unless supported_app_extensions.nil?
      supported_extension_for_type = supported_app_extensions[extension_type.to_s]
      extension_enabled = supported_extension_for_type["#{build_type}_enabled"] unless supported_extension_for_type.nil?
    end

    if extension_enabled
      # print extension enabled
      sh("echo '#{extension_type} enabled'")

      # update app identifier, versions of the notification extension
      @project_helper.plist_update_version_values(
        target_name: extension_target_name,
        plist_path: extension_info_plist_path,
        bundle_identifier: extension_bundle_identifier
      )

      # save app identifier of the notification extension
      ENV[extension_bundle_identifier.to_s] = get_plist_value(
        plist_path: extension_info_plist_path.to_s,
        key: 'CFBundleIdentifier'
      )
      # change app groups support on project file
      @project_helper.change_system_capability(
        capability: 'com.apple.ApplicationGroups.iOS',
        old: 0,
        new: 1
      )

      # update app identifier for to the notification extension
      reset_info_plist_bundle_identifier(
        xcodeproj: @project_helper.xcodeproj_path,
        plist_path: extension_info_plist_inner_path
      )

      # set info plist SupportedAppGroups param for extension target
      set_info_plist_supported_groups_param(
        xcodeproj: @project_helper.xcodeproj_path,
        plist_path: extension_info_plist_inner_path,
        app_groups: get_app_provisioning_profile_app_groups(app_bunlde_identifier)
      )

      update_app_identifier(
        xcodeproj: @project_helper.xcodeproj_path,
        plist_path: extension_info_plist_inner_path,
        app_identifier: extension_bundle_identifier
      )

      add_extension_to_project(
        extension_target_name.to_s
      )

    else
      # notification extension disabled
      sh("echo '#{extension_type} disabled'")
    end
  end

  def add_extension_to_project(target_name)
    sh("configure_extensions add #{@project_helper.xcodeproj_path} #{@project_helper.name} #{target_name}")
  end

  def provisioning_profile_uuid(extension_type)
    plist_content = get_plist_content("#{@project_helper.customizations_folder_path}/FeaturesCustomization.plist")
    supported_extension = plist_content['SupportedAppExtensions']
    supported_extension_for_type = supported_extension[extension_type.to_s]
    supported_extension_for_type['provisioning_profile_uuid'] unless supported_extension_for_type.nil?
  end

  # notification service extension
  def notification_service_extension_key
    'NOTIFICATION_SERVICE_EXTENSION'
  end

  def notification_service_extension_target_name
    'NotificationServiceExtension'
  end

  def notification_service_extension_info_plist_path
    "#{@project_helper.path}/#{notification_service_extension_target_name}/Info.plist"
  end

  def notification_service_extension_info_plist_inner_path
    "#{notification_service_extension_target_name}/Info.plist"
  end

  def notification_service_extension_bundle_identifier
    "#{@@env_helper.bundle_identifier}.#{notification_service_extension_target_name}"
  end

  # notification content extension
  def notification_content_extension_key
    'NOTIFICATION_CONTENT_EXTENSION'
  end

  def notification_content_extension_target_name
    'NotificationContentExtension'
  end

  def notification_content_extension_info_plist_path
    "#{@project_helper.path}/#{notification_content_extension_target_name}/Info.plist"
  end

  def notification_content_extension_info_plist_inner_path
    "#{notification_content_extension_target_name}/Info.plist"
  end

  def notification_content_extension_bundle_identifier
    "#{@@env_helper.bundle_identifier}.#{notification_content_extension_target_name}"
  end
end
