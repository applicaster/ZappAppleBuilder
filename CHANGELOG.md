# Changelog

### Minimum OS supported: iOS: 12, tvOS: 12

## SDK supports only UI Framework: QuickBrick

### QuickBrick version: [4.1.6](https://github.com/applicaster/QuickBrick/blob/master/CHANGELOG.md#v416-2021-02-02)

#### React Native version: 0.62.2

### Instruments

- [Xcode](https://developer.apple.com): 12.3.0
- [Fastlane](https://fastlane.tools): 2.171.0
- [CocoaPods](https://github.com/CocoaPods/CocoaPods): 1.9.10
- [ZappTool](https://github.com/applicaster/ZappTool): 4.1.5

### Dependencies

- [ZappCore](https://github.com/applicaster/ZappAppleBuilder): 1.1.1
- [ZappApple](https://github.com/applicaster/ZappAppleBuilder): 1.3.0
- [(iOS) ZappPlugins](https://github.com/applicaster/ZappPlugins.2.0-iOS): 12.0.0
- [(iOS) ZappPushPluginsSDK](https://github.com/applicaster/ZappAppleBuilder): 13.0.0
- [(iOS) ZappAnalyticsPluginsSDK](https://github.com/applicaster/ZappAppleBuilder): 13.0.0

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