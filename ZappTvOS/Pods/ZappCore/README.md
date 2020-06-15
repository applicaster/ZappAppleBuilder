# :green_apple: Apple Frameworks

![CircleCI](https://circleci.com/gh/applicaster/AppleApplicasterFrameworks.svg?style=svg&circle-token=8fedcc78af0010cec307b550771857ed27eee835)
![Platforms](https://img.shields.io/badge/Platforms-iOS%20|%20tvOS-f6b854.svg)
[![GitHub license](https://img.shields.io/github/license/applicaster/AppleApplicasterFrameworks)](https://github.com/applicaster/AppleApplicasterFrameworks/blob/master/LICENSE)

- **OS:** iOS 10+, tvOS 12+
- **Languages:** Swift 5.1, frameworks can be used in Swift and Objective-C
- **Tool requirements:** Xcode 11.3, Cocoapods 1.8.3
- **License:** [Appache 2.0](https://github.com/applicaster/AppleApplicasterFrameworks/blob/master/LICENSE)

**Note:** Please do not change this document directly. If you need to update documentation use template `README.md.ejs` file.

## :paperclip: Table of contents

- [Overview](#eyeglasses-overview)
- [Frameworks List](#fax-frameworks-list)
- [Usage](#pencil2-usage)
- [Folder Structure](#file_folder-folder-structure)
- [FrameworksData.plist](#pencil2-frameworksData.plist)
- [How to add new framework?](#page_facing_up-how-to-add-new-framework)
- [How to update existing framework?](#page_with_curl-how-to-update-existing-framework)
- [How it works?](#mortar_board-how-it-works)

## :eyeglasses: Overview

This respository is the main container for general frameworks and plugins for [ZappApple](https://github.com/applicaster/AppleApplicasterFrameworks) project. Each frameworks defined here support `cocoapods` as a dependency manager.

## :fax: Frameworks List

##### ZappCore: *0.9.16*
- **Description:** Contain plugin protocols, helper methods that can be used by any Zapp plugin or framework
- [**Documentation**](https://applicaster.github.io/AppleApplicasterFrameworks/ZappCore/index.html)

##### ZappApple: *0.7.18*
- **Description:** Contain data stucture to start Zapp application.
- [**Documentation**](https://applicaster.github.io/AppleApplicasterFrameworks/ZappApple/index.html)

### Zapp Plugins

#### Type: Analytics

##### Google Analytics Web Based API: *0.7.2*
- **Description:** This plugin allow to add Google Analytics as agent.
- [**Documentation**](https://applicaster.github.io/AppleApplicasterFrameworks/ZappGoogleAnalytics/index.html)
- **Manifest:**
  - [iOS](https://zapp.applicaster.com/admin/plugin_versions?id=zapp_google_analytics&platform=ios)
  - [tvOS](https://zapp.applicaster.com/admin/plugin_versions?id=zapp_google_analytics&platform=tvos)

#### Type: Crashlogs

##### MS App Center: *4.5.1*
- **Description:** [App center](https://appcenter.ms) crash logs service.
- [**Documentation**](https://applicaster.github.io/AppleApplicasterFrameworks/ZappCrashlogsMsAppCenter/index.html)
- **Manifest:**
  - [iOS](https://zapp.applicaster.com/admin/plugin_versions?id=crashlogs_appcenter&platform=ios)

#### Type: Player Dependant

##### Google Interactive Media Ads: *0.9.0*
- **Description:** This plugin allow to add Google Interactive Media Ads to supported players.
- [**Documentation**](https://applicaster.github.io/AppleApplicasterFrameworks/ZappGoogleInteractiveMediaAds/index.html)
- **Manifest:**
  - [iOS](https://zapp.applicaster.com/admin/plugin_versions?id=zapp_google_interactive_media_ads&platform=ios)
  - [tvOS](https://zapp.applicaster.com/admin/plugin_versions?id=zapp_google_interactive_media_ads&platform=tvos)

#### Type: General

##### Apple Video Subscription Registration: *0.1.10*
- **Description:** This plugin subscribe the user to the video subscription in order to get shared content for iOS and tvOS.
- [**Documentation**](https://applicaster.github.io/AppleApplicasterFrameworks/ZappAppleVideoSubscriptionRegistration/index.html)
- **Manifest:**
  - [iOS](https://zapp.applicaster.com/admin/plugin_versions?id=video_subscription_registration_apple&platform=ios)
  - [tvOS](https://zapp.applicaster.com/admin/plugin_versions?id=video_subscription_registration_apple&platform=tvos)

##### Apple Video Now Playing Info: *0.1.7*
- **Description:** This plugin saves current played item metadata to be accessible on other device (saved on iOS to use on tvOS and vice versa).
- [**Documentation**](https://applicaster.github.io/AppleApplicasterFrameworks/ZappAppleVideoNowPlayingInfo/index.html)
- **Manifest:**
  - [iOS](https://zapp.applicaster.com/admin/plugin_versions?id=video_playing_now_apple&platform=ios)
  - [tvOS](https://zapp.applicaster.com/admin/plugin_versions?id=video_playing_now_apple&platform=tvos)

##### Apple Video Subscriber SSO: *0.1.10*
- **Description:** This plugin performs as player prehook to login to the TV Provider before player starts.
- [**Documentation**](https://applicaster.github.io/AppleApplicasterFrameworks/ZappAppleVideoSubscriberSSO/index.html)
- **Manifest:**
  - [iOS](https://zapp.applicaster.com/admin/plugin_versions?id=video_subscriber_sso_apple&platform=ios)
  - [tvOS](https://zapp.applicaster.com/admin/plugin_versions?id=video_subscriber_sso_apple&platform=tvos)


##### General Local Notification: *0.1.4*
  - **Description:** This plugin allow to control Local Notification events for iOS and tvOS.
  - [**Documentation**](https://applicaster.github.io/AppleApplicasterFrameworks/ZappLocalNotifications/index.html)
  - [**API**](https://applicaster.github.io/AppleApplicasterFrameworks/NotGeneratedDocs/LocalNotifications/LocalNotifications.html)
  - **Manifest:**
    - [iOS](https://zapp.applicaster.com/admin/plugin_versions?id=generic_local_notifications&platform=ios)
    - [tvOS](https://zapp.applicaster.com/admin/plugin_versions?id=generic_local_notifications&platform=tvos)

##### Chromecast: *0.1.7*
  - **Description:** This plugin allow to add Chromecast functionality for iOS and Android.
  - [**Documentation**](https://applicaster.github.io/AppleApplicasterFrameworks/ZappChromecast/index.html)
  - [**API**](https://applicaster.github.io/AppleApplicasterFrameworks/NotGeneratedDocs/ZappChromecast/ZappChromecast.html)
  - **Manifest:**
    - [iOS](https://zapp.applicaster.com/admin/plugin_versions?id=zapp-generic-chromecast&platform=ios)
    - [iOS for QB](https://zapp.applicaster.com/admin/plugin_versions?id=zapp-generic-chromecast&platform=ios_for_quickbrick)
    - [Android](https://zapp.applicaster.com/admin/plugin_versions?id=zapp-generic-chromecast&platform=android)
    - [Android for QB](https://zapp.applicaster.com/admin/plugin_versions?id=zapp-generic-chromecast&platform=android_for_quickbrick)

## :pencil2: Usage

* To use any framework availible in this repo add cocoapods dependency in podfile.

    **Example:**
    ```ruby
    pod 'ZappCore', :git => 'https://github.com/applicaster/AppleApplicasterFrameworks.git', :tag => '2020.2.4.19-2-2'
    ```

* To use any plugin availible in this repo please use [UI Builder Environment](https://zapp.applicaster.com). All Plugins use `npm packages` as a package delivery and added in the  application as dev cocoapods dependencies


## :file_folder: Folder Structure
Repository has predefined structure if you want to add something, please conform to the strict structure rules defined below

```swift
Apple Framworks
├── docs // Contains generated documentation for the frameworks. Content is generated automatically.
├── fastlane // Configuration of the fastlane deployment tool used in CI.
├── Frameworks // Frameworks data seperated by folders.
│   ├── *FrameworkName // All Frameworks, not part of ZAPP PLUGINS type Contains in the Root.
│   │   ├── .jazzy.yaml // Jazzy configuration file that defined to create auto generated docs
│   │   ├── Files // Files that are relevant for the framework.
│   │   │   ├── iOS // Files that can be used in iOS only
│   │   │   ├── tvOS // Files that can be used in tvOS only
│   │   │   ├── Tests // Unit test files
│   │   │   └── Universal // Files that can be used in iOS and tvOS
│   │   └── Templates // Template files relevant for framework automation.
│   │   │   ├── .jazzy.yaml.ejs // Jazzy template configuration file that is defined to create auto generated docs.
│   │   │   └── FrameworkName.podpec.ejs  // Cocoapods template dependency.
│   └── *FrameworkName // All Frameworks, is part of ZAPP PLUGINS type.
│       ├── *FrameworkName // All Frameworks, is part of ZAPP PLUGINS type.
│       │   ├── .jazzy.yaml // Jazzy configuration file that defined to create auto generated docs
│       │   ├── Files // Files that are relevant for the framework.
│       │   │   ├── iOS // Files that can be used in iOS only
│       │   │   ├── tvOS // Files that can be used in tvOS only
│       │   │   ├── Tests // Unit test files
│       │   │   ├── src // Npm package files, any java script code if plugin needed
│       │   │   ├── FrameworkName.podspec // Cocoapods dependency file
│       │   │   ├── package.json // Node package file.
│       │   │   └── Universal // Files that can be used in iOS and tvOS
│       │   ├── Manifest // ZAPP PLUGINS manifest describes plugin created by Zappifest.
│       │   │   ├── ios.json // Generated manifest for ios ZAPP PLUGIN structure. All changes must be done in ios.json.ej
│       │   │   ├── tvos.json // Generated manifest for tvos ZAPP PLUGIN structure. All changes must be done in tvos.json.ej
│       │   ├── Templates // Template files relevant for framework automation.
│       │   │   ├── ios.json.ejs // Template manifest for ios ZAPP PLUGIN structure.
│       │   │   ├── tvos.json.ejs // Template manifest for tvos ZAPP PLUGIN structure.
│       │   │   ├── .jazzy.yaml.ejs // Jazzy template configuration file that is defined to create auto generated docs.
│       └── └── └── FrameworkName.podpec.ejs  // Cocoapods template dependency.
├── FrameworksApp // General client app that each framework is using to unit test and generate project.
├── Scripts // Automotization scripts. All scripts defined in JavaScript.
├── .versions_automation.json // Automation file, must not be changed by user. Contains JSON with title and version of each framework.
├── FrameworksData.plist // Contains information about frameworks: title, version and etc. Only in this file user must change a version of new framework during update
├── Gemfile // Ruby packages.
├── LICENSE // Repo licence type.
├── package.json // Java Script packages.
├── README.md // Git documentations file. All changes must be done in README.md.ejs
├── README.md.ejs // Git documentations template file.
└── *.podspec // Cocoapods dependency files for all non plugins frameworks.
```

## :pencil2: `FrameworksData.plist`
This file provides information for automation system latest version of availible frameworks or plugins. To update the version of your framework or plugin must be changed in this file. Below will be described plist structure

```swift
Dictionary
├── Framework/Plugin Id // Key described identifier of the item.
│   ├── version_id // Current version of the item based on `major/minor/bug` `1.0.0` convention.
└── └── plugin // Define if item is a framework or plugin.
```

## :page_facing_up: How to add new framework

** Create Framework**

- Create branch `new_framework_name`
- Use [Folder Structure](#file_folder-folder-structure) article to check expected your framework folder structure.

- Open [FrameworksData.plist]((#pencil2-frameworksData.plist) file in the root of your repo:
	- Add new value dictionary value. As a key use your `framework_id`
	- Inside your dictionary add key `version_id` value `version number` based on `major/minor/bug` `1.0.0` convention.

- Open `Frameworks` folder in Root of the repo and create with `framework_id` as folder name. In future mention of this folder will be called as framework root folder.
- Create `Files` folder in your framework's root folder. This folder will be used for the source code of your framework.
	- Create folder `iOS` if you have files relevant only for iOS
	- Create folder `tvOS` if you have files relevant only for tvOS
	- Create folder `Universal` If you have universal file for iOS and tvOS
	- Note: single framework can have all three types of folders if it supports `ios` and `tvos`.
	- Create folder `Tests` for unit tests.

- Create [Cocoapods](https://guides.cocoapods.org/) `podspec` file for your framework in root of the repo folder.
	- `podspec` name must be same name as the `framework_id`.  Example: `MyFramework.podspec`
	- Prepare `podspec` based of your frameworks needs.
	- Add `test_spec` and define path to your `Unit test files`
	- If framework supports `tvos` and `ios` dependency must be defined in same `podspec` file.
	- Example
	```ruby
    Pod::Spec.new do |s|
          s.name = 'ZappCore'
          s.version = '0.6.1'
          s.summary = 'General Applicaster iOS and tvOS framework that provides protocol'
          s.ios.deployment_target = '10.0'
          s.tvos.deployment_target = '10.0'
          s.swift_versions = '5.1'
          s.description = <<-DESC
          'General Applicaster iOS and tvOS framework that provides protocol and this lowest hierarchy layer'
          DESC

          s.homepage = 'https://github.com/applicaster/AppleApplicasterFrameworks.git'
          s.license = 'Appache 2.0'
          s.author = { 'a.kononenko@applicaster.com' => 'a.kononenko@applicaster.com' }
          s.source = { :git => 'https://github.com/applicaster/AppleApplicasterFrameworks.git', :tag => "2020.1.13.16-1-4" }

          s.source_files = 'Frameworks/ZappCore/Files/Universal/**/*.{swift}'

          s.test_spec 'UnitTests' do |sp|
            sp.source_files = 'Frameworks/ZappCore/Files/Tests/**'
          end
	end
	```

- Create `Podfile`[cocoapods](https://cocoapods.org) dependecy and configure it for the project in Framework's root folder.
	- In the `podfile` define all dependancy that may needed for your framework.
	- Define your framework as develement pod with `testspecs`
	- Make sure that `share_schemes_for_development_pods` will be added, it export `cocoapods` schemes from xsworkspace.
	- Note: this Podile will be used by automation to unit test your framework and generare jazzy docs
	- Example:
	```ruby
    source 'https://cdn.cocoapods.org/'

    platform :ios, '10.0'
    install! 'cocoapods', :share_schemes_for_development_pods => true
    project '../../FrameworksApp/FrameworksApp.xcodeproj'

    pre_install do |installer|
        # workaround for https://github.com/CocoaPods/CocoaPods/issues/3289
        Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
    end

    target 'FrameworksApp' do
      supports_swift_versions '5.1'
      use_frameworks!
      pod 'ZappCore', :path => '../../ZappCore.podspec'
      pod 'ZappApple', :path => '../../ZappApple.podspec', :testspecs => ['UnitTests']

      target 'FrameworksAppTests' do
        inherit! :search_paths
      end

    end

    post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
              config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
          end
      end
    end
	```
- Create file `.jazzy.yaml` with configuration of [Jazzy documentation](https://github.com/realm/jazzy). Details configure [Jazzy](https://github.com/realm/jazzy) can be founded in [Jazzy Repo](https://github.com/realm/jazzy) or copied from existing frameworks.
	- Make sure that you define in `xcode arguments` your framework scheme.
    - Example:
        ```swift
        module: ZappFirebaseAnalytics
        module_version: "0.2.0"

        author: "Applicaster ltd."
        copyright: "© 2019 [Applicaster ltd.](http://bustoutsolutions.com) under [Appache 2.0](https://github.com/applicaster/AppleApplicasterFrameworks/blob/master/LICENSE)."

        xcodebuild_arguments: ["-scheme", "ZappCore"]
        author_url: https://www.applicaster.com
        github_url: https://github.com/applicaster/AppleApplicasterFrameworks/tree/master/Frameworks/Plugins/Analytics/Firebase/ZappFirebaseAnalytics

        output: "../../../../../docs/ZappFirebaseAnalytics"
        clean: true
        min_acl: "private"
        sdk: [iphone, appletv]
        theme: jony
        ```
- Create `Templates` folder in your framework's root folder. In this folder you will be provided data for automated deployment. Templates files use structure of [ejs](https://ejs.co).
	- Copy the `.jazzy.yaml` file created before in path and rename it to `.jazzy.yaml.ejs`. Change field to `module_version: "<%= version_id %>"`.
	- Copy `FrameworkName.podspec` file created before from root repo folder and rename it to `FrameworkName.podspec.ejs`.
		- Change field to `s.version = '<%= version_id %>'`.
		- Change field to `s.source = { :git => 'https://github.com/applicaster/AppleApplicasterFrameworks.git', :tag => '<%= new_tag %>' }`

- Go to Framework's root folder and call `pod install`.
	- Cocoapods will generate `FrameworkName`
	- Open it make sure `FrameworkName` scheme is share and build and start unit tests.
- Open `README.md.ejs` in the root of the repo.
	- Add new framework under `# Frameworks List` title with format `#### Framework readable name: *<%= framework_id %>*`. In automation where `framework_id` will be populated value `version_id` from the `FrameworksData.plist`
		- Add description.
		- Add link to generated documentation.
		- Example:
		```swift
	        # Frameworks List

            #### ZappCore: <%= ZappCore %>
            - **Description:** Contain plugin protocols, helper methods that can be used by any Zapp plugin or framework
            - [**Documentation**](https://applicaster.github.io/AppleApplicasterFrameworks/ZappCore/index.html)
		```
- Final check of you framework.
	- Go to root Framework's folder and call in terminal `node Scripts/validateExistingFrameworks.js` It will check if you have all `folders` and `FrameworksData.plist` defined properly.
	- Make sure that generated `xcworkspace` of your `Framework` build and start unit test of your framework's scheme.
	- Templates are ready.
	- Readme documentation added in the `README.md.ejs` file
- Push code and create PR. Fill PR template.
- After review merge code.

**Create Zapp Plugin**

- Create branch `new_framework_name`

- Use [Folder Structure](#file_folder-folder-structure) article to check expected your framework folder structure.

- Open [FrameworksData.plist](#pencil2-frameworksData.plist) file in the root of your repo:
	- Add new value dictionary value. As a key use your `framework_id`
	- Inside your dictionary add key `version_id` value `version number` based on `major/minor/bug` `1.0.0` convention.
	- Add key `plugin` with value `true`.
- Open `Frameworks/Plugins` folder in Root of the repo and create with `plugin_id` as folder name. In future mention of this folder will be called as plugin root folder

- Create `Files` folder in your framework's root folder
	- Create folder `iOS` if you have files relevant only for iOS
	- Create folder `tvOS` if you have files relevant only for tvOS
	- Create folder `Universal` If you have universal file for iOS and tvOS
	- Note: single framework can have all three types of folders if it supports `ios` and `tvos`.
	- Create `src` folder if you need java script files.
	- Create folder `Tests` for unit tests.
	- Add file `package.json` to defined your plugin as npm dependancy.
		- Example:
		```JSON
   		 {
              "name": "@applicaster/quick-brick-google-ima-client",
              "version": "0.5.3",
              "description": "",
              "main": "src/index.js",
              "scripts": {
                "test": "echo \"Error: no test specified\" && exit 1"
              },
              "files": [
                "tvos",
                "ios",
                "Universal",
                "src",
                "ZappGoogleInteractiveMediaAds.podspec"
              ],
              "repository": {
                "type": "git",
                "url": "git+https://github.com/applicaster/AppleApplicasterFrameworks"
              },
              "keywords": [],
              "author": "",
              "license": "ISC",
              "bugs": {
                "url": "https://github.com/applicaster/AppleApplicasterFrameworks"
              },
              "homepage": "https://github.com/applicaster/AppleApplicasterFrameworks"
   		 }
	```
	- Add file `podspec` to define cocoapods denendancy
        - `podspec` name must be same name as the `plugin_id`.  Example: `MyFramework.podspec`
        - Prepare `podspec` based of your plugins needs.
        - Add `test_spec` and define path to your `Unit test files`
        - If framework supports `tvos` and `ios` dependency must be defined in same `podspec` file.
        - Example
        ```ruby
        Pod::Spec.new do |s|
        s.name = "ZappGoogleInteractiveMediaAds"
        s.version = '0.5.3'
        s.swift_versions = '5.1'

        s.summary = "ZappGoogleInteractiveMediaAds"
        s.description = "This plugin allow to add Google Interactive Media Ads to supported players."
        s.homepage = 'https://github.com/applicaster/AppleApplicasterFrameworks.git'
        s.license = 'Appache 2.0'
        s.author = "Applicaster LTD."
        s.source = {
             :git => 'https://github.com/applicaster/AppleApplicasterFrameworks.git',
             :tag => "2020.1.13.22-1-8"
      }

        s.ios.deployment_target = '10.0'
        s.tvos.deployment_target = '10.0'
        s.tvos.vendored_frameworks = 'tvOS/GoogleInteractiveMediaAds.framework'
        s.tvos.preserve_paths = 'tvOS/GoogleInteractiveMediaAds.framework'

        s.ios.source_files  = 'Universal/**/*.swift'
        s.tvos.source_files  = ['Universal/**/*.swift',
                                'tvOS/**/*.swift'
        ]
        s.ios.dependency 'GoogleAds-IMA-iOS-SDK', '= 3.11.1'

        s.dependency 'ZappCore'

        s.xcconfig = { 'ENABLE_BITCODE' => 'YES',
                                'OTHER_LDFLAGS' => '$(inherited)  -framework "GoogleInteractiveMediaAds"',
                                'LIBRARY_SEARCH_PATHS' => '$(inherited) "${PODS_ROOT}"/**',
                                'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
                                'ENABLE_TESTABILITY' => 'YES',
                                'OTHER_CFLAGS'  => '-fembed-bitcode',
                                'FRAMEWORK_SEARCH_PATHS' => '/Applications/Xcode.app/Contents/Developer/Library/Frameworks'
                                 }

        s.test_spec 'UnitTests' do |sp|
            sp.source_files = 'Tests/**'
        end
    end
            ```

- Create `Podfile`[cocoapods](https://cocoapods.org) dependecy and configure it for the project in Framework's root folder.
	- In the `podfile` define all dependancy that may needed for your framework.
	- Define your framework as develement pod with `testspecs`
	- Make sure that `share_schemes_for_development_pods` will be added, it export `cocoapods` schemes from xsworkspace.
	- Note: this Podile will be used by automation to unit test your framework and generare jazzy docs
	- Example:
	```ruby
   source 'https://cdn.cocoapods.org/'
    platform :ios, '10.0'
    install! 'cocoapods', :share_schemes_for_development_pods => true
    project '../../../FrameworksApp/FrameworksApp.xcodeproj'

        pre_install do |installer|
            # workaround for https://github.com/CocoaPods/CocoaPods/issues/3289
            Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
        end

        target 'FrameworksApp' do
          supports_swift_versions '5.1'
          use_frameworks!
          pod 'ZappGoogleInteractiveMediaAds', :path => 'Files/ZappGoogleInteractiveMediaAds.podspec', :testspecs => ['UnitTests']
          pod 'ZappCore', :path => '../../../ZappCore.podspec'

          target 'FrameworksAppTests' do
            inherit! :search_paths
          end

        end

        post_install do |installer|
          installer.pods_project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
                  config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
              end
          end
        end
	```
- Create file `.jazzy.yaml` with configuration of [Jazzy documentation](https://github.com/realm/jazzy). Details configure [Jazzy](https://github.com/realm/jazzy) can be founded in [Jazzy Repo](https://github.com/realm/jazzy) or copied from existing frameworks.
	- Make sure that you define in `xcode arguments` your framework scheme.
    - Example:
        ```swift
        module: ZappFirebaseAnalytics
        module_version: "0.2.0"

        author: "Applicaster ltd."
        copyright: "© 2019 [Applicaster ltd.](http://bustoutsolutions.com) under [Appache 2.0](https://github.com/applicaster/AppleApplicasterFrameworks/blob/master/LICENSE)."

        xcodebuild_arguments: ["-scheme", "ZappCore"]
        author_url: https://www.applicaster.com
        github_url: https://github.com/applicaster/AppleApplicasterFrameworks/tree/master/Frameworks/Plugins/Analytics/Firebase/ZappFirebaseAnalytics

        output: "../../../../../docs/ZappFirebaseAnalytics"
        clean: true
        min_acl: "private"
        sdk: [iphone, appletv]
        theme: jony
        ```
- Create `Templates` folder in your framework's root folder. In this folder you will be provided data for automated deployment. Templates files use structure of [ejs](https://ejs.co).
	- Copy the `.jazzy.yaml` file created before in path and rename it to `.jazzy.yaml.ejs`. Change field to `module_version: "<%= version_id %>"`.
	- Copy `FrameworkName.podspec` file created before from root repo folder and rename it to `FrameworkName.podspec.ejs`.
		- Change field to `s.version = '<%= version_id %>'`.
		- Change field to `s.source = { :git => 'https://github.com/applicaster/AppleApplicasterFrameworks.git', :tag => '<%= new_tag %>' }`
    - Create manifest file using [Zappifest](https://github.com/applicaster/zappifest) for `ios` if plugin support it. Rename it to `ios.json.ejs`
        - Change field to `"manifest_version": "<%= version_id %>"`
        - Change field to `:git => 'https://github.com/applicaster/AppleApplicasterFrameworks.git', :tag
    - Create manifest file using [Zappifest](https://github.com/applicaster/zappifest) for `tvos` if plugin support it. Rename it to `tvos.json.ejs`
        - Change field to `"manifest_version": "<%= version_id %>"`
        - Change field to `"FrameworkName": ":git => 'https://github.com/applicaster/AppleApplicasterFrameworks.git', :tag => '<%= new_tag %>'"`

- Go to Framework's root folder and call `pod install`.
	- Cocoapods will generate `PluginName`
	- Open it make sure `PluginName` scheme is share and build and start unit tests.
- Open `README.md.ejs` in the root of the repo.
	- Add new framework under `# Frameworks List` title with format `#### Framework readable name: *<%= framework_id %>*`. In automation where `framework_id` will be populated value `version_id` from the `FrameworksData.plist`
		- Find plugin type. Example `### Type: Analytics`
		- If type does not exist under section. `## Zapp Plugins` add new type `### Type: New Type`
		- Add new plugin title with format `#### Plugin readable name: <%= framework_id %>`.   Where `framework_id` must be a value defined in `FrameworksData.plist`
		- Add description.
		- Add link to generated documentation.
		- Add links to Zapp manifests.
		- Example:
		```swift
	        ### Type: Analytics

            #### Google Analytics: *<%= ZappGoogleAnalytics %>*
            - **Description:** Google Analytics provider, deliver passed analytics data to service [Google Analytics](https://analytics.google.com/)
            - [**Documentation**](https://applicaster.github.io/AppleApplicasterFrameworks/ZappGoogleAnalytics/index.html)
            - **Manifest:**
                - [iOS](https://zapp.applicaster.com/admin/plugin_versions?id=zapp_google_analytics&platform=ios)
                - [tvOS](https://zapp.applicaster.com/admin/plugin_versions?id=zapp_google_analytics&platform=tvos)
		```
- Final check of you framework.
	- Go to root Framework's folder and call in terminal `node Scripts/validateExistingFrameworks.js` It will check if you have all `folders` and `FrameworksData.plist` defined properly.
	- Make sure that generated `xcworkspace` of your `Framework` build and start unit test of your framework's scheme.
	- Manifest prepared
	- Templates are ready.
	- Readme documentation added in the `README.md.ejs` file
- Push code and create PR. Fill PR template.
- After review merge code.

## :page_with_curl: How to update existing framework

- Create branch `framework_name_update_version_id`
- Update framework code. Based on rules described in [creation new framework](#how-to-add-new-framework)
- Update version of your framework in `frameworksData.plist` based on `major/minor/bug` `1.0.0` convension.
- Push code and create PR. Fill PR template.
- After review merge code.

## :mortar_board: How it works?

- All of the automation scripts are contained inside of the `Scripts` folder
- Automation contains two main scripts.
	- Validate Frameworks: It checks if defined frameworks in `FrameworksData.plist` has all files that needed to support framework. This script is called on each commit. If validation failed CI build will be finished with fail
	- Publish Frameworks: Script checks if framework needs to be published. Previous frameworks data saved in `.versions_automation.json`. It compares new data in `FrameworksData.plist` and  `.versions_automation.json` all diffs in frameworks or not existing will be published. This script is called on `master` branch only. Script is will do the following:
		- Get current date in format `2020.15.0.20-1-6` This string will be used as `git tag`
		- Go throught all templates that are in [ejs](https://ejs.co) format for frameworks that need to be updated. It updates to a new `version number` in `ejs` key `<%= version_id %>` and `git tag` in `ejs` key` <%= new_tag %>`.

		** Template List**

		| File name | Description | Zapp plugins only |
        |--------|--------|--------|
        | .jazzy.yaml.ejs |Documentation generator templte|NO|
        | framework_name.podspec.ejs |Cocoapods podspec template|NO|
        | ios.json.ejs |iOS Zapp plugin manifest template|YES|
        | tvos.json.ejs |tvOS Zapp plugin manifest template|YES|

        - Generate documentation for framework and saves it to `docs` folder.
        - Srart Unit tests.
        - Upload manifest to Zapp with [Zappifest](https://github.com/applicaster/zappifest) (Zapp plugins only).
        - Upload npm dependencies (Zapp plugins only)
        - Update Frameworks list template `Readme.md.ejs` to update latest availible framework version for documentation.
        - Update file `.versions_automation.json` with latest changes if format `{framework_name:version_id}`
        - Commit, push and create tag git repo
	- Push Framework to [Cocoapods-Applicaster public repo](https://github.com/applicaster/CocoaPods) (Frameworks only )
