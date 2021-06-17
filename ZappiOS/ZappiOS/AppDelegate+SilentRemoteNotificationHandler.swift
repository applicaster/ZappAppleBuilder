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
        static let tag = "tag"
        static let messageId = "gcm.message_id"
        static let title = "title"
        static let body = "body"
        static let sound = "sound"
        static let image = "image"
        static let url = "url"
        static let presentationDelay = "delay"
        static let proceededMessageIdsStorageKey = "SilentRemoteNotificationMessageIds"
        static let threadId = "thread-id"
    }

    func handleSilentRemoteNotification(_ userInfo: [AnyHashable: Any],
                                        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Bool {
        logger?.debugLog(template: AppDelegateLogs.handleSilentRemoteNotification,
                         data: ["user_info": userInfo])

        guard let aps = userInfo[Params.aps] as? [String: AnyObject],
              let contentAvailable = aps[Params.contentAvailable] as? Int,
              contentAvailable == 1 else {
            return false
        }

        if shouldHandleEvent(for: userInfo) {
            if shouldPresentLocalNotification(for: userInfo) {
                removePresentedNotificationIfNeeded(for: userInfo)
                presentLocalNotification(for: userInfo)
            } else {
                handleSilentNotification(for: userInfo)
            }
        }

        completionHandler(UIBackgroundFetchResult.newData)
        return true
    }

    fileprivate func shouldHandleEvent(for userInfo: [AnyHashable: Any]) -> Bool {
        var retValue = true
        // if there is a message-id, indicating unique message sent, check if the id was already been handled.
        // otherwise continue and handle the event
        guard let messageId = userInfo[Params.messageId] as? String else {
            return retValue
        }

        var proceededTags = UserDefaults.standard.array(forKey: Params.proceededMessageIdsStorageKey) as? [String] ?? []
        if proceededTags.contains(messageId) {
            retValue = false
        } else {
            proceededTags.append(messageId)
            UserDefaults.standard.setValue(proceededTags, forKey: Params.proceededMessageIdsStorageKey)
        }

        return retValue
    }

    fileprivate func handleSilentNotification(for userInfo: [AnyHashable: Any]) {
        guard let urlString = userInfo[Params.url] as? String,
              let url = URL(string: urlString) else {
            return
        }

        _ = UrlSchemeHandler.handle(with: rootController,
                                    application: UIApplication.shared,
                                    open: url)
    }

    fileprivate func shouldPresentLocalNotification(for userInfo: [AnyHashable: Any]) -> Bool {
        guard !string(for: Params.title, userInfo: userInfo).isEmpty else {
            return false
        }
        return true
    }

    fileprivate func removePresentedNotificationIfNeeded(for userInfo: [AnyHashable: Any]) {
        let tag = string(for: Params.tag, userInfo: userInfo)
        guard !tag.isEmpty else {
            return
        }

        UNUserNotificationCenter.current().removeNotifications(whereKey: "tag", hasValue: tag)
    }

    fileprivate func presentLocalNotification(for userInfo: [AnyHashable: Any]) {
        let content = UNMutableNotificationContent()
        content.title = string(for: Params.title, userInfo: userInfo)
        content.subtitle = string(for: Params.body, userInfo: userInfo)
        content.sound = sound(for: Params.sound, userInfo: userInfo)
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        content.userInfo = userInfo
        if let threadId = threadId(for: Params.threadId, userInfo: userInfo) {
            content.threadIdentifier = threadId
        }
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
                logger?.debugLog(template: AppDelegateLogs.handleSilentRemoteNotificationFailedToAddAttachment,
                                 data: ["user_info": userInfo])
            }
        }

        var presentationDelay: TimeInterval = 0.5
        if let presentationDelayString = userInfo[Params.presentationDelay] as? String,
           let presentationDelayInt = TimeInterval(presentationDelayString) {
            presentationDelay = presentationDelayInt
        }

        // show this notification in presentationDelay seconds value from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: presentationDelay, repeats: false)

        // create new request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        // log event
        logger?.debugLog(template: AppDelegateLogs.handleSilentRemoteNotificationPresentLocalPush,
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

    fileprivate func threadId(for key: String, userInfo: [AnyHashable: Any]) -> String? {
        let threadId = string(for: Params.threadId, userInfo: userInfo)
        guard threadId.isEmpty else {
            return Bundle.main.bundleIdentifier
        }
        return threadId
    }
}
