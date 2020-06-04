require 'fastlane/action'
require 'fastlane'
require 'colorize'

fastlane_require 'dotenv'
Dotenv.load
Fastlane.load_actions

import "Base/AppExtensions.rb"
import "Base/Helpers/S3.rb"
import "Base/Helpers/FirebaseHelper.rb"
import "Base/Helpers/ProjectHelper.rb"
import "Base/Helpers/AppCenterHelper.rb"


class BuildType < BaseHelper
  @@projectHelper = ProjectHelper.new
  @@firebaseHelper = FirebaseHelper.new
  @@appCenterHelper = AppCenterHelper.new

  @@appExtensions = AppExtensions.new

  def build_type
    # implement in child classes
  end
  
	def prepare_environment
    remove_app_extensions()
  end

  def perform_signing_validation
    # implement in child classes
  end

  def build
    # implement in child classes
  end
  
  def remove_key_from_entitlements(target, build_type, key)
    file_path = "#{@@projectHelper.path}/#{target}/Entitlements/#{target}-#{build_type}.entitlements"
  
    sh("echo $(/usr/libexec/PlistBuddy -c \"Delete :#{key}\" #{file_path} 2>/dev/null)")
  end
  
  def update_parameters_in_feature_optimization_json
    @@projectHelper.update_features_customization("S3Hostname", @@envHelper.s3_hostname)
  end
  
  def add_wifi_system_capability_if_needed()
    requires_wifi_capability = sh("echo $(/usr/libexec/PlistBuddy -c \"Print :com.apple.developer.networking.wifi-info\" #{@@projectHelper.path}/#{@@projectHelper.name}/Entitlements/#{@@projectHelper.name}-Release.entitlements 2>/dev/null | grep -c true)")
    if requires_wifi_capability.to_i() > 0
      @@projectHelper.change_system_capability(
        "com.apple.AccessWiFi",
        0,
        1
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
  
  def remove_app_extensions() 
    puts("Removing notifications extensions from project (needed for `pod install`)")
    @@appExtensions.remove_from_project(@@appExtensions.notification_content_extension_target_name)
    @@appExtensions.remove_from_project(@@appExtensions.notification_service_extension_target_name)
  end

  def validate_distribution_certificate_expiration(options)
    puts("func: validate_distribution_certificate_expiration")
    error_message = "Distrubution Certificate is expired"
    begin
      expire_date = sh("openssl pkcs12 " \
        "-in #{options[:certificate_path]} " \
        "-nokeys " \
        "-passin pass:#{options[:certificate_password]} " \
        "| openssl x509 -noout -enddate " \
        "| grep notAfter " \
        "| sed -e 's#notAfter=##'"
      )

      raise error_message unless Date.parse(expire_date) > Date.new
      puts("VALID: Distrubution Certificate is not expired\n".colorize(:green))
    rescue => ex
      raise error_message
    end
  end

  def validate_distribution_certificate_password(options)
    puts("func: validate_distribution_certificate_password")
    error_message = "Incorrect password for Distrubution Certificate"
    begin
      result = sh("openssl pkcs12 " \
        "-in #{options[:certificate_path]} " \
        "-nokeys " \
        "-passin pass:#{options[:certificate_password]} " \
        "| grep -c 'BEGIN CERTIFICATE'"
      )
      raise error_message unless result.lines.last.to_i() > 0
      puts("VALID: Distrubution Certificate password is Ok\n".colorize(:green))
    rescue => ex
      raise error_message
    end  
  end


  def validate_distribution_certificate_and_provisioning_profile_team_id(options)
    puts("func: validate_distribution_certificate_and_provisioning_profile_team_id")
    error_message = "Unable to fetch Team ID from distribution certificate"
    begin
      result = sh("openssl pkcs12 " \
        "-in #{options[:certificate_path]} " \
        "-nokeys " \
        "-passin pass:#{options[:certificate_password]} " \
        "| openssl x509 -noout -subject " \
        "| awk -F'[=,/]' '{print $3}'``"

      )
      raise error_message unless result.length > 0

      # get provisioning profile team identifier
      provisioning_profile_team_identifier = sh("echo $(/usr/libexec/PlistBuddy -c 'Print :TeamIdentifier' /dev/stdin <<< $(security cms -D -i \"#{options[:provisioning_profile_path]}\") | sed -e 1d -e '$d')")

      # remove white spaces 
      provisioning_profile_team_identifier = provisioning_profile_team_identifier.chomp.strip
      distribution_certificate_team_identifier = result.chomp.strip

      # raise exc if no match
      error_message = "Provisioning Profile is not signed with provided Distribution Certificate"
      raise "#{error_message} (#{distribution_certificate_team_identifier} != #{provisioning_profile_team_identifier})" unless distribution_certificate_team_identifier == provisioning_profile_team_identifier
      puts("VALID: Provisioning Profile is signed with provided Distribution Certificate\n".colorize(:green))

    rescue => ex
      raise ex.message
    end 
  end

  def validate_provisioning_profile(options)
    error_message = "Provisioning Profile is expired"
    begin
		  expire_date = sh("echo $(/usr/libexec/PlistBuddy -c 'Print :ExpirationDate' /dev/stdin <<< $(security cms -D -i \"#{options[:provisioning_profile_path]}\"))")
      raise error_message unless Date.parse(expire_date) > Date.new
      puts("VALID: Provisioning Profile is not expired\n".colorize(:green))
    rescue => ex
      raise ex.message
    end 
  end

end