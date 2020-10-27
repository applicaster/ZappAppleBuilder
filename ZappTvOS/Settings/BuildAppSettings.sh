APPVERSION="`/usr/libexec/PlistBuddy -c \"Print :CFBundleVersion\" \"$CODESIGNING_FOLDER_PATH/Info.plist\"`"
APPSHORTVERSION="`/usr/libexec/PlistBuddy -c \"Print :CFBundleShortVersionString\" \"$CODESIGNING_FOLDER_PATH/Info.plist\"`"
SETTINGSBUNDLEPATH="$CODESIGNING_FOLDER_PATH/Settings.bundle/Root.plist"

echo "Printing values for DEBUG_ENABLED_SCRIPTS: $DEBUG_ENABLED_SCRIPTS, for CONFIGURATION: $CONFIGURATION"

echo "Creating $CODESIGNING_FOLDER_PATH/Settings.bundle for '$CONFIGURATION' build"

/usr/libexec/PlistBuddy -c "Delete :PreferenceSpecifiers" "$SETTINGSBUNDLEPATH"

/usr/libexec/PlistBuddy -c "Add :StringsTable string 'Root'" "$SETTINGSBUNDLEPATH"
/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers array" "$SETTINGSBUNDLEPATH"
/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:0 dict" "$SETTINGSBUNDLEPATH"

/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:1:Type string 'PSGroupSpecifier'" "$SETTINGSBUNDLEPATH"
/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:1:Title string 'Assistance'" "$SETTINGSBUNDLEPATH"

/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:2:Type string 'PSToggleSwitchSpecifier'" "$SETTINGSBUNDLEPATH"
/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:2:Title string 'Disable Alert'" "$SETTINGSBUNDLEPATH"
/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:2:Key string 'is_url_scheme_alert_disabled'" "$SETTINGSBUNDLEPATH"
/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:2:DefaultValue bool 'false'" "$SETTINGSBUNDLEPATH"
/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:2:TrueValue bool 'true'" "$SETTINGSBUNDLEPATH"
/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:2:FalseValue bool 'false'" "$SETTINGSBUNDLEPATH"
