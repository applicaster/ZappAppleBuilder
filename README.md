# ZappAppleBuilder

## Prerequisites

- `Xcode >= 12.3.0`
- `Cocoapods >= 1.10.0` and its prerequisites, see [Zapp-iOS prerequisites section](https://github.com/applicaster/zapp-ios)
- `Zapptool = 4.1.4`

## Zapptool update (2 options)
 1. Get latest version of 4.1.X 
 - `brew install -v https://raw.githubusercontent.com/applicaster/homebrew-tap/master/zapptool/zapptool@4.1.rb`
 2. Get specific version 
 - `curl -L "https://assets-production.applicaster.com/zapp/helpers/zapptool/4.1.4/zapptool.zip`

## Bundler updates
- `bundle update` should be called from the root folder

## How to run the app on the simulator for both iOS and tvOS
- switch to relevant platform folder: 
  - **iOS** - switch to ZappiOS folder
  - **tvOS** - switch to ZappTvOS folder

#### Closed QuickBrick bundle
- run `zapptool -vi {{APP_VERSION_ID}} -pu`
  - (Zapptool will call `yarn` and `pod update` and will get the project ready to use)
- at this stage just open xcode and build application

#### Open loccal QuickBrick bundle
- run `zapptool -vi {{APP_VERSION_ID}} -pu -rn localhost:8081`
  - (Zapptool will call `yarn` and `pod update` and will get the project ready to use)

- at this stage, you can either open xcode, launch the simulator manually and run `yarn start` to start the react-native packager, or run `yarn start:ios` to start the simulator without opening xcode

## How to build Quick Brick & run locally from the Xcode perspective

- Check that the Prerequisites are met
- prepare your quick brick app and start the react-native packager
- Locate the `APP_VERSION_ID`
- `zapptool -vi {{APP_VERSION_ID}} -pu -rn localhost:8081`
- For tvOS `open ZappTvOS.xcworkspace` located in ZappTvOS folder - not `.xcodeproj`!
- For iOS `open ZappiOS.xcworkspace` located in ZappiOS folder - not `.xcodeproj`!
- Build & run on some (iPhone / Apple TV) Simulator

