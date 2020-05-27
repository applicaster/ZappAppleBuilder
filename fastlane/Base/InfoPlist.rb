
def info_plist_update_values(target_name, target_bundle_identifier)
    # update app identifier, versions of the extension
    bundle_version = get_info_plist_value(
      path: project_info_plist_path,
      key: "CFBundleVersion"
    )
    bundle_short_version = get_info_plist_value(
      path: project_info_plist_path,
      key: "CFBundleShortVersionString"
    )
    update_info_plist(
      xcodeproj: xcodeproj_path,
      plist_path: "#{target_name}/Info.plist",
      block: lambda do |plist|
        plist['CFBundleVersion'] = bundle_version
        plist['CFBundleShortVersionString'] = bundle_short_version
      end
    )
  
    # update app identifier to the enterprise one
    update_app_identifier(
      xcodeproj: xcodeproj_path,
      plist_path: "#{target_name}/Info.plist",
      app_identifier: target_bundle_identifier
    )  
end

def info_plist_reset_to_bundle_identifier_placeholder(proj_path, info_plist_path)
    update_info_plist(
      xcodeproj: proj_path,
      plist_path: info_plist_path,
      block: lambda do |plist|
        plist['CFBundleIdentifier'] = "$(PRODUCT_BUNDLE_IDENTIFIER)"
      end
    )
end

def project_info_plist_path
    "#{project_path}/#{project_info_plist_inner_path}"
end