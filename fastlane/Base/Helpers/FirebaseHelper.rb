# frozen_string_literal: true

require 'fileutils'

import 'Base/Helpers/ProjectHelper.rb'
import 'Base/Helpers/BaseHelper.rb'

class FirebaseHelper < BaseHelper
  attr_accessor :projectHelper

  def initialize(options = {})
    super
    @projectHelper = options[:projectHelper]
  end

  def add_configuration_file(configuration)
    base_folder = "#{@projectHelper.path}/#{@projectHelper.name}"

    filepath = "#{base_folder}/.firebase/#{configuration}/GoogleService-Info.plist"
    if File.exist? filepath
      FileUtils.cp(filepath, base_folder)
      File.delete(filepath)
    end
  end
end
