require "faraday"
require "versionomy"
require "logger"
require "json"
require 'aws-sdk-s3'

desc "Upload enterprise push certificate to s3"
namespace :upload_enterprise_push do
  task :upload_certificate, :account_id, :app_bundle, :p12_filepath, :p12_filename do |_task, args|
    begin
      if(File.exist?("#{args[:p12_filepath]}/#{args[:p12_filename]}"))
        s3 = Aws::S3::Resource.new(
          access_key_id: ENV["AWS_ACCESS_KEY_ID"],
          secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
          region: ENV["AWS_REGION"],
        )

        write_options = { acl: "public-read", cache_control: "max-age=60" }
        s3_file_path = "zapp/accounts/#{args[:account_id]}/apps/#{args[:app_bundle]}/apple_store/apns/enterprise/#{args[:p12_filename]}"
        obj = s3.bucket(ENV["S3_BUCKET_NAME"])
          .object(s3_file_path)

        File.open("#{args[:p12_filepath]}/#{args[:p12_filename]}", "rb") do |file|
          obj.put({ body: file }.merge(write_options))
        end

        uploaded_to_url = "https://assets-secure.applicaster.com/#{s3_file_path}"
        puts "Enterprise push certificate to #{uploaded_to_url}"
      end
    end
  end
end
