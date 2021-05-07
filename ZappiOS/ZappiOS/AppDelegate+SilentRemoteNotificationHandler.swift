//
//  AppDelegate+SilentRemoteNotificationHandler
//  ZappiOS
//
//  Created by Alex Zchut on 28/04/2021.
//  Copyright © 2021 Applicaster Ltd. All rights reserved.
//

import Foundation
import UIKit
import ZappApple
import ZappCore

extension AppDelegate {
    fileprivate struct Params {
        static let aps = "aps"
        static let contentAvailable = "content-available"
        static let eventId = "groupid"
        static let title = "title"
        static let subtitle = "subtitle"
        static let sound = "sound"
        static let image = "image"
        static let url = "url"
        static let presentationDelay = "delay"
        static let storageKey = "SilentRemoteNotificationEventIds"
    }

    func handleSilentRemoteNotification(_ userInfo: [AnyHashable: Any],
                                        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Bool {
        self.logger?.debugLog(template: AppDelegateLogs.handleSilentRemoteNotification,
                              data: ["user_info": userInfo])

        guard let aps = userInfo[Params.aps] as? [String: AnyObject],
              let contentAvailable = aps[Params.contentAvailable] as? Int,
              contentAvailable == 1 else {
            return false
        }

        if isNewEvent(userInfo),
           shouldPresentLocalNotification(for: userInfo) {
            presentLocalNotification(for: userInfo)
        }

        completionHandler(UIBackgroundFetchResult.newData)
        return true
    }

    fileprivate func isNewEvent(_ userInfo: [AnyHashable: Any]) -> Bool {
        var retValue = true
        guard let eventId = userInfo[Params.eventId] as? String else {
            return retValue
        }

        var proceededEvents = UserDefaults.standard.array(forKey: Params.storageKey) as? [String] ?? []
        if proceededEvents.contains(eventId) {
            retValue = false
        } else {
            proceededEvents.append(eventId)
            UserDefaults.standard.setValue(proceededEvents, forKey: Params.storageKey)
        }

        return retValue
    }

    fileprivate func shouldPresentLocalNotification(for userInfo: [AnyHashable: Any]) -> Bool {
        guard !string(for: Params.title, userInfo: userInfo).isEmpty else {
            return false
        }
        return true
    }

    fileprivate func presentLocalNotification(for userInfo: [AnyHashable: Any]) {
        let content = UNMutableNotificationContent()
        content.title = string(for: Params.title, userInfo: userInfo)
        content.subtitle = string(for: Params.subtitle, userInfo: userInfo)
        content.sound = sound(for: Params.sound, userInfo: userInfo)
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        content.userInfo = userInfo

        let identifier = UUID().uuidString
        let imageUrlString = string(for: Params.image, userInfo: userInfo)
        if !imageUrlString.isEmpty,
           let imageUrl = URL(string: imageUrlString) {
            do {
                if let data = try? Data(contentsOf: imageUrl),
                   let image = UIImage(data: data),
                   let url = image.getLocalUrl() {
                    let attachment = try UNNotificationAttachment(identifier: identifier,
                                                                  url: url,
                                                                  options: nil)
                    content.attachments = [attachment]
                }

            } catch {
                self.logger?.debugLog(template: AppDelegateLogs.handleSilentRemoteNotificationFailedToAddAttachment,
                                      data: ["user_info": userInfo])
            }
        }

        var presentationDelay:TimeInterval = 2
        if let presentationDelayString = userInfo[Params.presentationDelay] as? String,
           let presentationDelayInt = TimeInterval(presentationDelayString) {
            presentationDelay = presentationDelayInt
        }
        
        // show this notification in presentationDelay seconds value from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: presentationDelay, repeats: false)

        // create new request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        //log event
        self.logger?.debugLog(template: AppDelegateLogs.handleSilentRemoteNotificationPresentLocalPush,
                              data: ["user_info": userInfo])

        // add notification request
        UNUserNotificationCenter.current().add(request)
    }
    
    fileprivate func string(for key: String, userInfo: [AnyHashable: Any]) -> String {
        return userInfo[key] as? String ?? ""
    }
    
    fileprivate func sound(for key: String, userInfo: [AnyHashable: Any]) -> UNNotificationSound {
        let value = string(for: key, userInfo: userInfo)
        guard value.isEmpty == false else {
            return UNNotificationSound.default
        }
        
        return UNNotificationSound(named: UNNotificationSoundName(rawValue: value))
    }
}
