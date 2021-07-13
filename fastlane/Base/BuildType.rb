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
  attr_accessor :project_helper, :firebase_helper, :app_center_helper, :app_extensions_helper

  def initialize(options = {})
    super
    @project_helper = ProjectHelper.new(fastlane: @fastlane)
    @firebase_helper = FirebaseHelper.new(fastlane: @fastlane, project_helper: @project_helper)
    @app_center_helper = AppCenterHelper.new(fastlane: @fastlane, project_helper: @project_helper)
    @app_extensions_helper = AppExtensions.new(fastlane: @fastlane, project_helper: @project_helper)
  end

  def build_type
    # implement in child classes
  end

  def prepare_environment
    @app_extensions_helper.remove_app_extensions_targets_from_project(
      project_path: @project_helper.xcodeproj_path.to_s,
      project_scheme: @project_helper.scheme
    )
    fetch_app_center_identifiers
    @project_helper.organize_resources_to_assets_catalog
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
    @app_center_helper.fetch_identifiers(@@env_helper.bundle_identifier.to_s)
  end

  def remove_key_from_entitlements(target, build_type, key)
    file_path = "#{@project_helper.path}/#{target}/Entitlements/#{target}-#{build_type}.entitlements"

    sh("echo $(/usr/libexec/PlistBuddy -c \"Delete :#{key}\" #{file_path} 2>/dev/null)")
  end

  def update_parameters_in_feature_optimization_json
    @project_helper.update_features_customization(
      name: 'S3Hostname',
      value: @@env_helper.s3_hostname
    )

    debug_environment = 'YES'
    debug_environment = 'NO' if (build_type == 'enterprise') || (build_type == 'store')

    @project_helper.update_features_customization(
      name: 'DebugEnvironment',
      value: debug_environment
    )
  end

  def add_wifi_system_capability_if_needed
    requires_wifi_capability = sh("echo $(/usr/libexec/PlistBuddy -c \"Print :com.apple.developer.networking.wifi-info\" #{@project_helper.path}/#{@project_helper.name}/Entitlements/#{@project_helper.name}-Release.entitlements 2>/dev/null | grep -c true)")
    if requires_wifi_capability.to_i > 0
      @project_helper.change_system_capability(
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

  def validate(options)

    certificate = load_certificate(options)
    validate_distribution_certificate_password(certificate)
    validate_distribution_certificate_expiration(certificate)
    validate_distribution_certificate_wwdr(certificate)

    if options[:provisioning_profile_path]
      profile = get_provisioning_profile_content(options[:provisioning_profile_path])
      validate_distribution_certificate_and_provisioning_profile(profile, certificate)
      validate_provisioning_profile(profile)
    end

    validate_app_version(options)
  end

  def add_appstoreconnect_api_key(options)
    current(__callee__.to_s)
    appstore_api_key_id = options[:appstore_api_key_id]
    appstore_api_issuer_id = options[:appstore_api_issuer_id]
    appstore_api_key_folder = options[:appstore_api_key_folder]
    file_path = "#{appstore_api_key_folder}/AuthKey_#{appstore_api_key_id}.p8"
    key_content = File.binread(file_path.to_s)
    @fastlane.app_store_connect_api_key(
      key_id: appstore_api_key_id,
      issuer_id: appstore_api_issuer_id,
      key_content: key_content,
      duration: 1200, # optional
      in_house: false # optional but may be required if using match/sigh
    )
  end

  def get_appstoreconnect_latest_version(_options)
    @fastlane.get_latest_app_version_info(
      app_identifier: @@env_helper.bundle_identifier,
      platform: @@env_helper.platform_name
    )
  end

  def validate_app_version(options)
    app_version = options[:version_number]

    validate_version_number_up_to_three_integers(options) if app_version

    if options[:appstore_api_key_id]
      add_appstoreconnect_api_key(options)

      latest_app_version_info = get_appstoreconnect_latest_version(options)

      validate_appstoreconnect_latest_version_not_pending_release(latest_app_version_info)

      pp("Latest app info:")
      pp(latest_app_version_info)

      if app_version && latest_app_version_info.app_store_state == 'READY_FOR_SALE'
        validate_version_number_higher_than_released_version(latest_app_version_info, app_version) 
      end
    end
  end

  def validate_version_number_up_to_three_integers(options)
    current(__callee__.to_s)
    app_version = options[:version_number]
    error_message = "App version (#{app_version}) is not valid, version must be a period-separated list of at most three non-negative integers"
    begin
      raise error_message unless app_version.count('.') <= 2

      puts("VALID: App version '#{app_version}' is valid for AppStore submission\n".colorize(:green))
    rescue StandardError => e
      validation_error_log(e)
      raise e.message
    end
  end

  def validate_appstoreconnect_latest_version_not_pending_release(latest_app_version_info)
    current(__callee__.to_s)

    error_message = "App version `#{latest_app_version_info.version_string}` for platform `#{@@env_helper.platform_name}` is available in AppStoreConnect with `PENDING DEVELOPER RELEASE` state. Can not create a new version unless this version is released or rejected"
    begin
      raise error_message unless latest_app_version_info.app_store_state != 'PENDING_DEVELOPER_RELEASE'

      puts('VALID: New app version can be uploaded to the AppStoreConnect'.colorize(:green))
    rescue StandardError => e
      validation_error_log(e)
      raise e.message
    end
  end

  def validate_version_number_higher_than_released_version(latest_app_version_info, app_version)
    current(__callee__.to_s)
    error_message = "App version `#{app_version}` should be higher than previously approved version `#{latest_app_version_info.version_string}`"
    begin
      unless Gem::Version.new(app_version) > Gem::Version.new(latest_app_version_info.version_string)
        raise error_message
      end

      puts("VALID: New app version `#{app_version}` is higher than the latest approved/released version `#{latest_app_version_info.version_string}`".colorize(:green))
    rescue StandardError => e
      validation_error_log(e)
      raise e.message
    end
  end

  def validate_appstoreconnect_credentials(options)
    current(__callee__.to_s)
    appstore_api_key_id = options[:appstore_api_key_id]
    appstore_api_issuer_id = options[:appstore_api_issuer_id]
    error_message = 'Failed to validate AppStoreConnect credentials'
    Dir.chdir(@@env_helper.root_path.to_s) do
      filename = './providers_list.json'
      begin
        cmd = "xcrun altool --list-providers --apiKey \"#{appstore_api_key_id}\" --apiIssuer \"#{appstore_api_issuer_id}\" --output-format json > #{filename}"
        system(cmd.to_s)
        result = File.read(filename.to_s).strip if File.exist? filename.to_s
        raise error_message unless result['WWDRTeamID']

        puts("VALID: AppStoreConnect credentials are Ok\n".colorize(:green))
      rescue StandardError => e
        validation_error_log(e)
        raise "#{error_message} \n\n #{sh("cat #{filename} | jq .")}"
      end
    end
  end

  def validate_distribution_certificate_expiration(certificate)
    current(__callee__.to_s)
    error_message = 'Distrubution Certificate is expired'
    begin
      raise error_message unless certificate.certificate.not_after > Time.new

      puts("VALID: Distrubution Certificate is not expired\n".colorize(:green))
    rescue StandardError => e
      validation_error_log(e)
      raise error_message
    end
  end

  def validate_distribution_certificate_password(certificate)
    current(__callee__.to_s)
    error_message = 'Incorrect password for Distrubution Certificate'
    begin
      raise error_message unless certificate.certificate.subject

      puts("VALID: Distrubution Certificate password is Ok\n".colorize(:green))
    rescue StandardError => e
      validation_error_log(e)
      raise error_message
    end
  end

  def validate_distribution_certificate_wwdr(certificate)
    current(__callee__.to_s)
    error_message = 'Certificate was created with older or not valid WWDR intermediate certificate. Please revoke and create new p12 using Apple Developer Portal or Xcode'
    begin
      puts(certificate.certificate.subject)
      puts(certificate.certificate.issuer)
      certificate_issuer_unit = parse_certificate_issuer_value(certificate, 'OU', 'G3')
      raise error_message if certificate_issuer_unit.empty?

      puts("VALID: Certificate was creates with valid WWDR\n".colorize(:green))
    rescue StandardError => e
      validation_error_log(e)
      raise error_message
    end
  end

  def validate_distribution_certificate_and_provisioning_profile(profile, certificate)
    current(__callee__.to_s)
    error_message = 'Unable to fetch Team ID from distribution certificate'
    begin
      certificate_team_identifier = parse_certificate_subject_value(certificate, 'OU')
      raise error_message if certificate_team_identifier.empty?

      provisioning_profile_certificates = profile['DeveloperCertificates']

      hasCertificate = false
      puts("Provided distibution certificate: #{certificate.certificate.subject}".colorize(:yellow))

      provisioning_profile_certificates.each do |raw|
        pp_cert = OpenSSL::X509::Certificate.new(raw.string)
        puts("Provisioning Profile signed certificate: #{pp_cert.subject}".colorize(:yellow))
        hasCertificate = true if pp_cert.to_der == certificate.certificate.to_der
      end

      error_message = 'Provisioning Profile is not signed with provided certificate'
      raise error_message unless hasCertificate == true

      puts("VALID: Provisioning Profile is signed with provided certificate\n".colorize(:green))
    rescue StandardError => e
      validation_error_log(e)
      raise error_message
    end
  end

  def load_certificate(options)
    OpenSSL::PKCS12.new(File.read((options[:certificate_path]).to_s), (options[:certificate_password]).to_s)
  end 

  def parse_certificate_subject_value(certificate, key)
    content_array = certificate.certificate.subject.to_a.reject { |c| c.include?(key) == false }
    value = content_array.first.select { |c| c.to_s.length == 10 }
    value.first
  end

  def parse_certificate_issuer_value(certificate, key, value)
    content_array = certificate.certificate.issuer.to_a.reject { |c| c.include?(key) == false }
    value = content_array.first.select { |c| c.to_s == value }
    value.first
  end

  def validate_provisioning_profile(profile)
    validate_provisioning_profile_expiration(profile)
    validate_provisioning_profile_bundle_identifier(profile)
    validate_provisioning_profile_entitlements(profile)
  end

  def validate_provisioning_profile_expiration(profile)
    current(__callee__.to_s)
    error_message = 'Provisioning Profile is expired'
    begin
      expire_date = profile['ExpirationDate']
      raise error_message unless expire_date > Date.new

      puts("VALID: Provisioning Profile is not expired\n".colorize(:green))
    rescue StandardError => e
      validation_error_log(e)
      raise error_message
    end
  end

  def validate_provisioning_profile_bundle_identifier(profile)
    current(__callee__.to_s)
    error_message = 'Provisioning Profile bundle identifier does not match app required bundle identifier'
    begin
      pp_bundle_identifier = profile['Entitlements']['application-identifier']
      prefix = profile['ApplicationIdentifierPrefix']
      pp_bundle_identifier["#{prefix.first}."] = ''
      unless pp_bundle_identifier == @@env_helper.bundle_identifier
        raise "#{error_message} (|#{pp_bundle_identifier}| != |#{@@env_helper.bundle_identifier}|)"
      end

      puts("VALID: Provisioning Profile bundle identifier matches app required bundle identifier\n".colorize(:green))
    rescue StandardError => e
      validation_error_log(e)
      raise error_message
    end
  end

  def validate_provisioning_profile_entitlements(profile)
    current(__callee__.to_s)
    begin
      pp_app_groups_entitlements = profile['Entitlements']['com.apple.security.application-groups']
      if pp_app_groups_entitlements.nil?
        error_message = 'Provisioning Profile doesn\'t support the App Groups capability'
        raise error_message
      end

      puts("VALID: Provisioning Profile has `application-groups` entitlement \n".colorize(:green))
    rescue StandardError => e
      validation_error_log(e)
      raise e.message
    end
  end

  def validation_error_log(e)
    sh("echo #{e.message} > ./validation_error.log")
  end

  def upload_application(options)
    current(__callee__.to_s)

    build_type = options[:build_type]
    bundle_identifier = options[:bundle_identifier]
    zapp_build_type = options[:zapp_build_type]

    if @@env_helper.is_tvos
      puts('Upload application to S3')
      s3DestinationPathParams = @@env_helper.s3_upload_path(bundle_identifier)
      s3DistanationPath = "#{@@env_helper.s3_bucket_name}/#{s3DestinationPathParams}"
      sh("aws --region #{@@env_helper.aws_region} s3 sync #{circle_artifacts_folder_path}/#{build_type} s3://#{s3DistanationPath} --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers --delete")
    else
      s3_upload(
        bundle_identifier: bundle_identifier,
        ipa: "#{circle_artifacts_folder_path}/#{build_type}/#{@project_helper.scheme}-#{build_type}.ipa",
        dsym: "#{circle_artifacts_folder_path}/#{build_type}/#{@project_helper.scheme}-#{build_type}.app.dSYM.zip"
      )
    end

    save_build_params_for_type(
      bundle_identifier: bundle_identifier,
      project_scheme: @project_helper.scheme,
      zapp_build_type: zapp_build_type,
      build_type: build_type,
      app_name: nil,
      app_secret: nil
    )
  end

  def team_id
    read_param_from_file("#{@@env_helper.bundle_identifier}_TEAM_ID")
  end

  def team_name
    read_param_from_file("#{@@env_helper.bundle_identifier}_TEAM_NAME")
  end

  def provisioning_profile_uuid
    read_param_from_file("#{@@env_helper.bundle_identifier}_PROFILE_UDID")
  end
end
