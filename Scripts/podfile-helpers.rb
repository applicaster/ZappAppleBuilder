def is_local_build
    ENV['triggered_by'].nil? && ENV['CIRCLECI'].nil?
end

def should_add_flipper_on_local_build
    # skip flipper setup by default on local build
    value = false
    if is_local_build
    # enable flipper based on zapptool param
    value = true if File.file?(".zappToolParams/enable_flipper")
    end
    value
end

def should_remove_app_extensions_on_local_build
    # remove app extensions by default on local build
    value = true
    if is_local_build
    # keep app extensions based on zapptool param
    value = false if File.file?(".zappToolParams/keep_app_extensions")
    end
    value
end

def pre_install_remove_app_extensions(project_name)
    cmd = "cd .. && bundle exec fastlane ios remove_app_extensions_targets project_name:#{project_name}"
    system("#{cmd}")
  end
