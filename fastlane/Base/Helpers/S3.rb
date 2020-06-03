import "Base/Helpers/EnvironmentHelper.rb"

def s3_upload_path(bundle_identifier)
  puts("s3_upload_path #{bundle_identifier}")
  "zapp/accounts/#{accountsAccountId}/apps/#{bundle_identifier}/#{store}/#{version_name}/tvos/#{build_version}"
end