import "Base/AppCenter.rb"
import "Base/AppExtensions.rb"
import "Base/Firebase.rb"
import "Base/S3.rb"
import "Base/InfoPlist.rb"
import "Base/Project.rb"

require 'dotenv'
Dotenv.load

def create_temp_keychain()
  create_keychain(
    name: keychain_name,
    password: keychain_password,
    unlock: true,
    timeout: 3600,
    lock_when_sleeps: true
  )
end

def remove_key_from_entitlements(target, build_type, key)
  file_path = "#{project_path}/#{target}/Entitlements/#{target}-#{build_type}.entitlements"

  sh("echo $(/usr/libexec/PlistBuddy -c \"Delete :#{key}\" #{file_path} 2>/dev/null)")
end

def update_features_customization(param_name, param_value)
  sh("/usr/libexec/PlistBuddy -c \"Set #{param_name} #{param_value}\" #{customizations_folder_path}/FeaturesCustomization.plist")
  puts "#{param_name} value was updated successfully in FeaturesCustomization.plist"

end

def update_parameters_in_feature_optimization_json
  update_features_customization("S3Hostname", s3_hostname)
end

def add_wifi_system_capability_if_needed()
  requires_wifi_capability = sh("echo $(/usr/libexec/PlistBuddy -c \"Print :com.apple.developer.networking.wifi-info\" #{project_path}/#{project_name}/Entitlements/#{project_name}-Release.entitlements 2>/dev/null | grep -c true)")
  if requires_wifi_capability.to_i() > 0
    project_change_system_capability(
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

def base_set_device_family()
  puts("Setting device family param")

  device_family = ENV["device_target"]
      ENV["DEVICE_FAMILY"] = "1,2"
  if device_family == "iphone"
      ENV["DEVICE_FAMILY"] = "1"
  end
  if device_family == "ipad"
      ENV["DEVICE_FAMILY"] = "2"
  end
end

def base_install_awscli_if_needed()
  puts("Installing S3 AWS if needed")

  unless ENV['bundle_identifier'].to_s.strip.empty?          
    if isTvOS
        puts("Installing S3 AWS")
        sh("sudo pip install awscli")
    end
  end
end

def base_remove_app_extensions() 
  puts("Removing notifications extensions from project (needed for `pod install`")
  app_extensions_remove_from_project(notification_content_extension_target_name)
  app_extensions_remove_from_project(notification_service_extension_target_name)
end