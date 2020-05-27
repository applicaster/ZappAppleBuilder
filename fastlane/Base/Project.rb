
def project_change_system_capability(capability, old_value, new_value)
    project = "#{xcodeproj_path}/project.pbxproj"
    regex = /(#{capability} = {\s+enabled\s=\s)#{old_value}(;\s+};)/
    substitue = %Q(\\1#{new_value}\\2)
    new_content = File.read(project).gsub!(regex, substitue)
    File.write(project, new_content) if new_content
end

def xcodeproj_path
    "#{project_path}/#{project_name}.xcodeproj"
end

def xcworkspace_relative_path
    "#{project_folder_name}/#{project_name}.xcworkspace"
end

def project_info_plist_inner_path
    "#{project_name}/Info.plist"
end