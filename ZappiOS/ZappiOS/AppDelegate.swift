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

    override func application(_ application: UIApplication,
                              didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Init ms app center
        appCenterHandler.configure()
        UNUserNotificationCenter.current().delegate = self
        let retVal = super.application(application,
                                       didFinishLaunchingWithOptions: launchOptions)

        initializeFlipper(with: application)
        return retVal
    }

    override public func handleDelayedEventsIfNeeded() {
        super.handleDelayedEventsIfNeeded()
        if isApplicationReady,
            let remoteUserInfo = remoteUserInfo {
            application(UIApplication.shared,
                        didReceiveRemoteNotification: remoteUserInfo) { _ in }
        }
        if let localNotificatioResponse = localNotificatioResponse {
            userNotificationCenter(UNUserNotificationCenter.current(),
                                   didReceive: localNotificatioResponse) {
                // do nothing special on completion
            }
        }
    }

    public func application(_ application: UIApplication,
                            didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
    }

    public func application(_ application: UIApplication,
                            didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if isApplicationReady {
            remoteUserInfo = nil
            uiLayerPluginDelegate?.applicationDelegate?.application?(application,
                                                                     didReceiveRemoteNotification: userInfo,
                                                                     fetchCompletionHandler: completionHandler)

        } else {
            remoteUserInfo = userInfo
            completionHandler(UIBackgroundFetchResult.newData)
        }
    }

    public func applicationWillResignActive(_ application: UIApplication) {
        uiLayerPluginDelegate?.applicationDelegate?.applicationWillResignActive?(application)
    }

    public func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        rootController?.pluginsManager.push.registerDeviceToken(data: deviceToken)
        uiLayerPluginDelegate?.applicationDelegate?.application?(application,
                                                                 didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

    public func application(_ application: UIApplication,
                            didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint(error.localizedDescription)
        uiLayerPluginDelegate?.applicationDelegate?.application?(application,
                                                                 didFailToRegisterForRemoteNotificationsWithError: error)
    }

    private func initializeFlipper(with application: UIApplication) {
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
            #endif
        #endif
    }

    func application(_ application: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        guard let urlString = shortcutItem.userInfo?["url"] as? String,
            let url = URL(string: urlString) else {
            return
        }

        if UrlSchemeHandler.handle(with: rootController,
                                   application: application,
                                   open: url) {
        }
    }
}
