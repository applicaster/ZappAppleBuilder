//
//  AppDelegateBase.swift
//  ZappApple
//
//  Created by Anton Kononenko on 1/8/20.
//  Copyright © 2020 Applicaster Ltd.. All rights reserved.
//

import Foundation

import AVKit
import DeviceKit
import React
import UIKit
import XrayLogger
import ZappApple
import ZappCore

public class AppDelegateBase: AppDelegateExtandable, UIApplicationDelegate, FacadeConnectorProtocol, AppDelegateProtocol {
    lazy var logger = Logger.getLogger(for: AppDelegateLogs.subsystem)

    public var connectorInstance: FacadeConnector? {
        return rootController?.facadeConnector
    }

    public var window: UIWindow?
    var urlSchemeUrl: URL?
    var urlSchemeOptions: [UIApplication.OpenURLOptionsKey: Any]?

    lazy var uiLayerPlugin = {
        rootController?.userInterfaceLayer
    }()

    public lazy var uiLayerPluginDelegate = {
        uiLayerPlugin as? UserInterfaceLayerDelegate
    }()

    public var rootController: RootController?

    public var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    public var remoteUserInfo: [AnyHashable: Any]?

    public func application(_ application: UIApplication,
                            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.launchOptions = launchOptions
        prepareAudioSession()

        rootController = RootController()
        rootController?.appDelegate = self

        let defaultStorageParams = storagesDefaultParams()

        prepareLogger(defaultContext: defaultStorageParams)
        logger?.debugLog(template: AppDelegateLogs.didFinishLaunching,
                         data: ["launch_options": launchOptions.debugDescription])

        StorageInitialization.initializeDefaultValues(sessionStorage: defaultStorageParams,
                                                      localStorage: defaultStorageParams)
        rootController?.reloadApplication()

        FirebaseHandler.configure()

        return true
    }

    func prepareLogger(defaultContext: [String: Any]) {
        let rootLogger = Logger.getLogger()
        rootLogger?.context = defaultContext

        let logsLogger = Logger.getLogger(for: LoggerLogs.subsystem)
        logsLogger?.verboseLog(template: LoggerLogs.loggerIntialized)
    }

    func prepareAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback,
                                         mode: .moviePlayback,
                                         options: [])
        } catch {
            logger?.errorLog(message: "Setting category to AVAudioSessionCategoryPlayback failed. error:\(error)")
        }
    }

    public func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        logger?.debugLog(template: AppDelegateLogs.applicationBecomeActive,
                         data: ["icon_badge_number": "0"])

        SettingsBundleHelper.handleChangesIfNeeded()
    }

    public func handleDelayedEventsIfNeeded() {
        if isApplicationReady {
            if let url = urlSchemeUrl {
                logger?.debugLog(template: AppDelegateLogs.handleDelayedURLScheme,
                                 data: ["url": url.absoluteString])
                _ = application(UIApplication.shared,
                                open: url,
                                options: urlSchemeOptions ?? [:])
            }
        }
    }

    public func application(_ application: UIApplication,
                            continue userActivity: NSUserActivity,
                            restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // implement continue user activity hooks flow or fallback to react
        if rootController?.pluginsManager.hasHooksForContinuingUserActivity() == true {
            rootController?.pluginsManager.hookOnContinuingUserActivity(userActivity: userActivity,
                                                                        hooksPlugins: nil,
                                                                        completion: {
                                                                            // do nothing special on completion
                                                                        })
            return true
        } else {
            return uiLayerPluginDelegate?.applicationDelegate?.application?(application,
                                                                            continue: userActivity,
                                                                            restorationHandler: restorationHandler) ?? true
        }
    }

    func storagesDefaultParams() -> [String: String] {
        var platform = ZappStorageKeys.iOS
        #if os(tvOS)
            platform = ZappStorageKeys.tvOS
        #endif
        let retVal = [ZappStorageKeys.bundleIdentifier: kBundleIdentifier,
                      ZappStorageKeys.applicationName: kAppName,
                      ZappStorageKeys.versionId: kVersionId,
                      ZappStorageKeys.versionName: kVersionName,
                      ZappStorageKeys.accountId: kAPAccountId,
                      ZappStorageKeys.accountsAccountId: kAccountsAccountID,
                      ZappStorageKeys.platform: platform,
                      ZappStorageKeys.buildVersion: kBuildVersion,
                      ZappStorageKeys.apiSecretKey: kApplicasterSecretKey,
                      ZappStorageKeys.broadcasterId: kBroadcasterId,
                      ZappStorageKeys.bucketId: kBucketId,
                      ZappStorageKeys.uuid: UUIDManager.deviceID,
                      ZappStorageKeys.languageCode: NSLocale.current.languageCode ?? "",
                      ZappStorageKeys.regionCode: NSLocale.current.regionCode ?? "",
                      ZappStorageKeys.countryCode: (Locale.current as NSLocale).object(forKey: .countryCode) as? String ?? "",
                      ZappStorageKeys.currencySymbol: NSLocale.current.currencySymbol ?? "",
                      ZappStorageKeys.deviceType: kDeviceTarget,
                      ZappStorageKeys.deviceWidth: "\(UIScreen.main.bounds.width)",
                      ZappStorageKeys.deviceHeight: "\(UIScreen.main.bounds.height)",
                      ZappStorageKeys.deviceModel: Device.current.description,
                      ZappStorageKeys.deviceMake: Device.current.model ?? UIDevice.current.model,
                      ZappStorageKeys.reactNativePackagerRoot: kReactNativePackagerRoot ?? "",
                      ZappStorageKeys.riversConfigurationId: kRiversConfigurationId,
                      ZappStorageKeys.sdkVersion: kSdkVersion,
                      ZappStorageKeys.isRtl: kIsRTL ? "true" : "false",
                      ZappStorageKeys.assetsUrl: kAssetsUrl.replaceUrlHost(to: FeaturesCustomization.s3Hostname()),
                      ZappStorageKeys.stylesUrl: kStylesUrl.replaceUrlHost(to: FeaturesCustomization.s3Hostname()),
                      ZappStorageKeys.remoteConfigurationUrl: kRemoteConfigurationUrl.replaceUrlHost(to: FeaturesCustomization.s3Hostname()),
                      ZappStorageKeys.pluginConfigurationUrl: kPluginConfigurationsUrl.replaceUrlHost(to: FeaturesCustomization.s3Hostname()),
                      ZappStorageKeys.riversUrl: kRiversUrl.replaceUrlHost(to: FeaturesCustomization.s3Hostname()),
                      ZappStorageKeys.appFamilyId: kAppFamilyId,
                      ZappStorageKeys.store: kStore,
                      ZappStorageKeys.applicationEnvironment: FeaturesCustomization.isDebugEnvironment() ? "true" : "false",
                      ZappStorageKeys.isTabletPortrait: FeaturesCustomization.isTabletPortrait() ? "true" : "false",
        ]

        return retVal
    }

    var isApplicationReady: Bool {
        if let rootController = rootController,
           rootController.appReadyForUse == false {
            return false
        }
        return true
    }

    public func application(_ app: UIApplication,
                            open url: URL,
                            options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let data = ["url": url.absoluteString,
                    "options": options] as [String: Any]
        if isApplicationReady {
            urlSchemeUrl = nil
            urlSchemeOptions = nil
            rootController?.pluginsManager.analytics.trackURL(url: url)
            logger?.debugLog(template: AppDelegateLogs.handleURLScheme,
                             data: data)
            if UrlSchemeHandler.handle(with: rootController,
                                       application: app,
                                       open: url,
                                       options: options) {
                return true
            } else {
                logger?.debugLog(template: AppDelegateLogs.handleURLSchemeDelegate,
                                 data: data)
                return uiLayerPluginDelegate?.applicationDelegate?.application?(app,
                                                                                open: url,
                                                                                options: options) ?? true
            }

        } else {
            urlSchemeUrl = url
            urlSchemeOptions = options
            logger?.debugLog(template: AppDelegateLogs.delayURLScheme,
                             data: data)
            return true
        }
    }
}
