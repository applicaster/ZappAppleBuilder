//
//  AppDelegateBase.swift
//  ZappApple
//
//  Created by Anton Kononenko on 1/8/20.
//  Copyright © 2020 Applicaster Ltd.. All rights reserved.
//

import Foundation

import React
import UIKit
import ZappApple
import ZappCore
public class AppDelegateBase: UIResponder, UIApplicationDelegate, FacadeConnectorProtocol, AppDelegateProtocol {
    public var connectorInstance: FacadeConnector? {
        return rootController?.facadeConnector
    }

    public var window: UIWindow?
    var urlSchemeUrl: URL?
    var urlSchemeOptions: [UIApplication.OpenURLOptionsKey: Any]?
    var localNotificatioResponse: UNNotificationResponse?

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
        // Override point for customization after application launch.
        self.launchOptions = launchOptions

        UNUserNotificationCenter.current().delegate = self
//        UNUserNotificationCenter.current().setNotificationCategories([UNNotificationCategory(identifier: "Default-Category",
//                                                                                             actions: [UNNotificationAction(identifier: "Test",
//                                                                                                                            title: "Test",
//                                                                                                                            options: [])],
//                                                                                             intentIdentifiers: [],
//                                                                                             options: [.customDismissAction])])
        let defaultStorageParams = storagesDefaultParams()
        StorageInitialization.initializeDefaultValues(sessionStorage: defaultStorageParams,
                                                      localStorage: defaultStorageParams)
        FirebaseHandler.configure()
        rootController = RootController()
        rootController?.appDelegate = self

        return true
    }

    public func handleDelayedEventsIfNeeded() {
        if isApplicationReady {
            if let url = urlSchemeUrl {
                _ = application(UIApplication.shared,
                                open: url,
                                options: urlSchemeOptions ?? [:])
            }
            if let localNotificatioResponse = localNotificatioResponse {
                userNotificationCenter(UNUserNotificationCenter.current(), didReceive: localNotificatioResponse) {
                    // do nothing special on completion
                }
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
        return [ZappStorageKeys.bundleIdentifier: kBundleIdentifier,
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
                ZappStorageKeys.deviceType: kDeviceTarget,
                ZappStorageKeys.deviceWidth: "\(UIScreen.main.bounds.width)",
                ZappStorageKeys.deviceHeight: "\(UIScreen.main.bounds.height)",
                ZappStorageKeys.reactNativePackagerRoot: kReactNativePackagerRoot ?? "",
                ZappStorageKeys.riversConfigurationId: kRiversConfigurationId,
                ZappStorageKeys.sdkVersion: kSdkVersion,
                ZappStorageKeys.isRtl: kIsRTL ? "true" : "false",
                ZappStorageKeys.assetsUrl: kAssetsUrl,
                ZappStorageKeys.stylesUrl: kStylesUrl,
                ZappStorageKeys.remoteConfigurationUrl: kRemoteConfigurationUrl,
                ZappStorageKeys.pluginConfigurationUrl: kPluginConfigurationsUrl,
                ZappStorageKeys.riversUrl: kRiversUrl,
        ]
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
        if isApplicationReady {
            urlSchemeUrl = nil
            urlSchemeOptions = nil
            rootController?.pluginsManager.analytics.trackURL(url: url)

            if UrlSchemeHandler.handle(with: rootController,
                                       application: app,
                                       open: url,
                                       options: options) {
                return true
            } else {
                return uiLayerPluginDelegate?.applicationDelegate?.application?(app,
                                                                                open: url,
                                                                                options: options) ?? true
            }

        } else {
            urlSchemeUrl = url
            urlSchemeOptions = options
            return true
        }
    }
}
