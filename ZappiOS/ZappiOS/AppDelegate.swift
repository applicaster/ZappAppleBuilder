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
    var distributionHandler: MsAppCenterDistributionHandler?

    override func application(_ application: UIApplication,
                              didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let retVal = super.application(application,
                                       didFinishLaunchingWithOptions: launchOptions)
        // Init ms app center distribution from app level
        distributionHandler = MsAppCenterDistributionHandler()
        distributionHandler?.configure()

        return retVal
    }

    public override func handleDelayedEventsIfNeeded() {
        super.handleDelayedEventsIfNeeded()
        if let rootController = rootController,
            rootController.appReadyForUse,
            let remoteUserInfo = remoteUserInfo {
            application(UIApplication.shared,
                        didReceiveRemoteNotification: remoteUserInfo) { _ in }
        }
    }

    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
    }

    public func application(_ application: UIApplication,
                            didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let rootController = rootController,
            rootController.appReadyForUse == false {
            remoteUserInfo = userInfo
            completionHandler(UIBackgroundFetchResult.newData)
        } else {
            uiLayerPluginApplicationDelegate?.applicationDelegate?.application?(application,
                                                                                   didReceiveRemoteNotification: userInfo,
                                                                                   fetchCompletionHandler: completionHandler)
            remoteUserInfo = nil

        }
        //TODO: Pass logic
    }

    public func applicationWillResignActive(_ application: UIApplication) {
        uiLayerPluginApplicationDelegate?.applicationDelegate?.applicationWillResignActive?(application)
    }

    public func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        rootController?.pluginsManager.push.registerDeviceToken(data: deviceToken)
        uiLayerPluginApplicationDelegate?.applicationDelegate?.application?(application,
                                                                            didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

    public func application(_ application: UIApplication,
                            didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint(error.localizedDescription)
        uiLayerPluginApplicationDelegate?.applicationDelegate?.application?(application,
                                                                            didFailToRegisterForRemoteNotificationsWithError: error)
    }
}
