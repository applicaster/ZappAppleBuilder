//
//  AppDelegate.swift
//  ZappApple
//
//  Created by Anton Kononenko on 11/13/18.
//  Copyright © 2018 Anton Kononenko. All rights reserved.
//

import QuickBrickApple
import React
import UIKit
import ZappApple
import ZappCore

#if DEBUG && targetEnvironment(simulator)
    #if FB_SONARKIT_ENABLED
        import flipper_plugin_react_native_performance
        import FlipperKit
    #endif
#endif

@UIApplicationMain
class AppDelegate: AppDelegateBase {
    var appCenterHandler = MsAppCenterHandler()

    var localNotificatioResponse: UNNotificationResponse?
    var shortcutItem: UIApplicationShortcutItem?

    override func application(_ application: UIApplication,
                              didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Clear all shortcuts during app start, to make plugin that may be dissable will not add any one
        UIApplication.shared.shortcutItems = []
        logger?.debugLog(template: AppDelegateLogs.didFinishLaunchingClearShortcuts)

        appCenterHandler.configure()
        UNUserNotificationCenter.current().delegate = self
        let retVal = super.application(application,
                                       didFinishLaunchingWithOptions: launchOptions)

        let flipperStarted = initializeFlipper(with: application)
        logger?.debugLog(template: AppDelegateLogs.didFinishLaunchingFlipper,
                         data: ["flipper_started": flipperStarted ? true : false])
        return retVal
    }

    override public func handleDelayedEventsIfNeeded() {
        super.handleDelayedEventsIfNeeded()
        if isApplicationReady,
           let remoteUserInfo = remoteUserInfo {
            logger?.debugLog(template: AppDelegateLogs.handleDelayedRemoteUserInfo,
                             data: ["remote_info": remoteUserInfo])

            application(UIApplication.shared,
                        didReceiveRemoteNotification: remoteUserInfo) { _ in }
        }
        if let localNotificatioResponse = localNotificatioResponse {
            logger?.debugLog(template: AppDelegateLogs.handleDelayedLocalNotification,
                             data: ["identifier": localNotificatioResponse.notification.request.identifier,
                                    "date": localNotificatioResponse.notification.date.debugDescription,
                                    "user_info": localNotificatioResponse.notification.request.content.userInfo])
            userNotificationCenter(UNUserNotificationCenter.current(),
                                   didReceive: localNotificatioResponse) {
                // do nothing special on completion
            }
        }

        if let shortcutItem = shortcutItem {
            logger?.debugLog(template: AppDelegateLogs.handleDelayedShortcut,
                             data: ["type": shortcutItem.type,
                                    "user_info": shortcutItem.userInfo.debugDescription])
            application(UIApplication.shared, performActionFor: shortcutItem, completionHandler: { _ in
                // do nothing special on completion
            })
        }
    }

    public func application(_ application: UIApplication,
                            didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
    }

    public func application(_ application: UIApplication,
                            didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        logger?.debugLog(template: AppDelegateLogs.handleRemoteNotificaton,
                         data: ["user_info": userInfo])

        #if os(iOS)
            // Skip app presentation for silent push notification
            guard handleSilentRemoteNotification(userInfo, fetchCompletionHandler: completionHandler) == false else {
                return
            }
        #endif

        if isApplicationReady {
            remoteUserInfo = nil
            logger?.debugLog(template: AppDelegateLogs.handleRemoteNotificatonDelegate,
                             data: ["user_info": userInfo])
            uiLayerPluginDelegate?.applicationDelegate?.application?(application,
                                                                     didReceiveRemoteNotification: userInfo,
                                                                     fetchCompletionHandler: completionHandler)

        } else {
            logger?.debugLog(template: AppDelegateLogs.delayRemoteNotificaton,
                             data: ["user_info": userInfo])
            remoteUserInfo = userInfo
            completionHandler(UIBackgroundFetchResult.newData)
        }
    }

    public func applicationWillEnterForeground(_ application: UIApplication) {
        SettingsBundleHelper.handleChangesIfNeeded()
    }

    public func applicationWillResignActive(_ application: UIApplication) {
        logger?.verboseLog(template: AppDelegateLogs.applicationWillResignActive)
        uiLayerPluginDelegate?.applicationDelegate?.applicationWillResignActive?(application)
    }

    public func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenAsString = String(decoding: deviceToken, as: UTF8.self)
        logger?.verboseLog(template: AppDelegateLogs.applicationDidRegisterRemoteNotification,
                           data: ["device_token": deviceTokenAsString])
        rootController?.pluginsManager.push.registerDeviceToken(data: deviceToken)
        uiLayerPluginDelegate?.applicationDelegate?.application?(application,
                                                                 didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

    public func application(_ application: UIApplication,
                            didFailToRegisterForRemoteNotificationsWithError error: Error) {
        logger?.warningLog(template: AppDelegateLogs.applicationDidFailRegisterRemoteNotification,
                           data: ["error": error.localizedDescription])
        uiLayerPluginDelegate?.applicationDelegate?.application?(application,
                                                                 didFailToRegisterForRemoteNotificationsWithError: error)
    }

    private func initializeFlipper(with application: UIApplication) -> Bool {
        #if DEBUG && targetEnvironment(simulator)
            #if FB_SONARKIT_ENABLED
                let client = FlipperClient.shared()
                let layoutDescriptorMapper = SKDescriptorMapper(defaults: ())
                FlipperKitLayoutComponentKitSupport.setUpWith(layoutDescriptorMapper)
                client?.add(FlipperKitLayoutPlugin(rootNode: application, with: layoutDescriptorMapper!))
                client?.add(FKUserDefaultsPlugin(suiteName: nil))
                client?.add(FlipperKitReactPlugin())
                client?.add(FlipperKitNetworkPlugin(networkAdapter: SKIOSNetworkAdapter()))
                client?.add(FlipperReactPerformancePlugin.sharedInstance())
                client?.start()
                return true
            #endif
        #endif
        return false
    }

    func application(_ application: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        if isApplicationReady {
            var userInfoToShare: [String: Any] = [:]
            self.shortcutItem = nil
            let namespaceKey = "namespace"
            if let userInfo = shortcutItem.userInfo,
               let namespace = userInfo["namespace"] as? String {
                for current in userInfo {
                    if current.key == namespaceKey {
                        continue
                    }
                    if let string = current.value as? String {
                        userInfoToShare[current.key] = string
                        SessionStorage.sharedInstance.set(key: current.key,
                                                          value: string,
                                                          namespace: namespace)
                    }
                    if let number = current.value as? NSNumber {
                        userInfoToShare[current.key] = number.stringValue
                        SessionStorage.sharedInstance.set(key: current.key,
                                                          value: number.stringValue,
                                                          namespace: namespace)
                    }
                }
            }

            logger?.warningLog(template: AppDelegateLogs.handleShortcut,
                               data: ["user_info": userInfoToShare])

            completionHandler(true)

        } else {
            logger?.warningLog(template: AppDelegateLogs.delayShortcut,
                               data: ["type": shortcutItem.type,
                                      "user_info": shortcutItem.userInfo.debugDescription])
            self.shortcutItem = shortcutItem
        }
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIDevice.current.userInterfaceIdiom == .pad ? .all : .allButUpsideDown
    }
}
