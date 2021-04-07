require "faraday"
require "versionomy"
require "logger"
require "json"
require 'open-uri'
require 'uri'

desc "Update Zapp with app center link"
namespace :publish_to_zapp do
  task(
    :update_zapp_version
  ) do |_task, args|
    next unless ENV["triggered_by"] == "zapp"

    app_version_id = ENV['version_id']

    connection = Faraday.new(url: "https://zapp.applicaster.com") do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger, ::Logger.new(STDOUT), bodies: true do |logger|
        logger.filter(/(access_token=)(\w+)/, "\1[REMOVED]")
      end
      faraday.adapter Faraday.default_adapter
    end

    # set initial build status as failure
    build_status = "failure"
    debug_info = read_build_params_for_type("debug")
    release_info = read_build_params_for_type("release")

    # success if it is store build and there (release_info and debug_info)
    # or debug_info if it is a debug build only
    if is_release_build_succeeded(debug_info, release_info) || debug_info[:uploaded_at]
      build_status = "success"
    end

    build_params = {
      app_version_id: app_version_id,
      build_status: build_status,
      debug_download_link: debug_info[:download_url],
      debug_installation_link: debug_info[:install_url],
      debug_app_published_time: debug_info[:uploaded_at],
      debug_appcenter_release_id: debug_info[:id],
      debug_appcenter_app_name: debug_info[:app_name],
      release_download_link: release_info[:download_url],
      release_installation_link: release_info[:install_url],
      release_app_published_time: release_info[:uploaded_at],
      release_appcenter_release_id: release_info[:id],
      release_appcenter_app_name: release_info[:app_name],
      distribution_public_identifier: debug_info[:app_secret],
      build_url: ENV["CIRCLE_BUILD_URL"],
      build_num: ENV["CIRCLE_BUILD_NUM"],
      reponame: ENV["CIRCLE_PROJECT_REPONAME"],
      vcs_revision: ENV["CIRCLE_SHA1"],
      branch: ENV["CIRCLE_BRANCH"],
    }.reject { |_k, v| v.nil? }

    params = {
      build: build_params,
      access_token: ENV["ZAPP_TOKEN"],
    }

    puts "params: #{params}"

    response = connection.put("api/v1/ci_builds/#{app_version_id}", params)
    raise "Failed to update version on Zapp with error #{response.status}" unless response.success?
    puts "Version with id  #{app_version_id} was updated!"
  end
end

def is_release_build_succeeded(debug_info, release_info)
  ENV["distribution_key_url"] && release_info[:uploaded_at] && debug_info[:uploaded_at]
end

def read_build_params_for_type(build_type)
  folder_name = ".build_params"
  filename = "#{folder_name}/#{build_type}_upload_params.json"
  if File.exists?(filename)
    JSON.parse(File.read(filename), :symbolize_names => true)
  else
    {}
  end
end
