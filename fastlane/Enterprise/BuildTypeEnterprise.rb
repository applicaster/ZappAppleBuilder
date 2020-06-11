# frozen_string_literal: true

require 'fileutils'
require 'fastlane/action'
require 'fastlane'

import 'Base/BuildType.rb'

class BuildTypeEnterprise < BuildType
  def perform_post_build_procedures
    copy_artifacts(
      target_path: 'CircleArtifacts/Enterprise',
      artifacts: [
        "~/Library/Logs/gym/#{@projectHelper.scheme}-#{@projectHelper.scheme}.log"
      ]
    )
  end

  def prepare_app_for_build
    # delete spotlight subscription entitlements if exists
    remove_key_from_entitlements(@projectHelper.name.to_s, 'Release', 'com.apple.smoot.subscriptionservice')
    # delete sso entitlements if exists
    remove_key_from_entitlements(@projectHelper.name.to_s, 'Release', 'com.apple.developer.video-subscriber-single-sign-on')
  end

  def enterprise_build_type
    'enterprise'
  end

  def build_configuration
    @@envHelper.build_configuration
  end
end
