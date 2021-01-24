# frozen_string_literal: true

require 'fastlane/action'
require 'fastlane'
require 'colorize'

fastlane_require 'dotenv'
Dotenv.load
Fastlane.load_actions

import 'Base/AppExtensions.rb'
import 'Base/Helpers/FirebaseHelper.rb'
import 'Base/Helpers/ProjectHelper.rb'
import 'Base/Helpers/AppCenterHelper.rb'

class BuildType < BaseHelper
  attr_accessor :projectHelper, :firebaseHelper, :appCenterHelper, :appExtensions
  def initialize(options = {})
    super
    @projectHelper = ProjectHelper.new(fastlane: @fastlane)
    @firebaseHelper = FirebaseHelper.new(fastlane: @fastlane, projectHelper: @projectHelper)
    @appCenterHelper = AppCenterHelper.new(fastlane: @fastlane, projectHelper: @projectHelper)
    @appExtensions = AppExtensions.new(fastlane: @fastlane, projectHelper: @projectHelper)
  end

  def build_type
    # implement in child classes
  end

  def prepare_environment
    remove_app_extensions
    fetch_app_center_identifiers
    @projectHelper.organizeResourcesToAssetsCatalog
  end

  def download_signing_files
    # implement in child classes
  end

  def perform_signing_validation
    # implement in child classes
  end

  def build
    # implement in child classes
  end

  def fetch_app_center_identifiers
    @appCenterHelper.fetch_identifiers(@@envHelper.bundle_identifier.to_s)
  end

  def remove_key_from_entitlements(target, build_type, key)
    file_path = "#{@projectHelper.path}/#{target}/Entitlements/#{target}-#{build_type}.entitlements"

    sh("echo $(/usr/libexec/PlistBuddy -c \"Delete :#{key}\" #{file_path} 2>/dev/null)")
  end

  def update_parameters_in_feature_optimization_json
    @projectHelper.update_features_customization(
      name: 'S3Hostname',
      value: @@envHelper.s3_hostname
    )

    debug_environment = 'YES'
    if (build_type == 'enterprise') || (build_type == 'store')
      debug_environment = 'NO'
    end

    @projectHelper.update_features_customization(
      name: 'DebugEnvironment',
      value: debug_environment
    )
  end

  def add_wifi_system_capability_if_needed
    requires_wifi_capability = sh("echo $(/usr/libexec/PlistBuddy -c \"Print :com.apple.developer.networking.wifi-info\" #{@projectHelper.path}/#{@projectHelper.name}/Entitlements/#{@projectHelper.name}-Release.entitlements 2>/dev/null | grep -c true)")
    if requires_wifi_capability.to_i > 0
      @projectHelper.change_system_capability(
        capability: 'com.apple.AccessWiFi',
        old: 0,
        new: 1
      )
    end
  end

  def capture_stream(stream)
    raise ArgumentError, 'missing block' unless block_given?

    orig_stream = stream.dup
    IO.pipe do |r, w|
      # system call dup2() replaces the file descriptor
      stream.reopen(w)
      # there must be only one write end of the pipe;
      # otherwise the read end does not get an EOF
      # by the final `reopen`
      w.close
      t = Thread.new { r.read }
      begin
        yield
      ensure
        stream.reopen orig_stream # restore file descriptor
      end
      t.value # join and get the result of the thread
    end
  end

  def remove_app_extensions
    puts('Removing notifications extensions from project (needed for `pod install`)')
    @appExtensions.remove_from_project(@appExtensions.notification_content_extension_target_name)
    @appExtensions.remove_from_project(@appExtensions.notification_service_extension_target_name)
  end

  def validate(options)
    validate_distribution_certificate_password(options)
    validate_distribution_certificate_expiration(options)

    if options[:provisioning_profile_path]
      options[:provisioning_profile] = get_provisioning_profile_content(options[:provisioning_profile_path])

      validate_distribution_certificate_and_provisioning_profile(options)
      validate_provisioning_profile(options)
    end

    validate_version_number(options) if options[:version_number]
    validate_appstoreconnect_credentials(options) if options[:appstore_username]
  end

  def validate_version_number(options)
    current(__callee__.to_s)
    app_version = options[:version_number]
    error_message = "App version (#{app_version}) is not valid, version must be a period-separated list of at most three non-negative integers"
    begin
      raise error_message unless app_version.count('.') <= 2

      puts("VALID: App version '#{app_version}' is valid for AppStore submission\n".colorize(:green))
    rescue StandardError => e
      raise e.message
    end
  end

  def validate_appstoreconnect_credentials(options)
    current(__callee__.to_s)
    appstore_api_key = options[:appstore_api_key]
    appstore_api_issuer = options[:appstore_api_issuer]
    error_message = 'AppStoreConnect credentials are incorrect'
    begin
      filename = './providers.list'
      sh("xcrun altool --list-providers --apiKey '#{appstore_api_key}' --apiIssuer '#{appstore_api_issuer}' --output-format json > #{filename}")
      result = File.read(filename.to_s).strip if File.exist? filename.to_s
      File.delete(filename.to_s)
      raise error_message if result['-20101']

      puts("VALID: AppStoreConnect credentials are Ok\n".colorize(:green))
    rescue StandardError => e
      raise error_message
    end
  end

  def validate_distribution_certificate_expiration(options)
    current(__callee__.to_s)
    error_message = 'Distrubution Certificate is expired'
    begin
      p12 = OpenSSL::PKCS12.new(File.read((options[:certificate_path]).to_s), (options[:certificate_password]).to_s)
      raise error_message unless p12.certificate.not_after > Time.new

      puts("VALID: Distrubution Certificate is not expired\n".colorize(:green))
    rescue StandardError => e
      raise error_message
    end
  end

  def validate_distribution_certificate_password(options)
    current(__callee__.to_s)
    error_message = 'Incorrect password for Distrubution Certificate'
    begin
      p12 = OpenSSL::PKCS12.new(File.read((options[:certificate_path]).to_s), (options[:certificate_password]).to_s)
      raise error_message unless p12.certificate.subject

      puts("VALID: Distrubution Certificate password is Ok\n".colorize(:green))
    rescue StandardError => e
      raise error_message
    end
  end

  def validate_distribution_certificate_and_provisioning_profile(options)
    current(__callee__.to_s)
    error_message = 'Unable to fetch Team ID from distribution certificate'
    begin
      p12 = OpenSSL::PKCS12.new(File.read((options[:certificate_path]).to_s), (options[:certificate_password]).to_s)
      certificate_team_identifier = parse_certificate_subject_value(p12, 'OU')

      raise error_message if certificate_team_identifier.empty?

      provisioning_profile = options[:provisioning_profile]
      provisioning_profile_certificates = provisioning_profile['DeveloperCertificates']

      hasCertificate = false
      provisioning_profile_certificates.each do |raw|
        certificate = OpenSSL::X509::Certificate.new(raw.string)
        if certificate.public_key.to_s == p12.certificate.public_key.to_s
          hasCertificate = true
        end
      end

      error_message = 'Provisioning Profile is not signed with provided certificate'
      raise error_message unless hasCertificate == true

      puts(p12.certificate.subject)
      puts("VALID: Provisioning Profile is signed with provided certificate\n".colorize(:green))
    rescue StandardError => e
      raise error_message
    end
  end

  def parse_certificate_subject_value(certificate, key)
    content_array = certificate.certificate.subject.to_a.reject { |c| c.include?(key) == false }
    value = content_array.first.select { |c| c.to_s.length == 10 }
    value.first
  end

  def validate_provisioning_profile(options)
    validate_provisioning_profile_expiration(options)
    validate_provisioning_profile_bundle_identifier(options)
    validate_provisioning_profile_entitlements(options)
  end

  def validate_provisioning_profile_expiration(options)
    current(__callee__.to_s)
    error_message = 'Provisioning Profile is expired'
    begin
      provisioning_profile = options[:provisioning_profile]

      expire_date = provisioning_profile['ExpirationDate']
      raise error_message unless expire_date > Date.new

      puts("VALID: Provisioning Profile is not expired\n".colorize(:green))
    rescue StandardError => e
      raise error_message
    end
  end

  def validate_provisioning_profile_bundle_identifier(options)
    current(__callee__.to_s)
    error_message = 'Provisioning Profile bundle identifier does not match app required bundle identifier'
    begin
      provisioning_profile = options[:provisioning_profile]
      pp_bundle_identifier = provisioning_profile['Entitlements']['application-identifier']
      prefix = provisioning_profile['ApplicationIdentifierPrefix']
      pp_bundle_identifier["#{prefix.first}."] = ''
      unless pp_bundle_identifier == @@envHelper.bundle_identifier
        raise "#{error_message} (|#{pp_bundle_identifier}| != |#{@@envHelper.bundle_identifier}|)"
      end

      puts("VALID: Provisioning Profile bundle identifier matches app required bundle identifier\n".colorize(:green))
    rescue StandardError => e
      raise error_message
    end
  end

  def validate_provisioning_profile_entitlements(options)
    current(__callee__.to_s)
    begin
      provisioning_profile = options[:provisioning_profile]

      pp_app_groups_entitlements = provisioning_profile['Entitlements']['com.apple.security.application-groups']
      if pp_app_groups_entitlements.nil?
        error_message = 'Provisioning Profile doesn\'t support the App Groups capability'
        raise error_message
      end

      puts("VALID: Provisioning Profile has `application-groups` entitlement \n".colorize(:green))
    rescue StandardError => e
      raise e.message
    end
  end

  def upload_application(options)
    current(__callee__.to_s)

    build_type = options[:build_type]

    if @@envHelper.isTvOS
      puts('Upload application to S3')
      s3DestinationPathParams = @@envHelper.s3_upload_path(options[:bundle_identifier])
      s3DistanationPath = "#{@@envHelper.s3_bucket_name}/#{s3DestinationPathParams}"
      sh("aws --region #{@@envHelper.aws_region} s3 sync #{circle_artifacts_folder_path}/#{build_type} s3://#{s3DistanationPath} --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers --delete")
      @appCenterHelper.save_build_params_for_type(
        bundle_identifier: options[:bundle_identifier],
        zapp_build_type: options[:zapp_build_type],
        build_type: build_type,
        app_name: nil,
        app_secret: nil
      )
    else
      s3_upload(
        bundle_identifier: options[:bundle_identifier],
        ipa: "#{circle_artifacts_folder_path}/#{build_type}/#{@projectHelper.scheme}-#{build_type}.ipa",
        dsym: "#{circle_artifacts_folder_path}/#{build_type}/#{@projectHelper.scheme}-#{build_type}.app.dSYM.zip",
      )
      puts('Upload application to MS App Center')
      @appCenterHelper.upload_app(options)
    end
  end

  def team_id
    read_param_from_file("#{@@envHelper.bundle_identifier}_TEAM_ID")
  end

  def team_name
    read_param_from_file("#{@@envHelper.bundle_identifier}_TEAM_NAME")
  end

  def provisioning_profile_uuid
    read_param_from_file("#{@@envHelper.bundle_identifier}_PROFILE_UDID")
  end
end
