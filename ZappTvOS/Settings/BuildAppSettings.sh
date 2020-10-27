APPVERSION="`/usr/libexec/PlistBuddy -c \"Print :CFBundleVersion\" \"$CODESIGNING_FOLDER_PATH/Info.plist\"`"
APPSHORTVERSION="`/usr/libexec/PlistBuddy -c \"Print :CFBundleShortVersionString\" \"$CODESIGNING_FOLDER_PATH/Info.plist\"`"
SETTINGSBUNDLEPATH="$CODESIGNING_FOLDER_PATH/Settings.bundle/Root.plist"

echo "Printing values for DEBUG_ENABLED_SCRIPTS: $DEBUG_ENABLED_SCRIPTS, for CONFIGURATION: $CONFIGURATION"

echo "Creating $CODESIGNING_FOLDER_PATH/Settings.bundle for '$CONFIGURATION' build"

/usr/libexec/PlistBuddy -c "Delete :PreferenceSpecifiers" "$SETTINGSBUNDLEPATH"

/usr/libexec/PlistBuddy -c "Add :StringsTable string 'Root'" "$SETTINGSBUNDLEPATH"
/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers array" "$SETTINGSBUNDLEPATH"
/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:0 dict" "$SETTINGSBUNDLEPATH"

/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:0:Type string 'PSGroupSpecifier'" "$SETTINGSBUNDLEPATH"
/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:0:Title string 'About'" "$SETTINGSBUNDLEPATH"

/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:1:Type string 'PSTitleValueSpecifier'" "$SETTINGSBUNDLEPATH"
/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:1:Title string 'App Version'" "$SETTINGSBUNDLEPATH"
/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:1:Key string 'app_version'" "$SETTINGSBUNDLEPATH"
/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:1:DefaultValue string '$APPSHORTVERSION ($APPVERSION)'" "$SETTINGSBUNDLEPATH"


/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:2:Type string 'PSGroupSpecifier'" "$SETTINGSBUNDLEPATH"
/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:2:Title string 'Assistance'" "$SETTINGSBUNDLEPATH"

/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:3:Type string 'PSToggleSwitchSpecifier'" "$SETTINGSBUNDLEPATH"
/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:3:Title string 'Log events'" "$SETTINGSBUNDLEPATH"
/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:3:Key string 'logger_assistance'" "$SETTINGSBUNDLEPATH"
/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:3:DefaultValue bool 'false'" "$SETTINGSBUNDLEPATH"
/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:3:TrueValue bool 'true'" "$SETTINGSBUNDLEPATH"
/usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:3:FalseValue bool 'false'" "$SETTINGSBUNDLEPATH"
