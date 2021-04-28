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
        static let eventId = "eid"
        static let title = "title"
        static let subtitle = "subtitle"
        static let image = "image"
        static let presentLocalNotification = "show"
        static let storageKey = "SilentRemoteNotificationEventIds"
    }

    func handleSilentRemoteNotification(_ userInfo: [AnyHashable: Any],
                                        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Bool {
        self.logger?.debugLog(template: AppDelegateLogs.handleSilentRemoteNotification)

        guard let aps = userInfo[Params.aps] as? [String: AnyObject],
              let contentAvailable = aps[Params.contentAvailable] as? String,
              contentAvailable.boolValue else {
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
        guard let show = userInfo[Params.presentLocalNotification] as? String,
              show.boolValue else {
            return false
        }
        return true
    }

    fileprivate func presentLocalNotification(for userInfo: [AnyHashable: Any]) {
        
        guard let title = userInfo[Params.title] as? String else {
            return
        }

        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = userInfo[Params.subtitle] as? String ?? ""
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.userInfo = userInfo

        if let imageUrlString = userInfo[Params.image] as? String,
           let imageUrl = URL(string: imageUrlString) {
            do {
                if let data = try? Data(contentsOf: imageUrl),
                   let image = UIImage(data: data),
                   let url = image.getLocalUrl() {
                    let attachment = try UNNotificationAttachment(identifier: UUID().uuidString,
                                                                  url: url,
                                                                  options: nil)
                    content.attachments = [attachment]
                }

            } catch {
                self.logger?.debugLog(template: AppDelegateLogs.handleSilentRemoteNotificationFailedToAddAttachment)
            }
        }

        // show this notification in 2 sec from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        //lo
        self.logger?.debugLog(template: AppDelegateLogs.handleSilentRemoteNotificationPresentLocalPush)

        // add notification request
        UNUserNotificationCenter.current().add(request)
    }
}
