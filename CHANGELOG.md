# Changelog

### Minimum OS supported: iOS: 11, tvOS: 11

## SDK supports only UI Framework: QuickBrick

### QuickBrick version: [3.0.1](https://github.com/applicaster/QuickBrick/blob/master/CHANGELOG.md#v301-2020-05-18)

### React Native version: 0.59.10

## [iOS:20.1.1](https://github.com/applicaster/ZappAppleBuilder.git/tree/20.1.1) (2019-5-19)

[Full Changelog](https://github.com/applicaster/ZappAppleBuilder.git/tree/20.1.1)

## [iOS:20.0.0](https://github.com/applicaster/ZappAppleBuilder.git/tree/20.0.0) (2019-3-9)

[Full Changelog](https://github.com/applicaster/ZappAppleBuilder.git/tree/20.0.0)

## [tvOS:14.0.0](https://github.com/applicaster/ZappAppleBuilder.git/tree/14.0.0) (2019-3-9)
 
[Full Changelog](https://github.com/applicaster/ZappAppleBuilder.git/tree/14.0.0)

### Dependencies

- [ZappCore](https://github.com/applicaster/ZappAppleBuilder): 0.9.5
- [ZappApple](https://github.com/applicaster/ZappAppleBuilder): 0.7.8
- [(iOS) ZappPlugins](https://github.com/applicaster/ZappPlugins.2.0-iOS): 11.6.1
- [(iOS) ZappPushPluginsSDK](https://github.com/applicaster/ZappPushPluginsSDK-iOS): 11.0.1
- [(iOS) ZappAnalyticsPluginsSDK](https://github.com/applicaster/ZappAnalyticsPluginsSDK-iOS): 11.0.0

### Features

**iOS application support!**

- Deploy your application via Zapp for Debug, Release.
- Support of the Plugins System.
  - Analytics
  - Video Advertisment
  - (iOS) Push Provider
  - (iOS) Error Monitoring

**General**

- Add Google Services template for Firebase plugins [#12](https://github.com/applicaster/ZappAppleBuilder/pull/12)([kononenkoAnton](https://github.com/kononenkoAnton))
- Add store releases for Fastlane [#2](https://github.com/applicaster/ZappAppleBuilder/pull/2)([kononenkoAnton](https://github.com/kononenkoAnton))
- Split project on iOS and tvOS [#3](https://github.com/applicaster/ZappAppleBuilder/pull/3)([alexzchut](https://github.com/alexzchut))
- Add support latest local splash images [#15](https://github.com/applicaster/ZappAppleBuilder/pull/15)([alexzchut](https://github.com/alexzchut))
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

**UI Framework**

- Refactor code to provide UIFramework root view controller structure[#11](https://github.com/applicaster/ZappAppleBuilder/pull/11)([kononenkoAnton](https://github.com/kononenkoAnton))
