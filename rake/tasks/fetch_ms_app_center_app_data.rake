require "faraday"
require "versionomy"
require "logger"
require "json"
require 'open-uri'
require 'uri'

desc "fetch ms app center identifiers"
namespace :ms_app_center do
  task(
    :fetch_identifiers, :bundle_identifier
  ) do |_task, args|
    bundle_identifier = "#{args[:bundle_identifier]}"
    platform = "ios"
    get_app_data("#{bundle_identifier}", "#{platform}")
  end
end

def get_app_data(bundle_identifier, platform)
    app = fetch_app("#{bundle_identifier}", "#{platform}")
    if app['app_secret']
      write_app_data_to_file("#{bundle_identifier}", "#{app['name']}", "appname")
      write_app_data_to_file("#{bundle_identifier}", "#{app['app_secret']}", "appsecret")
      fetch_distribution_group("#{bundle_identifier}", "#{app['name']}")
      return
    end

    # unless check against hockeyapp-appcenter mapping
    puts("--> App with name '#{platform}-#{bundle_identifier}' not found in app-center, checking against hockeyapp-appcenter mapping file")

    mapping_app = fetch_app_details_from_mapping("#{bundle_identifier}", "#{platform}")
    if mapping_app
      puts("--> App found hockeyapp-appcenter mapping file")
      write_app_data_to_file("#{bundle_identifier}", "#{mapping_app['appcenter_app_name']}", "appname")
      write_app_data_to_file("#{bundle_identifier}", "#{mapping_app['appcenter_app_secret']}", "appsecret")
      fetch_distribution_group("#{bundle_identifier}", "#{mapping_app['appcenter_app_name']}")
      return
    end

    puts("--> App not found in hockeyapp-appcenter mapping file, creating new app on app-center")
    create_new_app("#{bundle_identifier}", "#{platform}")
end

def fetch_distribution_group(bundle_identifier, app_name)
  groups = fetch_app_distribution_groups("#{app_name}")
  public_group = groups.select { |h| h['is_public'].to_s() == "true" }.first

  if public_group
    write_app_data_to_file("#{bundle_identifier}", "#{public_group['name']}", "appgroup")
    return
  end

  new_public_group = create_new_public_distribution_group("#{bundle_identifier}", "#{app_name}")
  if new_public_group
    write_app_data_to_file("#{bundle_identifier}", "#{new_public_group['name']}", "appgroup")
    return
  end

  puts("--> Unable to create app distribution group")
end

def fetch_app(bundle_identifier, platform)
  response = app_center_client.get("/v0.1/apps/#{ENV['APPCENTER_OWNER_NAME']}/#{platform}-#{bundle_identifier}")

  content = "{}"
  unless response.success?
    puts("--> Failed to fetch app details for appname #{platform}-#{bundle_identifier}")
  else 
    content = response.body
  end
  JSON.parse(content)
end

def fetch_app_details_from_mapping(bundle_identifier, platform)
  url = "https://assets-production.applicaster.com/zapp/tmp/appcenter/#{platform}/hockeyapp_appcenter_mapping.json"
  response = Faraday.get(url)

  content = "{}"
  unless response.success?
    puts("--> Failed to fetch apps mappings json")
  else 
    content = response.body
  end

  mapping_data = JSON.parse(content)
  mapping_data.select { |h| h['bundle_identifier'] == "#{bundle_identifier}" && h['platform'] == "#{platform}" }.first
end

def fetch_app_distribution_groups(app_name)
  response = app_center_client.get("/v0.1/apps/#{ENV['APPCENTER_OWNER_NAME']}/#{app_name}/distribution_groups")
  raise "Failed to fetch app distribution_groups" unless response.success?

  JSON.parse(response.body)
end

def create_new_public_distribution_group(bundle_identifier, app_name)
  body = {name: "All app users", is_public: true}
  response = app_center_client.post("/v0.1/apps/#{ENV['APPCENTER_OWNER_NAME']}/#{app_name}/distribution_groups", JSON.dump(body))
  raise "Failed to create new app distribution group" unless response.success?

  JSON.parse(response.body)
end

def create_new_app(bundle_identifier, platform)
  body = {
      description: ENV['app_name'],
      release_type: "Beta",
      display_name: ENV['app_name'],
      name: "#{platform}-#{bundle_identifier}",
      os: "iOS",
      platform: "Objective-C-Swift"
  }
  response = app_center_client.post("/v0.1/orgs/#{ENV['APPCENTER_OWNER_NAME']}/apps", JSON.dump(body))
  raise "Failed to create new app" unless response.success?

  app = JSON.parse(response.body)

  write_app_data_to_file("#{bundle_identifier}", "#{app['name']}", "appname")
  write_app_data_to_file("#{bundle_identifier}", "#{app['app_secret']}", "appsecret")
  fetch_distribution_group("#{bundle_identifier}", "#{app['name']}")
end

def write_app_data_to_file(bundle_identifier, value, type)
  puts("--> Saving app data for bundle: #{bundle_identifier}, type: #{type}, value: #{value}")

  folder_name = ".build_params"
  Dir.mkdir(folder_name) unless File.exists?(folder_name)
  open("#{folder_name}/#{bundle_identifier}_#{type}", 'w') { |f|
    f.puts "#{value}"
  }
end

def read_app_secret_from_file(bundle_identifier)
  folder_name = ".build_params"
  filename = "#{folder_name}/#{bundle_identifier}_appsecret"
  if File.exist? "#{filename}"
     File.read("#{filename}")
  end
end

def app_center_client()
  default_headers = {
    'Accept' => 'application/json',
    'Content-Type' => 'application/json',
    'X-API-Token' => ENV['APPCENTER_API_TOKEN']
  }
  Faraday.new(url: "https://api.appcenter.ms", headers: default_headers) do |conn|
    conn.request :retry
    conn.response :logger
    conn.adapter :net_http
  end
end
