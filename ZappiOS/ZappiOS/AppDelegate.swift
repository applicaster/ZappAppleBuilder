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

    public func application(_ application: UIApplication,
                            didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Anton123 I am here \(userInfo)")
        if let rootController = rootController,
            rootController.appReadyForUse == false {
            remoteUserInfo = userInfo
        } else if let userInfo = remoteUserInfo,
            let urlString = getLink(userInfo: userInfo),
            let url = URL(string: urlString) {
            remoteUserInfo = nil
            UIApplication.shared.open(url,
                                      options: [:],
                                      completionHandler: nil)
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }

    public func applicationWillResignActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    public func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        rootController?.pluginsManager.push.registerDeviceToken(data: deviceToken)
    }

    public func application(_ application: UIApplication,
                            didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
}
