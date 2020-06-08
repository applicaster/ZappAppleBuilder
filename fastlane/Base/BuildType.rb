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
  @@projectHelper = ProjectHelper.new
  @@firebaseHelper = FirebaseHelper.new
  @@appCenterHelper = AppCenterHelper.new

  @@appExtensions = AppExtensions.new

  def build_type
    # implement in child classes
  end

  def prepare_environment
    remove_app_extensions
    fetch_app_center_identifiers
  end

  def perform_signing_validation
    # implement in child classes
  end

  def build
    # implement in child classes
  end

  def fetch_app_center_identifiers
    @@appCenterHelper.fetch_identifiers(@@envHelper.bundle_identifier.to_s)
  end

  def remove_key_from_entitlements(target, build_type, key)
    file_path = "#{@@projectHelper.path}/#{target}/Entitlements/#{target}-#{build_type}.entitlements"

    sh("echo $(/usr/libexec/PlistBuddy -c \"Delete :#{key}\" #{file_path} 2>/dev/null)")
  end

  def update_parameters_in_feature_optimization_json
    @@projectHelper.update_features_customization(
      name: 'S3Hostname',
      value: @@envHelper.s3_hostname
    )
  end

  def add_wifi_system_capability_if_needed
    requires_wifi_capability = sh("echo $(/usr/libexec/PlistBuddy -c \"Print :com.apple.developer.networking.wifi-info\" #{@@projectHelper.path}/#{@@projectHelper.name}/Entitlements/#{@@projectHelper.name}-Release.entitlements 2>/dev/null | grep -c true)")
    if requires_wifi_capability.to_i > 0
      @@projectHelper.change_system_capability(
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
    @@appExtensions.remove_from_project(@@appExtensions.notification_content_extension_target_name)
    @@appExtensions.remove_from_project(@@appExtensions.notification_service_extension_target_name)
  end

  def validate(options)
    validate_distribution_certificate_password(options)
    validate_distribution_certificate_expiration(options)

    if options[:provisioning_profile_path] 
      validate_distribution_certificate_and_provisioning_profile_team_id(options)
      validate_provisioning_profile(options)
    end

    if options[:version_number]
      validate_version_number(options)
    end
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

  def validate_distribution_certificate_expiration(options)
    current(__callee__.to_s)
    error_message = 'Distrubution Certificate is expired'
    begin
      expire_date = sh('openssl pkcs12 ' \
        "-in #{options[:certificate_path]} " \
        '-nokeys ' \
        "-passin pass:#{options[:certificate_password]} " \
        '| openssl x509 -noout -enddate ' \
        '| grep notAfter ' \
        "| sed -e 's#notAfter=##'")

      raise error_message unless Date.parse(expire_date) > Date.new

      puts("VALID: Distrubution Certificate is not expired\n".colorize(:green))
    rescue StandardError => e
      raise e.message
    end
  end

  def validate_distribution_certificate_password(options)
    current(__callee__.to_s)
    error_message = 'Incorrect password for Distrubution Certificate'
    begin
      result = sh('openssl pkcs12 ' \
        "-in #{options[:certificate_path]} " \
        '-nokeys ' \
        "-passin pass:#{options[:certificate_password]} " \
        "| grep -c 'BEGIN CERTIFICATE'")
      raise error_message unless result.lines.last.to_i > 0

      puts("VALID: Distrubution Certificate password is Ok\n".colorize(:green))
    rescue StandardError => e
      raise e.message
    end
  end

  def validate_distribution_certificate_and_provisioning_profile_team_id(options)
    current(__callee__.to_s)
    error_message = 'Unable to fetch Team ID from distribution certificate'
    begin
      result = sh('openssl pkcs12 ' \
        "-in #{options[:certificate_path]} " \
        '-nokeys ' \
        "-passin pass:#{options[:certificate_password]} " \
        '| openssl x509 -noout -subject ')

      delimiters = ['verified', '\\n', 'subject', 'UID', '=', ' ', ',', '/']
      array = result.split(Regexp.union(delimiters)).reject { |c| c.length < 10 }
      certificate_identifier = array.first
      raise error_message if certificate_identifier.empty?

      # get provisioning profile team identifier
      provisioning_profile_team_identifier = sh("echo $(/usr/libexec/PlistBuddy -c 'Print :TeamIdentifier' /dev/stdin <<< $(security cms -D -i \"#{options[:provisioning_profile_path]}\") | sed -e 1d -e '$d')")

      # remove white spaces
      provisioning_profile_team_identifier = provisioning_profile_team_identifier.chomp.strip
      distribution_certificate_team_identifier = certificate_identifier.chomp.strip

      # raise exc if no match
      error_message = 'Provisioning Profile is not signed with provided Distribution Certificate'
      unless distribution_certificate_team_identifier == provisioning_profile_team_identifier
        raise "#{error_message} (|#{distribution_certificate_team_identifier}| != |#{provisioning_profile_team_identifier}|)"
      end

      puts("VALID: Provisioning Profile is signed with provided Distribution Certificate\n".colorize(:green))
    rescue StandardError => e
      raise e.message
    end
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
      expire_date = sh("echo $(/usr/libexec/PlistBuddy -c 'Print :ExpirationDate' /dev/stdin <<< $(security cms -D -i \"#{options[:provisioning_profile_path]}\"))")
      raise error_message unless Date.parse(expire_date) > Date.new

      puts("VALID: Provisioning Profile is not expired\n".colorize(:green))
    rescue StandardError => e
      raise e.message
    end
  end

  def validate_provisioning_profile_bundle_identifier(options)
    current(__callee__.to_s)
    error_message = 'Provisioning Profile bundle identifier does not match app required bundle identifier'
    begin
      pp_bundle_identifier = sh("echo $(/usr/libexec/PlistBuddy -c 'Print :Entitlements:application-identifier' /dev/stdin <<< $(security cms -D -i \"#{options[:provisioning_profile_path]}\")) | tr -d '\040\011\012\015'")
      prefix = sh("echo $(/usr/libexec/PlistBuddy -c 'Print :ApplicationIdentifierPrefix' /dev/stdin <<< $(security cms -D -i \"#{options[:provisioning_profile_path]}\")) | tr -d '\040\011\012\015'")
      prefix['Array{'] = ''
      prefix['}'] = ''
      pp_bundle_identifier["#{prefix}."] = ''
      unless pp_bundle_identifier == @@envHelper.bundle_identifier
        raise "#{error_message} (|#{pp_bundle_identifier}| != |#{@@envHelper.bundle_identifier}|)"
      end

      puts("VALID: Provisioning Profile bundle identifier matches app required bundle identifier\n".colorize(:green))
    rescue StandardError => e
      raise e.message
    end
  end

  def validate_provisioning_profile_entitlements(options)
    current(__callee__.to_s)
    begin
      pp_app_groups_entitlements = sh("echo $(/usr/libexec/PlistBuddy -c 'Print :Entitlements:com.apple.security.application-groups' /dev/stdin <<< $(security cms -D -i \"#{options[:provisioning_profile_path]}\")) | tr -d '\040\011\012\015'")
      if pp_app_groups_entitlements["Does Not Exist"]
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
    if @@envHelper.isTvOS
      puts('Upload application to S3')
      s3DestinationPathParams = s3_upload_path(options[:bundle_identifier])
      s3DistanationPath = "#{s3BucketName}/#{s3DestinationPathParams}"
      sh("aws --region #{awsRegion} s3 sync ../CircleArtifacts/#{options[:distribute_type]} s3://#{s3DistanationPath} --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers --delete")
      @@appCenterHelper.save_build_params_for_type(
        bundle_identifier: options[:bundle_identifier],
        zapp_build_type: options[:zapp_build_type],
        app_name: nil,
        app_secret: nil
      )
    else
      puts('Upload application to MS App Center')
      @@appCenterHelper.upload_app(options)
    end
  end
end
