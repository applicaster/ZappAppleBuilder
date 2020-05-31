
def base_ent_prepare_enterprise_debug_app_signing(username, password, fastlane_password, certificate_path)
  create_temp_keychain()
  import_certificate(
    certificate_path: certificate_path,
    certificate_password: ENV['KEY_PASSWORD'],
    keychain_name: keychain_name,
    keychain_password: keychain_password
  )
  sh("bundle exec fastlane fastlane-credentials add --username #{username} --password '#{password}'")
  ENV['FASTLANE_PASSWORD']=fastlane_password
end

def base_ent_perform_post_build_procedures()
  # delete temp keychain
  delete_keychain(name: keychain_name)

  copy_artifacts(
    target_path: "CircleArtifacts/Enterprise",
    artifacts: [
     "~/Library/Logs/gym/#{project_scheme}-#{project_scheme}.log"
    ]
  )
end

def base_ent_create_app_on_dev_portal(username, team_id, app_name, app_bundle, app_index)
  # create app on developer portal with new identifier for notification extension
  produce(
    username: "#{username}",
    app_identifier: "#{app_bundle}",
    team_id: "#{team_id}",
    app_name: "#{app_name}",
    language: "English",
    app_version: "1.0",
    sku: "#{app_bundle}.#{app_index}",
    skip_itc: true,
    enable_services: {
      app_group: "on",
      associated_domains: "on",
      data_protection: "complete",
      in_app_purchase: "on",
      push_notification: "on",
      access_wifi: "on"
    }
  )

end

def base_ent_create_provisioning_profile(username, team_id, team_name, app_bundle)
  # create download and install new provisioning profile for the app
  sigh(
    username: "#{username}",
    app_identifier: "#{app_bundle}",
    team_id: "#{team_id}",
    provisioning_name: "#{app_bundle} prov profile",
    cert_owner_name: "#{team_name}",
    filename: "#{app_bundle}.mobileprovision",
    platform: platform_name
  )

  ENV["#{app_bundle}_PROFILE_UDID"] = lane_context[SharedValues::SIGH_UDID]

  # delete Invalid provisioning profiles for the same app
  base_ent_delete_invalid_provisioning_profiles(username, team_id, app_bundle)
end

def base_ent_delete_invalid_provisioning_profiles(username, team_id, app_bundle)
  password = ENV['FASTLANE_PASSWORD']
  Spaceship::Portal.login(username, password)
  Spaceship::Portal.client.team_id = team_id

  profiles = Spaceship::Portal::ProvisioningProfile.all.find_all do |profile|
    (profile.status == "Invalid" or profile.status == "Expired") && profile.app.bundle_id == app_bundle
  end

  profiles.each do |profile|
    sh("echo 'Deleting #{profile.name}, status: #{profile.status}'")
    profile.delete!
  end
end

def base_ent_create_push_certificate(username, team_id, team_name, app_bundle, p12_password)
  get_push_certificate(
    username: "#{username}",
    team_id: "#{team_id}",
    team_name: "#{team_name}",
    app_identifier: "#{app_bundle}",
    generate_p12: true,
    p12_password: "#{p12_password}",
    pem_name: "apns",
    save_private_key: false,
    output_path: "./CircleArtifacts"
  )

  command = "bundle exec "\
  "rake upload_enterprise_push:upload_certificate["\
  "#{ENV['accounts_account_id']},"\
  "#{ENV['bundle_identifier']},"\
  "#{circle_artifacts_folder_path},"\
  "apns.p12]"

  sh("#{command}")
end

def base_ent_update_group_identifiers(target, build_type, groups)
  file_path = "#{project_path}/#{target}/Entitlements/#{target}-#{build_type}.entitlements"

  update_app_group_identifiers(
    entitlements_file: "#{file_path}",
    app_group_identifiers: groups
  )
end

def base_ent_prepare_enterprise_app_for_build
    #delete spotlight subscription entitlements if exists
    remove_key_from_entitlements("#{project_name}", "Release", "com.apple.smoot.subscriptionservice")
    #delete sso entitlements if exists
    remove_key_from_entitlements("#{project_name}", "Release", "com.apple.developer.video-subscriber-single-sign-on")
end

def base_ent_enterprise_build_type
  "enterprise"
end