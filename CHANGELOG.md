# Changelog

### Minimum OS supported: `iOS: 12, tvOS: 12`

## SDK supports only UI Framework: QuickBrick

### QuickBrick version: [`5.1.0`](https://github.com/applicaster/QuickBrick/blob/master/CHANGELOG.md#v510-2021-06-16)

#### React Native version: `0.62.2`

#### Apple App Tracking Transparency minimum supported sdk: `2.0.1`

### Instruments

- [Xcode](https://developer.apple.com): `12.5.0`
- [Fastlane](https://fastlane.tools): `2.185.1`
- [CocoaPods](https://github.com/CocoaPods/CocoaPods): `1.10.1`
- [ZappTool](https://github.com/applicaster/ZappTool): `4.2.2`

### Dependencies

- [ZappCore](https://github.com/applicaster/ZappAppleBuilder): `1.6.2`
- [ZappApple](https://github.com/applicaster/ZappAppleBuilder): `2.2.0`
- [(iOS) ZappPlugins](https://github.com/applicaster/ZappPlugins.2.0-iOS): `12.0.0`
- [(iOS) ZappPushPluginsSDK](https://github.com/applicaster/ZappAppleBuilder): `13.0.0`
- [(iOS) ZappAnalyticsPluginsSDK](https://github.com/applicaster/ZappAppleBuilder): `13.0.0`

## [4.1.0](https://github.com/applicaster/ZappAppleBuilder/tree/4.1.0) (2021-06-17)

**QB 5.1.0 Highlights:**

- New features:
    - Favourite screen can now be styles and localized
    - URL schemes now support `content_type` options for link URL schemes
    - Now using React Native Safe Area Context library for screen sizing
    - Added React Native Gesture Handler and infrastructure for modal bottom sheet
    - Pipes URL can now be created in any component with useBuildPipesUrl hook
    - Webview screen can now leverage pipes endpoints to add headers & query parameters to webview urls
    - Plugins providing a datasource can now register listeners to notify components that the datasource has changed
    - Plugins can now register hooks to run when connectivity status changes
    - Plugins can now register their own url scheme handlers
    - Zapp Pipes reducer now has a `clear` action to remove a datasource from the store
    - New options for context keys in pipes endpoint: can now define values for headers, Bearer token, query parameter or base64 ctx
    - Samsung, LG, and tvOS horizontal list now supports feed pagination
    - tvOS Top menu bar now allows font family to be customised

**Features**

- Add support for local push replace [\#260](https://github.com/applicaster/ZappAppleBuilder/pull/260) ([alexzchut](https://github.com/alexzchut))
- Handle silent notification with url scheme by UrlSchemeHandler [\#254](https://github.com/applicaster/ZappAppleBuilder/pull/254) ([alexzchut](https://github.com/alexzchut))
- Present local push on silent push receival [\#248](https://github.com/applicaster/ZappAppleBuilder/pull/248) ([alexzchut](https://github.com/alexzchut))
- Add support extandable app delegate [\#202](https://github.com/applicaster/ZappAppleBuilder/pull/202) ([kononenkoAnton](https://github.com/kononenkoAnton))

**Implemented enhancements:**

- Adding WWDR certificate to circle build [\#259](https://github.com/applicaster/ZappAppleBuilder/pull/259) ([alexzchut](https://github.com/alexzchut))
- Update for Network Request logging [\#256](https://github.com/applicaster/ZappAppleBuilder/pull/256) ([alexzchut](https://github.com/alexzchut))
- Add netinfo on tvos [\#255](https://github.com/applicaster/ZappAppleBuilder/pull/255) ([f-roland](https://github.com/f-roland))
- Disabling adding tag in pushes if user disable push notification [\#251](https://github.com/applicaster/ZappAppleBuilder/pull/251) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Support Xcode 12.5 [\#249](https://github.com/applicaster/ZappAppleBuilder/pull/249) ([alexzchut](https://github.com/alexzchut))
- Remove player from package.json on tvos [\#247](https://github.com/applicaster/ZappAppleBuilder/pull/247) ([f-roland](https://github.com/f-roland))
- Add safe area lib [\#246](https://github.com/applicaster/ZappAppleBuilder/pull/246) ([f-roland](https://github.com/f-roland))
- Add react-native-gesture-handler library [\#245](https://github.com/applicaster/ZappAppleBuilder/pull/245) ([f-roland](https://github.com/f-roland))
- Add semver dev dependency to zappios [\#244](https://github.com/applicaster/ZappAppleBuilder/pull/244) ([f-roland](https://github.com/f-roland))
- Ignore upload to appcenter for debug builds [\#241](https://github.com/applicaster/ZappAppleBuilder/pull/241) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Add script to set up repo [\#240](https://github.com/applicaster/ZappAppleBuilder/pull/240) ([f-roland](https://github.com/f-roland))
- Add countryCode and currencySymbol for local storage [\#239](https://github.com/applicaster/ZappAppleBuilder/pull/239) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Update zapptool to support SKAdNetworks settings [\#236](https://github.com/applicaster/ZappAppleBuilder/pull/236) ([alexzchut](https://github.com/alexzchut))
- Limit app version validation to new app versions only [\#235](https://github.com/applicaster/ZappAppleBuilder/pull/235) ([alexzchut](https://github.com/alexzchut))
- Update api key settings + fastlane version bump [\#234](https://github.com/applicaster/ZappAppleBuilder/pull/234) ([alexzchut](https://github.com/alexzchut))
- Update version of quick-brick-native-apple to be used from new location [\#233](https://github.com/applicaster/ZappAppleBuilder/pull/233) ([alexzchut](https://github.com/alexzchut))
- Fastlane files optimizations [\#232](https://github.com/applicaster/ZappAppleBuilder/pull/232) ([alexzchut](https://github.com/alexzchut))
- Add version validations [\#231](https://github.com/applicaster/ZappAppleBuilder/pull/231) ([alexzchut](https://github.com/alexzchut))
- Resolve issue where zapptool can not find a path to push extensions [\#230](https://github.com/applicaster/ZappAppleBuilder/pull/230) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Add store current version validation [\#229](https://github.com/applicaster/ZappAppleBuilder/pull/229) ([alexzchut](https://github.com/alexzchut))
- Update dependencies for Xray changes [\#228](https://github.com/applicaster/ZappAppleBuilder/pull/228) ([alexzchut](https://github.com/alexzchut))
- Update fastlane version + print build params url [\#227](https://github.com/applicaster/ZappAppleBuilder/pull/227) ([alexzchut](https://github.com/alexzchut))
- Update QB 5.0.0 [\#226](https://github.com/applicaster/ZappAppleBuilder/pull/226) ([f-roland](https://github.com/f-roland))
- Update dependencies to add analytics connector with deprecation  message [\#223](https://github.com/applicaster/ZappAppleBuilder/pull/223) ([alexzchut](https://github.com/alexzchut))

## [4.0.0](https://github.com/applicaster/ZappAppleBuilder/tree/4.0.0) (2021-02-22)

**QB 5 Highlights:**

- New TV components:
    - support for Theme plugin with specific properties for TV platforms, including screen & component margins, and content anchoring (determines how many pixels from the top of the screen content is anchored when focus moves)
    - support on TV for Horizontal List (QB) and Grid (QB) plugin. These plugins should be used instead of the legacy horizontal list & grid component. These plugins support full customization of styling & spacing
    - support for Group, Group Info & Group info cell plugins on TV platforms, which allow to create Groups on TV layouts, and support full customization of TV components headers
    - Advanced customization capabilities on component cells with the use of the TV Cell 1 power cell plugin
    - Brand new Screen Picker TV (QB) plugin, with advanced configuration for styling of the screen selector part of the component
- Pipes v2:
    - improved compatibility of pipes v2 layout, on mobile & TV platforms
    - separate entry / screen & search context to inject data in feeds
    - support for v2 feeds from plugins, available on continue watching & local favourites plugins

**Features**

- Add player plugin logic [\#214](https://github.com/applicaster/ZappAppleBuilder/pull/214) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Support AppStore API Key for store uploads  [\#204](https://github.com/applicaster/ZappAppleBuilder/pull/204) ([alexzchut](https://github.com/alexzchut))

**Implemented enhancements:**

- Update podfile changes to remove extensions on preinstall  [\#215](https://github.com/applicaster/ZappAppleBuilder/pull/215) ([alexzchut](https://github.com/alexzchut))
- Removal of App Extensions and Flipper on local build [\#212](https://github.com/applicaster/ZappAppleBuilder/pull/212) ([alexzchut](https://github.com/alexzchut))
- Add new WWDR Certificate [\#211](https://github.com/applicaster/ZappAppleBuilder/pull/211) ([alexzchut](https://github.com/alexzchut))
- Update Xcode version to 12.4.0 [\#209](https://github.com/applicaster/ZappAppleBuilder/pull/209) ([alexzchut](https://github.com/alexzchut))
- Update to print store validation error [\#208](https://github.com/applicaster/ZappAppleBuilder/pull/208) ([alexzchut](https://github.com/alexzchut))

## [3.0.0](https://github.com/applicaster/ZappAppleBuilder/tree/3.0.0) (2021-02-07)

**Features**

- Organize resources images to assets catalog [\#199](https://github.com/applicaster/ZappAppleBuilder/pull/199) ([alexzchut](https://github.com/alexzchut))
- Add support keychain to local storage [\#195](https://github.com/applicaster/ZappAppleBuilder/pull/195) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Adding support for analytics plugins in tvOS [\#181](https://github.com/applicaster/ZappAppleBuilder/pull/181) ([alexzchut](https://github.com/alexzchut))
- Adding support for offline content fetching for item identifier [\#179](https://github.com/applicaster/ZappAppleBuilder/pull/179) ([alexzchut](https://github.com/alexzchut))

**Implemented enhancements:**

- Use S3 download page instead of Appcenter [\#193](https://github.com/applicaster/ZappAppleBuilder/pull/193) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Add artifacts to CircleCI from build content [\#189](https://github.com/applicaster/ZappAppleBuilder/pull/189) ([alexzchut](https://github.com/alexzchut))
- Updates for README.md + fastlane minor version [\#194](https://github.com/applicaster/ZappAppleBuilder/pull/194) ([alexzchut](https://github.com/alexzchut))
- Update build steps + Cocoapods 1.10.0 [\#185](https://github.com/applicaster/ZappAppleBuilder/pull/185) ([alexzchut](https://github.com/alexzchut))
- Prepare to minimum supported iOS 12 [\#182](https://github.com/applicaster/ZappAppleBuilder/pull/182) ([alexzchut](https://github.com/alexzchut))
- Add support check ip-adress with port [\#180](https://github.com/applicaster/ZappAppleBuilder/pull/180) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Remove unneeded setActive audio, it prevent to call PIP and play now [\#178](https://github.com/applicaster/ZappAppleBuilder/pull/178) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Add audio category logs [\#177](https://github.com/applicaster/ZappAppleBuilder/pull/177) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Add system fonts for tvos [\#175](https://github.com/applicaster/ZappAppleBuilder/pull/175) ([f-roland](https://github.com/f-roland))

- Remove empty entitlements 

## [2.0.1](https://github.com/applicaster/ZappAppleBuilder/tree/2.0.1) (2020-12-01)

**Features**

- Add tvOS settings bundle [\#162](https://github.com/applicaster/ZappAppleBuilder/pull/162) ([alexzchut](https://github.com/alexzchut))
- Add start orientation support [\#157](https://github.com/applicaster/ZappAppleBuilder/pull/157) ([kononenkoAnton](https://github.com/kononenkoAnton))

**Implemented enhancements:**

- Set new dependency for push and analytics plugins sdk [\#170](https://github.com/applicaster/ZappAppleBuilder/pull/170) ([alexzchut](https://github.com/alexzchut))
- Finilize support enable/disable plugin feature [\#163](https://github.com/applicaster/ZappAppleBuilder/pull/163) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Add script for blur component [\#155](https://github.com/applicaster/ZappAppleBuilder/pull/155) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Update fastlane to 2.163.0 [\#152](https://github.com/applicaster/ZappAppleBuilder/pull/152) ([alexzchut](https://github.com/alexzchut))
- Add xray readable ui [\#151](https://github.com/applicaster/ZappAppleBuilder/pull/151) ([kononenkoAnton](https://github.com/kononenkoAnton))

**Bug fixes:**

- Remove NSUserTrackingUsageDescription key from the app [\#172](https://github.com/applicaster/ZappAppleBuilder/pull/172) ([alexzchut](https://github.com/alexzchut))
- Update xray version with fix in json file sink [\#168](https://github.com/applicaster/ZappAppleBuilder/pull/168) ([alexzchut](https://github.com/alexzchut))
- Update xray version with fix in search subsystem and bg color [\#165](https://github.com/applicaster/ZappAppleBuilder/pull/165) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Remove rotaion styles from zapptool [\#160](https://github.com/applicaster/ZappAppleBuilder/pull/160) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Fix for Xcode 12 settings failure to build CocoaPods-generate umbrella headers [\#153](https://github.com/applicaster/ZappAppleBuilder/pull/153) ([alexzchut](https://github.com/alexzchut))

## [1.0.0](https://github.com/applicaster/ZappAppleBuilder/tree/1.0.0) (2020-09-22)

**Features**

- Add patch to apply React-Core dependency in podspecs [\#133](https://github.com/applicaster/ZappAppleBuilder/pull/133) ([f-roland](https://github.com/f-roland))
- Add support for AirPlay2 [\#127](https://github.com/applicaster/ZappAppleBuilder/pull/127) ([alexzchut](https://github.com/alexzchut))
- Build release build for enterprise [\#126](https://github.com/applicaster/ZappAppleBuilder/pull/126) ([alexzchut](https://github.com/alexzchut))
- Enable Large Resources in CircleCi [\#102](https://github.com/applicaster/ZappAppleBuilder/pull/102) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Add support of 3d actions handlers [\#100](https://github.com/applicaster/ZappAppleBuilder/pull/100) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Add script to build non minified RN bundle [\#93](https://github.com/applicaster/ZappAppleBuilder/pull/93) ([f-roland](https://github.com/f-roland))
- Add view pager react-native dependency [\#90](https://github.com/applicaster/ZappAppleBuilder/pull/90) ([Budaa](https://github.com/Budaa))
- Add support new key for sessions storage advertisingIdentifier [\#79](https://github.com/applicaster/ZappAppleBuilder/pull/79) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Add applicaster logo to s3 template [\#77](https://github.com/applicaster/ZappAppleBuilder/pull/77) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Optimization of the build time, after RN upgrade [\#75](https://github.com/applicaster/ZappAppleBuilder/pull/75) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Disable push notifications on project level FOR STORE BUILD if no push providers attached to the app [\#74](https://github.com/applicaster/ZappAppleBuilder/pull/74) ([alexzchut](https://github.com/alexzchut))
- Prepare app env for client enterprise build [\#65](https://github.com/applicaster/ZappAppleBuilder/pull/65) ([alexzchut](https://github.com/alexzchut))
- Set XCode 11.4.0 [\#47](https://github.com/applicaster/ZappAppleBuilder/pull/47) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Allow status bar to be controlled from JS [\#42](https://github.com/applicaster/ZappAppleBuilder/pull/42) ([f-roland](https://github.com/f-roland))
- Add local notification logic [\#38](https://github.com/applicaster/ZappAppleBuilder/pull/38) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Add MsAppCenterHandler [\#30](https://github.com/applicaster/ZappAppleBuilder/pull/30) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Add analytics legacy support [\#23](https://github.com/applicaster/ZappAppleBuilder/pull/23) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Add General logic for push notifications [\#17](https://github.com/applicaster/ZappAppleBuilder/pull/17) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Set minimum ios and tvos 11 [\#13](https://github.com/applicaster/ZappAppleBuilder/pull/13) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Add google services plist [\#12](https://github.com/applicaster/ZappAppleBuilder/pull/12) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Refactor of structure from RootViewController to RootController [\#11](https://github.com/applicaster/ZappAppleBuilder/pull/11) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Add base implementation of Push notifications [\#6](https://github.com/applicaster/ZappAppleBuilder/pull/6) ([kononenkoAnton](https://github.com/kononenkoAnton))

- Split projects to have iOS and tvOS as separate projects in their folders [\#3](https://github.com/applicaster/ZappAppleBuilder/pull/3) ([alexzchut](https://github.com/alexzchut))
- Update zapptool in order to support npm plugins install [\#1](https://github.com/applicaster/ZappAppleBuilder/pull/1) ([kononenkoAnton](https://github.com/kononenkoAnton))

**Implemented enhancements:**

- Set xray version 0.13 [\#135](https://github.com/applicaster/ZappAppleBuilder/pull/135) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Patch RCimage in iOS 14, does not work in RN 0.62.2 [\#132](https://github.com/applicaster/ZappAppleBuilder/pull/132) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Update deployment target to 11.0 [\#131](https://github.com/applicaster/ZappAppleBuilder/pull/131) ([alexzchut](https://github.com/alexzchut))
- Resolve xray issues [\#130](https://github.com/applicaster/ZappAppleBuilder/pull/130) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Update to remove additional calls and put logs [\#129](https://github.com/applicaster/ZappAppleBuilder/pull/129) ([alexzchut](https://github.com/alexzchut))
- Ipgrade QuickBrick version to 4.1.1 [\#128](https://github.com/applicaster/ZappAppleBuilder/pull/128) ([f-roland](https://github.com/f-roland))
- Add support of debug env [\#121](https://github.com/applicaster/ZappAppleBuilder/pull/121) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Adding key for idfa usage description [\#119](https://github.com/applicaster/ZappAppleBuilder/pull/119) ([alexzchut](https://github.com/alexzchut))
- Resolve const logs issues [\#117](https://github.com/applicaster/ZappAppleBuilder/pull/117) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Remove support AppCenter analytics from default SDK [\#116](https://github.com/applicaster/ZappAppleBuilder/pull/116) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Remove idfa [\#114](https://github.com/applicaster/ZappAppleBuilder/pull/114) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Remove audio from background modes [\#112](https://github.com/applicaster/ZappAppleBuilder/pull/112) ([alexzchut](https://github.com/alexzchut))
- Update zapptool version [\#111](https://github.com/applicaster/ZappAppleBuilder/pull/111) ([f-roland](https://github.com/f-roland))
- Add core dependencies [\#110](https://github.com/applicaster/ZappAppleBuilder/pull/110) ([f-roland](https://github.com/f-roland))
- Remove unneeded dependencies [\#109](https://github.com/applicaster/ZappAppleBuilder/pull/109) ([f-roland](https://github.com/f-roland))
- Add logs to AppDelegate \[WIP\] [\#103](https://github.com/applicaster/ZappAppleBuilder/pull/103) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Refactor changes crashlogs [\#98](https://github.com/applicaster/ZappAppleBuilder/pull/98) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Add zapptool flags for new RN build options [\#96](https://github.com/applicaster/ZappAppleBuilder/pull/96) ([f-roland](https://github.com/f-roland))
- Add resolutions to package.json files [\#95](https://github.com/applicaster/ZappAppleBuilder/pull/95) ([f-roland](https://github.com/f-roland))
- Move to from fastlane to circle step [\#88](https://github.com/applicaster/ZappAppleBuilder/pull/88) ([alexzchut](https://github.com/alexzchut))
- Update for cache and Xcode version [\#87](https://github.com/applicaster/ZappAppleBuilder/pull/87) ([alexzchut](https://github.com/alexzchut))
- Add correct appname to appcenter post [\#81](https://github.com/applicaster/ZappAppleBuilder/pull/81) ([alexzchut](https://github.com/alexzchut))
- Update for fastlane version to 2.150.0 [\#80](https://github.com/applicaster/ZappAppleBuilder/pull/80) ([alexzchut](https://github.com/alexzchut))
- Move extension helper file to main one [\#78](https://github.com/applicaster/ZappAppleBuilder/pull/78) ([alexzchut](https://github.com/alexzchut))
- Enabling remote menu button [\#76](https://github.com/applicaster/ZappAppleBuilder/pull/76) ([slavo3dev](https://github.com/slavo3dev))
- Update ZappPlugins to new version without UIWebView [\#69](https://github.com/applicaster/ZappAppleBuilder/pull/69) ([alexzchut](https://github.com/alexzchut))
- Adding device params [\#63](https://github.com/applicaster/ZappAppleBuilder/pull/63) ([alexzchut](https://github.com/alexzchut))
- Add system fonts to ios project [\#59](https://github.com/applicaster/ZappAppleBuilder/pull/59) ([f-roland](https://github.com/f-roland))
- Adding changes to support the s3 hostname [\#52](https://github.com/applicaster/ZappAppleBuilder/pull/52) ([alexzchut](https://github.com/alexzchut))
- Update the react native patch with the tvOS microphone dictation [\#51](https://github.com/applicaster/ZappAppleBuilder/pull/51) ([aethiss](https://github.com/aethiss))
- Improve Local notification manger [\#41](https://github.com/applicaster/ZappAppleBuilder/pull/41) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Add family id to session strage [\#39](https://github.com/applicaster/ZappAppleBuilder/pull/39) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Rich push notification support [\#37](https://github.com/applicaster/ZappAppleBuilder/pull/37) ([alexzchut](https://github.com/alexzchut))
- Share change log tvOS and iOS [\#36](https://github.com/applicaster/ZappAppleBuilder/pull/36) ([kononenkoAnton](https://github.com/kononenkoAnton))
- Updates for app center data [\#32](https://github.com/applicaster/ZappAppleBuilder/pull/32) ([alexzchut](https://github.com/alexzchut))
- Adding support for universal links from user activity hooks [\#21](https://github.com/applicaster/ZappAppleBuilder/pull/21) ([alexzchut](https://github.com/alexzchut))
- Set clear color for splash image container and video player + add new images [\#15](https://github.com/applicaster/ZappAppleBuilder/pull/15) ([alexzchut](https://github.com/alexzchut))
