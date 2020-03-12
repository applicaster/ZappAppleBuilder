//
//  AppDelegateBase+UNUserNotificationCenterDelegate.swift
//  ZappApple
//
//  Created by Anton Kononenko on 3/12/20.
//  Copyright © 2020 Applicaster Ltd. All rights reserved.
//

import Foundation
import UserNotifications

extension AppDelegateBase: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        rootController?.localNotificationManager.userNotificationCenter(center,
                                                                        willPresent: notification,
                                                                        withCompletionHandler: completionHandler)
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        if isApplicationReady {
            localNotificatioResponse = nil
            rootController?.localNotificationManager.userNotificationCenter(center,
                                                                            didReceive: response,
                                                                            withCompletionHandler: completionHandler)
        } else {
            localNotificatioResponse = response
            completionHandler()
        }
    }
}
