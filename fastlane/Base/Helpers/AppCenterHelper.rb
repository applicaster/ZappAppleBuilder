import "Base/Helpers/ProjectHelper.rb"
import "Base/Helpers/BaseHelper.rb"

class AppCenterHelper < BaseHelper
  @@projectHelper = ProjectHelper.new

  def fetch_identifiers(bundle_identifier)
    puts("Fetching App Center identifiers ms_app_center:fetch_identifiers[#{bundle_identifier}")
    sh("bundle exec rake ms_app_center:fetch_identifiers[#{bundle_identifier}]")
  end

  def read_value_from_file(bundle_identifier, type)
    folder_name = ".ms_app_center"
    filename = "#{@@envHelper.root_path}/#{folder_name}/#{bundle_identifier}_#{type}"
    if File.exist? "#{filename}"
       File.read("#{filename}").strip
    end
  end

  def upload_app(bundle_identifier, build_type, zapp_build_type)
    app_display_name = app_name
    app_name = read_value_from_file(bundle_identifier, "appname")
    app_secret = read_value_from_file(bundle_identifier, "appsecret")
    app_distribution_group = read_value_from_file(bundle_identifier, "appgroup")
    app_platform = "Objective-C-Swift"
    app_os = appCenterDeviceIdentifier

    puts("#{ENV['APPCENTER_API_TOKEN']}
      #{ENV['APPCENTER_OWNER_NAME']}
      #{app_distribution_group}
      #{app_os}
      #{app_platform}
      #{app_display_name}
      #{circle_artifacts_folder_path}/#{build_type}/#{@@projectHelper.scheme}-#{build_type}.ipa
       #{circle_artifacts_folder_path}/#{build_type}/#{@@projectHelper.scheme}-#{build_type}.app.dSYM.zip"
       )
    appcenter_upload(
      api_token: "#{ENV['APPCENTER_API_TOKEN']}",
      owner_name: "#{ENV['APPCENTER_OWNER_NAME']}",
      destinations: "#{app_distribution_group}",
      destination_type: "group",
      app_os: "#{app_os}",
      app_platform: "#{app_platform}",
      app_display_name: "#{app_display_name}",
      app_name: "#{app_name}",
      ipa: "#{circle_artifacts_folder_path}/#{build_type}/#{@@projectHelper.scheme}-#{build_type}.ipa",
      dsym: "#{circle_artifacts_folder_path}/#{build_type}/#{@@projectHelper.scheme}-#{build_type}.app.dSYM.zip",
      notify_testers: false # Set to false if you don't want to notify testers of your new release (default: `false`)
    )

    # save uploaded app info to file for future use
    save_build_params_for_type(bundle_identifier, build_type, app_name, app_secret)
  end

  def update_app_secret(bundle_identifier)
    app_secret = read_value_from_file(bundle_identifier, "appsecret")

    @@projectHelper.update_features_customization("MSAppCenterAppSecret", app_secret)

    # add appcenter url scheme to the app
    update_url_schemes(
      plist_path: "#{@@projectHelper.plist_path}",
      scheme: "appcenter-#{app_secret}"
    )
    puts "MS App Center app secret #{app_secret} was updated successfully for bundle identifier: #{bundle_identifier}"
  end

  def save_build_params_for_type(bundle_identifier, build_type, app_name, app_secret)
    folder_name = "#{@@envHelper.root_path}/.ms_app_center"
    filename = "#{folder_name}/#{build_type}_upload_params.json"
    hash = build_params_hash_for_type(bundle_identifier, build_type, app_name, app_secret)
    Dir.mkdir(folder_name) unless File.exists?(folder_name)
    File.open(filename,"w") do |f|
       f.write(hash.to_json)
    end
  end

  def  build_params_hash_for_type(bundle_identifier, build_type, app_name, app_secret)
    if @@envHelper.isTvOS
      time = Time.new
      s3DestinationPathParams = s3_upload_path(bundle_identifier)
      s3DistanationPath = "https://assets-secure.applicaster.com/#{s3DestinationPathParams}/#{@@projectHelper.scheme}-#{build_type}.ipa"
      {
        uploaded_at: time.inspect,
        download_url: s3DistanationPath,
      }
    else
      release_info = lane_context[SharedValues::APPCENTER_BUILD_INFORMATION]
      {
        uploaded_at: release_info["uploaded_at"],
        download_url: release_info["download_url"],
        install_url: release_info["install_url"],
        id: release_info["id"],
        app_name: app_name,
        app_secret: app_secret
      }
    end
  end
end

