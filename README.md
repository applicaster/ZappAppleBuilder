# ZappAppleBuilder

## Prerequisites

- `Xcode >= 11.2.1`
- `Cocoapods >= 1.8.4` and its prerequisites, see [Zapp-iOS prerequisites section](https://github.com/applicaster/zapp-ios)
- `Zapptool >= 3.8.3`

## Zapptool update (2 options)
 1. Get latest version of 3.8.X 
 - `brew install -v https://raw.githubusercontent.com/applicaster/homebrew-tap/master/zapptool/zapptool@3.8.rb`
 2. Get specific version 
 - `curl -L "https://dl.bintray.com/applicaster-ltd/pods/ZappTool_v3.8.3.zip`

## Bundler updates
- `bundle update` should be called from the root folder

## How to run the app on the simulator for both iOS and tvOS
- switch to relevant platform folder
- run `zapptool -vi {{APP_VERSION_ID}} -ubi -pu -rn localhost:8081`
(Zapptool will call `yarn` and `pod update` and will get the project ready to use)

- at this stage, you can either open xcode, launch the simulator manually and run `yarn start` to start the react-native packager, or run `yarn start:ios` to start the simulator without opening xcode

## How to build & run locally from the Xcode perspective

- Check that the Prerequisites are met
- Locate the `APP_VERSION_ID` in Zapp (platform - Apple TV, SDK - >= 6.0.0)
- `zapptool -vi {{APP_VERSION_ID}} -ubi -pu -rn localhost:8081`
- For tvOS `open ZappTvOS.xcworkspace` located in ZappTvOS folder - not `.xcodeproj`!
- For iOS `open ZappiOS.xcworkspace` located in ZappiOS folder - not `.xcodeproj`!
- Build & run on some (iPhone / Apple TV) Simulator
- `yarn start` - start react-native dev server
