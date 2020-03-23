//
//  AppDelegate+UNUserNotificationCenterDelegate.swift
//  ZappApple
//
//  Created by Anton Kononenko on 3/12/20.
//  Copyright © 2020 Applicaster Ltd. All rights reserved.
//

import Foundation
import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        uiLayerPluginDelegate?.userNotificationCenterDelegate?.userNotificationCenter?(center,
                                                                                       willPresent: notification,
                                                                                       withCompletionHandler: completionHandler)
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        if isApplicationReady {
            localNotificatioResponse = nil
            NotificationCenter.default.post(name: .kLocalNotificationRecievedNotification,
                                            object: response)
            uiLayerPluginDelegate?.userNotificationCenterDelegate?.userNotificationCenter?(center,
                                                                                           didReceive: response,
                                                                                           withCompletionHandler: completionHandler)
        } else {
            localNotificatioResponse = response
            completionHandler()
        }
    }
}
