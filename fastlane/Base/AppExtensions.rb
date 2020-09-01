# frozen_string_literal: true

require 'fastlane/action'
require 'fastlane'

import 'Base/Helpers/ProjectHelper.rb'

class AppExtensions < BaseHelper
  attr_accessor :projectHelper
  def initialize(options = {})
    super
    @projectHelper = options[:projectHelper]
  end

  def remove_from_project(target_name)
    update_app_target do |target|
      target.dependencies.reject! do |dependency|
        dependency.target.name == target_name.to_s
      end
    end
  end

  def update_app_target
    require 'xcodeproj'

    project = Xcodeproj::Project.open(@projectHelper.xcodeproj_path.to_s)
    target = project.native_targets.find { |s| s.name == @projectHelper.scheme.to_s }

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

    extension_enabled = false
    plist_content = get_plist_content("#{@projectHelper.customizations_folder_path}/FeaturesCustomization.plist")
    supported_app_extensions = plist_content['SupportedAppExtensions']
    unless supported_app_extensions.nil?
      supported_extension_for_type = supported_app_extensions[extension_type.to_s]
      extension_enabled = supported_extension_for_type["#{build_type}_enabled"] unless supported_extension_for_type.nil?
    end

    if extension_enabled
      # print extension enabled
      sh("echo '#{extension_type} enabled'")

      # update app identifier, versions of the notification extension
      @projectHelper.plist_update_version_values(
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
      @projectHelper.change_system_capability(
        capability: 'com.apple.ApplicationGroups.iOS',
        old: 0,
        new: 1
      )

      # update app identifier for to the notification extension
      reset_info_plist_bundle_identifier(
        xcodeproj: @projectHelper.xcodeproj_path,
        plist_path: extension_info_plist_inner_path
      )

      # set info plist SupportedAppGroups param for extension target
      set_info_plist_supported_groups_param(
        xcodeproj: @projectHelper.xcodeproj_path,
        plist_path: extension_info_plist_inner_path,
        app_groups: get_app_provisioning_profile_app_groups
      )

      update_app_identifier(
        xcodeproj: @projectHelper.xcodeproj_path,
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
    sh("configure_extensions add #{@projectHelper.xcodeproj_path} #{@projectHelper.name} #{target_name}")
  end

  def provisioning_profile_uuid(extension_type)
    plist_content = get_plist_content("#{@projectHelper.customizations_folder_path}/FeaturesCustomization.plist")
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
    "#{@projectHelper.path}/#{notification_service_extension_target_name}/Info.plist"
  end

  def notification_service_extension_info_plist_inner_path
    "#{notification_service_extension_target_name}/Info.plist"
  end

  def notification_service_extension_bundle_identifier
    "#{@@envHelper.bundle_identifier}.#{notification_service_extension_target_name}"
  end

  # notification content extension
  def notification_content_extension_key
    'NOTIFICATION_CONTENT_EXTENSION'
  end

  def notification_content_extension_target_name
    'NotificationContentExtension'
  end

  def notification_content_extension_info_plist_path
    "#{@projectHelper.path}/#{notification_content_extension_target_name}/Info.plist"
  end

  def notification_content_extension_info_plist_inner_path
    "#{notification_content_extension_target_name}/Info.plist"
  end

  def notification_content_extension_bundle_identifier
    "#{@@envHelper.bundle_identifier}.#{notification_content_extension_target_name}"
  end
end
