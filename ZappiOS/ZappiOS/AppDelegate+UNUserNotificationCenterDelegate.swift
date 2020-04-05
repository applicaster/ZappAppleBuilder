//
//  AppDelegate+UNUserNotificationCenterDelegate.swift
//  ZappApple
//
//  Created by Anton Kononenko on 3/12/20.
//  Copyright © 2020 Applicaster Ltd. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

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
            localNotificationResponse = nil
            NotificationCenter.default.post(name: .kLocalNotificationRecievedNotification,
                                            object: response)
            
            updateApplicationBadgeNumber(with: response.notification.request.content)
            
            uiLayerPluginDelegate?.userNotificationCenterDelegate?.userNotificationCenter?(center,
                                                                                           didReceive: response,
                                                                                           withCompletionHandler: completionHandler)
        } else {
            localNotificationResponse = response
            completionHandler()
        }
    }
    
    fileprivate func updateApplicationBadgeNumber(with content: UNNotificationContent) {
        //update badge number by adding notification badge to application current badge
        var badgeNumber = UIApplication.shared.applicationIconBadgeNumber
        if let countToAdd = content.badge {
            badgeNumber += Int(truncating: countToAdd)
            UIApplication.shared.applicationIconBadgeNumber = badgeNumber
        }
    }
}
