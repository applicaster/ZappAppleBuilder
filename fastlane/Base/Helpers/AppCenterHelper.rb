# frozen_string_literal: true

require 'fastlane/action'
require 'fastlane'

import 'Base/Helpers/ProjectHelper.rb'
import 'Base/Helpers/BaseHelper.rb'

class AppCenterHelper < BaseHelper
  attr_accessor :projectHelper
  def initialize(options = {})
    super
    @projectHelper = options[:projectHelper]
  end

  def fetch_identifiers(bundle_identifier)
    unless app_center_api_token.empty?
      puts("Fetching App Center identifiers ms_app_center:fetch_identifiers[#{bundle_identifier}")
      sh("bundle exec rake ms_app_center:fetch_identifiers[#{bundle_identifier}]")
    end
  end

  def read_value_from_file(bundle_identifier, type)
    folder_name = "#{@@envHelper.root_path}/.ms_app_center"
    folder_name = folder_name.gsub('fastlane/', '')
    filename = "#{folder_name}/#{bundle_identifier}_#{type}"
    File.read(filename.to_s).strip if File.exist? filename.to_s
  end

  def upload_app(options)
    unless app_center_api_token.empty?
      current(__callee__.to_s)

      build_type = options[:build_type]
      zapp_build_type = options[:zapp_build_type]
      bundle_identifier = options[:bundle_identifier]
      app_display_name = @@envHelper.app_name
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
        ipa: "#{circle_artifacts_folder_path}/#{build_type}/#{@projectHelper.scheme}-#{build_type}.ipa",
        dsym: "#{circle_artifacts_folder_path}/#{build_type}/#{@projectHelper.scheme}-#{build_type}.app.dSYM.zip",
        notify_testers: false
      )

      # save uploaded app info to file for future use
      save_build_params_for_type(
        bundle_identifier: options[:bundle_identifier],
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

    @projectHelper.update_features_customization(
      name: 'MSAppCenterAppSecret',
      value: app_secret
    )

    # add appcenter url scheme to the app
    update_url_schemes(
      plist_path: @projectHelper.plist_path.to_s,
      scheme: "appcenter-#{app_secret}"
    )
    puts "MS App Center app secret #{app_secret} was updated successfully for bundle identifier: #{bundle_identifier}"
  end

  def save_build_params_for_type(options)
    current(__callee__.to_s)

    folder_name = "#{@@envHelper.root_path}/.ms_app_center"
    folder_name = folder_name.gsub('fastlane/', '')
    filename = "#{folder_name}/#{options[:zapp_build_type]}_upload_params.json"
    hash = build_params_hash_for_type(options)
    Dir.mkdir(folder_name) unless File.exist?(folder_name)
    File.open(filename, 'w') do |f|
      f.write(hash.to_json)
    end
    puts("content: #{hash}")
  end

  def build_params_hash_for_type(options)
    current(__callee__.to_s)

    s3DestinationPathParams = @@envHelper.s3_upload_path(options[:bundle_identifier])
    s3DistanationPath = "https://assets-secure.applicaster.com/#{s3DestinationPathParams}/#{@projectHelper.scheme}-#{options[:build_type]}.ipa"

    if @@envHelper.isTvOS
      time = Time.new
      {
        uploaded_at: time.inspect,
        download_url: s3DistanationPath
      }
    else
      s3InstallURL = "https://assets-secure.applicaster.com/#{s3DestinationPathParams}/index.html"
      release_info = options[:build_information]
      {
        uploaded_at: time.inspect,
        download_url: s3DistanationPath,
        install_url: s3InstallURL,
        id: release_info['id'],
        app_name: options[:app_name],
        app_secret: options[:app_secret]
      }
    end
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
