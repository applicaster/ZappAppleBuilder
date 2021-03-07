# frozen_string_literal: true

class EnvironmentHelper
  def device_target
    ENV['device_target']
  end

  def platform_name
    device_target == 'apple_tv' ? 'tvos' : 'ios'
  end

  def isTvOS
    device_target == 'apple_tv'
  end

  def version_name
    ENV['version_name']
  end

  def build_version
    ENV['build_version']
  end

  def store
    ENV['store']
  end

  def accounts_account_id
    ENV['accounts_account_id']
  end

  def s3_bucket_name
    ENV['S3_BUCKET_NAME']
  end

  def aws_access_key
    ENV['AWS_ACCESS_KEY_ID']
  end

  def aws_secret_access_key
    ENV['AWS_SECRET_ACCESS_KEY']
  end

  def aws_region
    ENV['AWS_REGION']
  end

  def build_configuration
    'Release'
  end

  def keychain_name
    'zapp-apple-build.keychain'
  end

  def keychain_password
    'circle'
  end

  def root_path
    (ENV['PWD']).to_s
  end

  def app_name
    ENV['app_name']
  end

  def bundle_identifier
    ENV['bundle_identifier']
  end

  def distribution_key_url
    ENV['distribution_key_url']
  end

  def distribution_key_password
    ENV['distribution_key_password']
  end

  def provisioning_profile_url
    ENV['provisioning_profile_url']
  end

  def debug_distribution_key_url
    ENV['debug_distribution_key_url']
  end

  def debug_distribution_key_password
    ENV['debug_distribution_key_password']
  end

  def debug_provisioning_profile_url
    ENV['debug_provisioning_profile_url']
  end

  def s3_hostname
    ENV['s3_hostname']
  end

  def with_release
    ENV['with_release']
  end

  def s3_upload_path(bundle_identifier)
    "zapp/accounts/#{accounts_account_id}/apps/#{bundle_identifier}/#{store}/#{version_name}/tvos/#{build_version}"
  end

  def s3_generic_upload_path(bundle_identifier)
    "zapp/accounts/#{accounts_account_id}/apps/#{bundle_identifier}/#{store}/#{version_name}/builds/#{platform_name}/#{build_version}"
  end
end
