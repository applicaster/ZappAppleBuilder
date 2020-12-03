# frozen_string_literal: true

require 'fastlane/action'
require 'fastlane_core'
require 'fastlane'
require 'openssl'
require 'date'
require 'colorize'
require 'plist'
require 'json'

import 'Base/Helpers/EnvironmentHelper.rb'

class BaseHelper
  @@envHelper = EnvironmentHelper.new

  attr_accessor :fastlane

  def initialize(options = {})
    @fastlane = options[:fastlane]
  end

  def sh(command)
    @fastlane.sh(command)
  end

  def params_folder_path
    "#{@@envHelper.root_path}/fastlane/.fastlane_params"
  end

  def read_param_from_file(name)
    current(__callee__.to_s)
    puts("param: |#{name}|")
    filename = "#{params_folder_path}/#{name}"
    File.read(filename.to_s).strip if File.exist? filename.to_s
  end

  def save_param_to_file(name, value)
    current(__callee__.to_s)
    puts("param: |#{name}|, value: |#{value}|")
    filename = "#{params_folder_path}/#{name}"
    Dir.mkdir(params_folder_path) unless File.exist?(params_folder_path)
    File.open(filename, 'w') do |f|
      f.write(value)
    end
  end

  def saved_param_filename(name)
    "#{params_folder_path}/#{name}"
  end

  def delete_keychain(options)
    current(__callee__.to_s)
    @fastlane.delete_keychain(
      name: options[:name]
    )
  end

  def update_url_schemes(options)
    current(__callee__.to_s)
    @fastlane.update_url_schemes(
      path: (options[:plist_path]).to_s,
      update_url_schemes: proc do |schemes|
        schemes + [(options[:scheme]).to_s]
      end
    )
  end

  def get_plist_value(options)
    current(__callee__.to_s)
    @fastlane.get_info_plist_value(
      path: options[:plist_path],
      key: options[:key]
    )
  end

  def update_app_identifier(options)
    current(__callee__.to_s)
    @fastlane.update_app_identifier(
      xcodeproj: options[:xcodeproj],
      plist_path: options[:plist_path],
      app_identifier: options[:app_identifier]
    )
  end

  def update_info_plist_versions(options)
    current(__callee__.to_s)
    @fastlane.update_info_plist(
      xcodeproj: options[:xcodeproj],
      plist_path: options[:plist_path],
      block: lambda do |plist|
        plist['CFBundleVersion'] = options[:bundle_version]
        plist['CFBundleShortVersionString'] = options[:bundle_short_version]
      end
    )
  end

  def remove_background_modes(options)
    current(__callee__.to_s)
    modes_to_remove = options[:modes_to_remove]
    @fastlane.update_info_plist(
      xcodeproj: options[:xcodeproj],
      plist_path: options[:plist_path],
      block: proc do |plist|
        modes_to_remove.each do |item|
          plist['UIBackgroundModes'].delete(item[:name])
        end
      end
    )
  end

  def reset_info_plist_bundle_identifier(options)
    current(__callee__.to_s)
    @fastlane.update_info_plist(
      xcodeproj: options[:xcodeproj],
      plist_path: options[:plist_path],
      block: lambda do |plist|
        plist['CFBundleIdentifier'] = '$(PRODUCT_BUNDLE_IDENTIFIER)'
      end
    )
  end

  def set_info_plist_supported_groups_param(options)
    current(__callee__.to_s)
    @fastlane.update_info_plist(
      xcodeproj: options[:xcodeproj],
      plist_path: options[:plist_path],
      block: lambda do |plist|
        plist['SupportedAppGroups'] = options[:app_groups]
      end
    )
  end

  def update_project_team(options)
    current(__callee__.to_s)
    @fastlane.update_project_team(
      path: options[:xcodeproj],
      teamid: options[:teamid]
    )
  end

  def create_app_on_dev_portal(options)
    current(__callee__.to_s)
    # create app on developer portal with new identifier for notification extension
    @fastlane.produce(
      username: (options[:username]).to_s,
      app_identifier: (options[:bundle_identifier]).to_s,
      team_id: (options[:team_id]).to_s,
      app_name: (options[:app_name]).to_s,
      language: 'English',
      app_version: '1.0',
      sku: "#{options[:bundle_identifier]}.#{options[:app_index]}",
      skip_itc: true,
      enable_services: {
        app_group: 'on',
        associated_domains: 'on',
        data_protection: 'complete',
        in_app_purchase: 'on',
        push_notification: 'on',
        access_wifi: 'on'
      }
    )
  end

  def s3_upload(options)
    current(__callee__.to_s)
    @fastlane.aws_s3(
      access_key: @@envHelper.aws_access_key,
      secret_access_key: @@envHelper.aws_secret_access_key,
      bucket: @@envHelper.s3_bucket_name,
      region: @@envHelper.aws_region,
      ipa: (options[:ipa]).to_s,
      dsym: (options[:dsym]).to_s,
      path: "#{@@envHelper.s3_generic_upload_path(options[:bundle_identifier])}/",
      upload_metadata: true,
      html_in_folder: true,
      html_template_path: "#{@@envHelper.root_path}/rake/templates/s3_ipa.html.erb",
      version_file_name: "#{@@envHelper.s3_generic_upload_path(options[:bundle_identifier])}/version_distribution.json"
    )
  end

  def enterprise_debug_create_provisioning_profile(options)
    current(__callee__.to_s)
    @fastlane.sigh(
      username: options[:username],
      app_identifier: options[:bundle_identifier],
      team_id: options[:team_id],
      provisioning_name: "#{options[:bundle_identifier]} prov profile",
      filename: "#{options[:bundle_identifier]}.mobileprovision",
      platform: @@envHelper.platform_name
    )

    provisioning_profile = get_provisioning_profile_content("#{@@envHelper.root_path}/#{options[:bundle_identifier]}.mobileprovision")
    provisioning_profile_uuid_value = provisioning_profile['UUID']
    save_param_to_file("#{options[:bundle_identifier]}_PROFILE_UDID", provisioning_profile_uuid_value.to_s)
  end

  def delete_invalid_provisioning_profiles(options)
    current(__callee__.to_s)

    password = ENV['FASTLANE_PASSWORD']
    Spaceship::Portal.login(options[:username], options[:password])
    Spaceship::Portal.client.team_id = options[:team_id]

    profiles = Spaceship::Portal::ProvisioningProfile.all.find_all do |profile|
      ((profile.status == 'Invalid') || (profile.status == 'Expired')) && profile.app.bundle_id == options[:bundle_identifier]
    end

    profiles.each do |profile|
      sh("echo 'Deleting #{profile.name}, status: #{profile.status}'")
      profile.delete!
    end
  end

  def copy_artifacts(options)
    current(__callee__.to_s)
    @fastlane.copy_artifacts(
      target_path: options[:target_path],
      artifacts: options[:artifacts]
    )
  end

  def import_certificate(options)
    current(__callee__.to_s)
    @fastlane.import_certificate(
      certificate_path: options[:certificate_path],
      certificate_password: options[:certificate_password],
      keychain_name: options[:keychain_name],
      keychain_password: options[:keychain_password]
    )
  end

  def create_push_certificate(options)
    current(__callee__.to_s)
    @fastlane.get_push_certificate(
      username: (options[:username]).to_s,
      team_id: (options[:team_id]).to_s,
      team_name: (options[:team_name]).to_s,
      app_identifier: (options[:bundle_identifier]).to_s,
      generate_p12: true,
      p12_password: (options[:p12_password]).to_s,
      pem_name: 'apns',
      save_private_key: false,
      output_path: './CircleArtifacts',
      active_days_limit: 30
    )

    command = 'bundle exec '\
    'rake upload_enterprise_push:upload_certificate['\
    "#{ENV['accounts_account_id']},"\
    "#{ENV['bundle_identifier']},"\
    "#{circle_artifacts_folder_path},"\
    'apns.p12]'

    sh(command.to_s)
  end

  def update_group_identifiers(options)
    current(__callee__.to_s)
    target = options[:target]
    build_type = options[:build_type]
    groups = options[:groups]
    path = options[:path]

    file_path = "#{path}/#{target}/Entitlements/#{target}-#{build_type}.entitlements"

    @fastlane.update_app_group_identifiers(
      entitlements_file: file_path.to_s,
      app_group_identifiers: groups
    )
  end

  def circle_artifacts_folder_path
    "#{@@envHelper.root_path}/CircleArtifacts"
  end

  def build_app(options)
    current(__callee__.to_s)
    sh('fastlane gym ' \
      "--workspace \"#{options[:workspace]}\" " \
      "--scheme \"#{options[:scheme]}\" " \
      "--configuration \"#{options[:configuration]}\" " \
      "--include_bitcode #{options[:include_bitcode]} " \
      "--include_symbols #{options[:include_symbols]} " \
      "--output_directory \"#{options[:output_directory]}\" " \
      "--buildlog_path \"#{options[:buildlog_path]}\" " \
      "--output_name \"#{options[:output_name]}\" " \
      "--build_path \"#{options[:build_path]}\" " \
      "--derived_data_path \"#{options[:derived_data_path]}\" " \
      "--xcargs \"#{options[:xcargs]}\" " \
      "--export_method \"#{options[:export_method]}\" " \
      "--export_team_id \"#{options[:export_team_id]}\" " \
      "--export_options \"#{options[:export_options]}\" ")
  end

  def current(name)
    puts "#method: #{name}".colorize(:white).colorize(background: :blue)
  end

  def get_provisioning_profile_content(path)
    filename = './provisioning_profile.plist'
    sh("security cms -D -i #{path} > #{filename}")
    provisioning_profile = Plist.parse_xml(filename.to_s) if File.exist? filename.to_s
    File.delete(filename.to_s)
    provisioning_profile
  end

  def get_plist_content(path)
    Plist.parse_xml(path.to_s) if File.exist? path.to_s
  end

  def get_json_content(path)
    json = File.read(path.to_s).strip if File.exist? path.to_s
    JSON.parse(json)
  end

  def get_app_provisioning_profile_app_groups(bundle_identifier)
    current(__callee__.to_s)
    json = read_param_from_file("#{bundle_identifier}_APP_GROUPS")
    JSON.parse(json)
  end

  def group_name(app_bundle_identifier)
    "group.#{app_bundle_identifier}"
  end
end
