# Zapp-tvOS

## Prerequisites

- `Xcode >= 11.2.1`
- `Cocoapods >= 1.4.x` and its prerequisites, see [Zapp-iOS prerequisites section](https://github.com/applicaster/zapp-ios)
- `git submodule update --init --recursive` - update SubModules
- `brew upgrade zapptool` - get latest zapptool version

## How to run the app on the simulator

- run `yarn` to install dependencies
- run `zapptool -vi {{APP_VERSION_ID}} -pu -rn localhost:8081`
- run `yarn zapplicaster:prepare -a <app_version_id>` to prepare the workspace
- at this stage, you can either open xcode, launch the simulator manually and run `yarn start` to start the react-native packager, or run `yarn start:ios` to start the simulator without opening xcode

## How to build & run locally from the Xcode perspective

- Check that the [https://github.com/applicaster/QuickBrick-tvOS#prerequisites](Prerequisites) are met
- Locate the `APP_VERSION_ID` in Zapp (platform - Apple TV, SDK - >= 6.0.0)
- `zapptool -vi {{APP_VERSION_ID}} -pu -rn localhost:8081`
- `open ZappTvOS.xcworkspace` - not `.xcodeproj`!
- Build & run on some Apple TV Simulator
- `yarn start` - start react-native dev server
