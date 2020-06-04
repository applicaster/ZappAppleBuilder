require 'fastlane/action'
require 'fastlane'

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
end