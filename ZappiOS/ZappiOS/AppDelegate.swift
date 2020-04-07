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

@UIApplicationMain
class AppDelegate: AppDelegateBase {
    var appCenterHandler = MsAppCenterHandler()

    var localNotificatioResponse: UNNotificationResponse?

    override func application(_ application: UIApplication,
                              didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let retVal = super.application(application,
                                       didFinishLaunchingWithOptions: launchOptions)

        UNUserNotificationCenter.current().delegate = self

        // Init ms app center
        appCenterHandler.configure()

        return retVal
    }

    public override func handleDelayedEventsIfNeeded() {
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
}
