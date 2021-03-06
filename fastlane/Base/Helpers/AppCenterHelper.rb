# frozen_string_literal: true

require 'fastlane/action'
require 'fastlane'

import 'Base/Helpers/ProjectHelper.rb'
import 'Base/Helpers/BaseHelper.rb'

class AppCenterHelper < BaseHelper
  attr_accessor :project_helper

  def initialize(options = {})
    super
    @project_helper = options[:project_helper]
  end

  def fetch_identifiers(bundle_identifier)
    unless app_center_api_token.empty?
      puts("Fetching App Center identifiers ms_app_center:fetch_identifiers[#{bundle_identifier}")
      sh("bundle exec rake ms_app_center:fetch_identifiers[#{bundle_identifier}]")
    end
  end

  def read_value_from_file(bundle_identifier, type)
    folder_name = "#{@@env_helper.root_path}/.build_params"
    filename = "#{folder_name}/#{bundle_identifier}_#{type}"
    File.read(filename.to_s).strip if File.exist? filename.to_s
  end

  def upload_app(options)
    unless app_center_api_token.empty?
      current(__callee__.to_s)

      build_type = options[:build_type]
      zapp_build_type = options[:zapp_build_type]
      bundle_identifier = options[:bundle_identifier]
      app_display_name = @@env_helper.app_name
      app_name = read_value_from_file(bundle_identifier, 'appname')
      app_secret = read_value_from_file(bundle_identifier, 'appsecret')
      app_distribution_group = read_value_from_file(bundle_identifier, 'appgroup')
      app_platform = 'Objective-C-Swift'
      app_os = app_center_platform

      @fastlane.appcenter_upload(
        api_token: app_center_api_token,
        owner_name: app_center_owner_name,
        destinations: app_distribution_group,
        destination_type: 'group',
        app_os: app_os,
        app_platform: app_platform,
        app_display_name: app_display_name,
        app_name: app_name,
        ipa: "#{circle_artifacts_folder_path}/#{build_type}/#{@project_helper.scheme}-#{build_type}.ipa",
        dsym: "#{circle_artifacts_folder_path}/#{build_type}/#{@project_helper.scheme}-#{build_type}.app.dSYM.zip",
        notify_testers: false
      )

      # save uploaded app info to file for future use
      save_build_params_for_type(
        bundle_identifier: options[:bundle_identifier],
        project_scheme: @project_helper.scheme,
        zapp_build_type: options[:zapp_build_type],
        app_name: app_name,
        app_secret: app_secret,
        build_information: @fastlane.lane_context[SharedValues::APPCENTER_BUILD_INFORMATION]
      )
    end
  end

  def update_app_secret(bundle_identifier)
    current(__callee__.to_s)

    app_secret = read_value_from_file(bundle_identifier, 'appsecret')

    @project_helper.update_features_customization(
      name: 'MSAppCenterAppSecret',
      value: app_secret
    )

    # add appcenter url scheme to the app
    update_url_schemes(
      plist_path: @project_helper.plist_path.to_s,
      scheme: "appcenter-#{app_secret}"
    )
    puts "MS App Center app secret #{app_secret} was updated successfully for bundle identifier: #{bundle_identifier}"
  end

  def app_center_api_token
    (ENV['APPCENTER_API_TOKEN']).to_s
  end

  def app_center_owner_name
    (ENV['APPCENTER_OWNER_NAME']).to_s
  end

  def app_center_platform
    'iOS'
  end
end
