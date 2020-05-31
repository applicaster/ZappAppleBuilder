
 def ms_app_center_read_value_from_file(bundle_identifier, type)
    folder_name = ".ms_app_center"
    filename = "#{ENV['PWD']}/#{folder_name}/#{bundle_identifier}_#{type}"
    if File.exist? "#{filename}"
       File.read("#{filename}").strip
    end
  end

  def ms_app_center_upload_app(bundle_identifier, build_type, zapp_build_type)
    ms_app_center_app_display_name = app_name
    ms_app_center_app_name = ms_app_center_read_value_from_file(bundle_identifier, "appname")
    ms_app_center_app_secret = ms_app_center_read_value_from_file(bundle_identifier, "appsecret")
    ms_app_center_app_distribution_group = ms_app_center_read_value_from_file(bundle_identifier, "appgroup")
    ms_app_center_app_platform = "Objective-C-Swift"
    ms_app_center_app_os = appCenterDeviceIdentifier

    puts("#{ENV['APPCENTER_API_TOKEN']}
      #{ENV['APPCENTER_OWNER_NAME']}
      #{ms_app_center_app_distribution_group}
      #{ms_app_center_app_os}
      #{ms_app_center_app_platform}
      #{ms_app_center_app_display_name}
      #{circle_artifacts_folder_path}/#{build_type}/#{project_scheme}-#{build_type}.ipa
       #{circle_artifacts_folder_path}/#{build_type}/#{project_scheme}-#{build_type}.app.dSYM.zip"
       )
    appcenter_upload(
      api_token: "#{ENV['APPCENTER_API_TOKEN']}",
      owner_name: "#{ENV['APPCENTER_OWNER_NAME']}",
      destinations: "#{ms_app_center_app_distribution_group}",
      destination_type: "group",
      app_os: "#{ms_app_center_app_os}",
      app_platform: "#{ms_app_center_app_platform}",
      app_display_name: "#{ms_app_center_app_display_name}",
      app_name: "#{ms_app_center_app_name}",
      ipa: "#{circle_artifacts_folder_path}/#{build_type}/#{project_scheme}-#{build_type}.ipa",
      dsym: "#{circle_artifacts_folder_path}/#{build_type}/#{project_scheme}-#{build_type}.app.dSYM.zip",
      notify_testers: false # Set to false if you don't want to notify testers of your new release (default: `false`)
    )

    # save uploaded app info to file for future use
    ms_app_center_save_build_params_for_type(bundle_identifier, build_type, ms_app_center_app_name, ms_app_center_app_secret)
  end

  def ms_app_center_update_app_secret(bundle_identifier)
    ms_app_center_app_secret = ms_app_center_read_value_from_file(bundle_identifier, "appsecret")

    update_features_customization("MSAppCenterAppSecret", ms_app_center_app_secret)

    # add appcenter url scheme to the app
    update_url_schemes(
      path: "#{project_info_plist_path}",
      update_url_schemes: proc do |schemes|
        schemes + ["appcenter-#{ms_app_center_app_secret}"]
      end
    )
    puts "MS App Center app secret #{ms_app_center_app_secret} was updated successfully for bundle identifier: #{bundle_identifier}"
  end

  def ms_app_center_save_build_params_for_type(bundle_identifier, build_type, app_name, app_secret)
    folder_name = "#{ENV['PWD']}/.ms_app_center"
    filename = "#{folder_name}/#{build_type}_upload_params.json"
    hash = ms_app_center_build_params_hash_for_type(bundle_identifier, build_type, app_name, app_secret)
    Dir.mkdir(folder_name) unless File.exists?(folder_name)
    File.open(filename,"w") do |f|
       f.write(hash.to_json)
    end
  end

  def  ms_app_center_build_params_hash_for_type(bundle_identifier, build_type, app_name, app_secret)
    if isTvOS
      time = Time.new
      s3DestinationPathParams = s3_upload_path(bundle_identifier)
      s3DistanationPath = "https://assets-secure.applicaster.com/#{s3DestinationPathParams}/#{project_scheme}-#{build_type}.ipa"
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