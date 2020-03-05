# Changelog

### Minimum OS supported: iOS 11, tvOS 11

### React Native version: 0.59.10

### QuickBrick version: [2.2.0](https://github.com/applicaster/QuickBrick/blob/master/CHANGELOG.md#220-2019-12-20)

## [20.0.0](https://github.com/applicaster/ZappAppleBuilder.git/tree/20.0.0) (2019-3-6)

[Full Changelog](https://github.com/applicaster/Zapp-tvOS/tree/20.0.0)

### Dependencies

- ZappCore: 0.8.6
- ZappApple: 0.6.15
- (iOS) ZappPlugins: 11.6.1
- (iOS) ZappPushPluginsSDK: 11.0.1
- (iOS) ZappAnalyticsPluginsSDK: 11.0.0

### Features

**iOS application support!**
**General**

- Add Google Services template for Firebase plugins [#12](https://github.com/applicaster/ZappAppleBuilder/pull/12)([kononenkoAnton](https://github.com/kononenkoAnton))
- (iOS) Add store releases for Fastlane [#2](https://github.com/applicaster/ZappAppleBuilder/pull/2)([kononenkoAnton](https://github.com/kononenkoAnton))
- Split project on iOS and tvOS [#3](https://github.com/applicaster/ZappAppleBuilder/pull/3)([alexzchut](https://github.com/alexzchut))
- (iOS) Add support latest localsplash images [#15](https://github.com/applicaster/ZappAppleBuilder/pull/15)([alexzchut](https://github.com/alexzchut))
- Add support of universal links from user activity hooks [#21](https://github.com/applicaster/ZappAppleBuilder/pull/21)([alexzchut](https://github.com/alexzchut))
- URL Handler to reset UUID of device [#22](https://github.com/applicaster/ZappAppleBuilder/pull/21)([alexzchut](https://github.com/alexzchut))
- Resolve React Native bug that causing spam inside xCode console [#24](https://github.com/applicaster/ZappAppleBuilder/pull/24)([kononenkoAnton](https://github.com/kononenkoAnton))
- Fix developer project path for iOS and tvOS [#25](https://github.com/applicaster/ZappAppleBuilder/pull/25)([kononenkoAnton](https://github.com/kononenkoAnton))
- Add Firebase helper to invoke after application finish launch [#29](https://github.com/applicaster/ZappAppleBuilder/pull/29)([kononenkoAnton](https://github.com/kononenkoAnton))
- Add MSAppCenter helper to invoke after application finish launch [#30](https://github.com/applicaster/ZappAppleBuilder/pull/30)([kononenkoAnton](https://github.com/kononenkoAnton))
- Add Audience implementation [#31](https://github.com/applicaster/ZappAppleBuilder/pull/31)([kononenkoAnton](https://github.com/kononenkoAnton))
- Remove code AIS code [#9](https://github.com/applicaster/ZappAppleBuilder/pull/9)([kononenkoAnton](https://github.com/kononenkoAnton))

**(iOS) Push Notification**

- Add general implementation of Push Notifications [#6](https://github.com/applicaster/ZappAppleBuilder/pull/6)([kononenkoAnton](https://github.com/kononenkoAnton))
- Add support of legacy push plugins that use ZappPushPluginsSDK base file [#17](https://github.com/applicaster/ZappAppleBuilder/pull/17)([kononenkoAnton](https://github.com/kononenkoAnton))

**Analytics**

- Add support of legacy analytics plugins that use ZappAnalyticsPluginsSDK base file [#23](https://github.com/applicaster/ZappAppleBuilder/pull/23)([kononenkoAnton](https://github.com/kononenkoAnton))

**UIFramework**

- Refactor code to provide UIFramework root view controller structure[#11](https://github.com/applicaster/ZappAppleBuilder/pull/11)([kononenkoAnton](https://github.com/kononenkoAnton))

### Minimum OS supported: tvOS 10

### React Native version: 0.59.10

### QuickBrick version: [2.2.0](https://github.com/applicaster/QuickBrick/blob/master/CHANGELOG.md#220-2019-12-20)

## [11.0.0](https://github.com/applicaster/Zapp-tvOS/tree/11.0.0) (2019-12-23)

[Full Changelog](https://github.com/applicaster/Zapp-tvOS/compare/10.1.0...11.0.0)

### Features

**Universal Search**

- Add support of Universal-Search [#104](https://github.com/applicaster/Zapp-tvOS/pull/104)

**UI**

- Migrate to repo with iOS and TVos [#107](https://github.com/applicaster/Zapp-tvOS/pull/107)

**Notify Zapp**

- Update Zapp after upload to S3 [#112](https://github.com/applicaster/Zapp-tvOS/pull/112)

**Local Storage**

- Add all configuration to local storage [#114](https://github.com/applicaster/Zapp-tvOS/pull/114)

**Upload for Testflight**

- adding upload to testflight [#116](https://github.com/applicaster/Zapp-tvOS/pull/116)

**Session Storage**

- Share local and session storage default params with local and session storage [#118](https://github.com/applicaster/Zapp-tvOS/pull/118)

### Bugs

**Path Fixes**

- assets was not part of tvos target [#113](https://github.com/applicaster/Zapp-tvOS/pull/113)
- fix path to tvos S3 to uload [#119](https://github.com/applicaster/Zapp-tvOS/pull/119)
- Fix path for s3 [#120](https://github.com/applicaster/Zapp-tvOS/pull/120)
- fix s3 path [#121](https://github.com/applicaster/Zapp-tvOS/pull/121)

**Localization**

- Sync localization keys with ios project [#117](https://github.com/applicaster/Zapp-tvOS/pull/117)

**Appready**

- Fix appready setup [#118](https://github.com/applicaster/Zapp-tvOS/pull/118)

**Rake Tasks**

- Fix rake task update zapp [#122](https://github.com/applicaster/Zapp-tvOS/pull/122)

**Player**

- Dependant player plugin manager does not call completion if no dependant player prividers [#123](https://github.com/applicaster/Zapp-tvOS/pull/123)

### Improvements

**Dependency Updates**

- Move to new canary build [#103](https://github.com/applicaster/Zapp-tvOS/pull/103)
- migrate to Node 12 [#106](https://github.com/applicaster/Zapp-tvOS/pull/106)
- updated Podfile to point to latest ZappPlugins [#108](https://github.com/applicaster/Zapp-tvOS/pull/108)
- Update version zapp plugins version [#109](https://github.com/applicaster/Zapp-tvOS/pull/109)
- Migrate swift 5.1 [#111](https://github.com/applicaster/Zapp-tvOS/pull/111)
- Set quick brick apple to version 2.2.0-rc.a71e7e21 [#115](https://github.com/applicaster/Zapp-tvOS/pull/115)
- updated required Xcode version in docs [#124](https://github.comead/applicaster/Zapp-tvOS/pull/124)

**Refactors**

- 10.1.0 rc.2 merge on master [#101](https://github.com/applicaster/Zapp-tvOS/pull/101)
- Refactor new quick brick structure [#102](https://github.com/applicaster/Zapp-tvOS/pull/102)
- Remove uneeded web hook [#125](https://github.com/applicaster/Zapp-tvOS/pull/125)
