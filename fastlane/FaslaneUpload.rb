# frozen_string_literal: true

import 'Base/BuildType.rb'

platform :ios do
  def update_app_secret(bundle_identifier)
    if isTvOS == false
      puts("Update MS App Center's secret")
      ms_app_center_update_app_secret(bundle_identifier)
    end
  end

  lane :publish_builds_to_zapp do
    # update zapp with new uploaded version
    version_id = (ENV['version_id']).to_s
    command = "bundle exec rake publish_to_zapp:update_zapp_version[\"#{version_id}\"]"
    sh(command.to_s)
  end
end
