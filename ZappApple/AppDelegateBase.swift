//
//  AppDelegateBase.swift
//  ZappApple
//
//  Created by Anton Kononenko on 1/8/20.
//  Copyright © 2020 Anton Kononenko. All rights reserved.
//

import Foundation

import React
import UIKit
import ZappApple
import ZappCore

public class AppDelegateBase: UIResponder, UIApplicationDelegate, FacadeConnectorProtocol, AppDelegateProtocol {
    public var connectorInstance: FacadeConnector? {
        return rootViewController?.facadeConnector
    }

    public var window: UIWindow?
    var urlSchemeUrl: URL?
    var urlSchemeOptions: [UIApplication.OpenURLOptionsKey: Any]?

    lazy var uiLayerPlugin = {
        rootViewController?.userInterfaceLayer
    }()

    public lazy var uiLayerPluginApplicationDelegate = {
        uiLayerPlugin as? UserInterfaceLayerApplicationDelegate
    }()

    public var rootViewController: RootViewController?

    public var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    public var remoteUserInfo: [AnyHashable: Any]?

    public func application(_ application: UIApplication,
                            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.launchOptions = launchOptions
        rootViewController = window?.rootViewController as? RootViewController
        rootViewController?.appDelegate = self

        let defaultStorageParams = storagesDefaultParams()
        StorageInitialization.initializeDefaultValues(sessionStorage: defaultStorageParams,
                                                      localStorage: defaultStorageParams)
        return true
    }

    public func handleDelayedUrlSchemeCallIfNeeded() {
        if let rootViewController = rootViewController,
            rootViewController.appReadyForUse,
            let url = urlSchemeUrl {
            _ = application(UIApplication.shared,
                            open: url,
                            options: urlSchemeOptions ?? [:])
        }
    }

    public func handleDelayedPushNotificationIfNeeded() {
        if let rootViewController = rootViewController,
            rootViewController.appReadyForUse,
            let remoteUserInfo = remoteUserInfo {
            application(UIApplication.shared,
                        didReceiveRemoteNotification: remoteUserInfo) { _ in }
        }
    }

    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        func getLink(userInfo: [AnyHashable: Any]) -> String? {
            if let url = userInfo["url"] as? String {
                return url
            } else if let url = userInfo["^d"] as? String {
                return url
            } else if let url = userInfo["^u"] as? String {
                return url
            }
            return nil
        }

        if let rootViewController = rootViewController,
            rootViewController.appReadyForUse == false {
            remoteUserInfo = userInfo
        } else if let userInfo = remoteUserInfo,
            let urlString = getLink(userInfo: userInfo),
            let url = URL(string: urlString) {
            remoteUserInfo = nil
            UIApplication.shared.open(url,
                                      options: [:],
                                      completionHandler: nil)
        }
    }

    public func applicationWillResignActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    public func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        rootViewController?.identityClient.registerForPushNotification(with: deviceToken)
        rootViewController?.pluginsManager.push.registerDeviceToken(data: deviceToken)
    }

    public func application(_ application: UIApplication,
                            didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint(error.localizedDescription)
    }

    public func application(_ app: UIApplication,
                            open url: URL,
                            options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if let rootViewController = rootViewController,
            rootViewController.appReadyForUse == false {
            urlSchemeUrl = url
            urlSchemeOptions = options
            return true
        } else {
            urlSchemeUrl = nil
            urlSchemeOptions = nil
            return uiLayerPluginApplicationDelegate?.applicationDelegate?.application?(app,
                                                                                       open: url,
                                                                                       options: options) ?? true
        }
    }

    public func application(_ application: UIApplication,
                            continue userActivity: NSUserActivity,
                            restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return uiLayerPluginApplicationDelegate?.applicationDelegate?.application?(application, continue: userActivity, restorationHandler: restorationHandler) ?? true
    }

    func storagesDefaultParams() -> [String: String] {
        return [ZappStorageKeys.bundleIdentifier: kBundleIdentifier,
                ZappStorageKeys.applicationName: kAppName,
                ZappStorageKeys.versionId: kVersionId,
                ZappStorageKeys.versionName: kVersionName,
                ZappStorageKeys.accountId: kAPAccountId,
                ZappStorageKeys.accountsAccountId: kAccountsAccountID,
                ZappStorageKeys.platform: ZappStorageKeys.iOS,
                ZappStorageKeys.buildVersion: kBuildVersion,
                ZappStorageKeys.apiSecretKey: kApplicasterSecretKey,
                ZappStorageKeys.broadcasterId: kBroadcasterId,
                ZappStorageKeys.bucketId: kBucketId,
                ZappStorageKeys.uuid: IdentityClient.deviceID ?? "",
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
}
