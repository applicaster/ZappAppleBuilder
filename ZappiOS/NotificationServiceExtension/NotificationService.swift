//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by Alex Zchut on 09/12/2018.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import UserNotifications

#if AIRSHIP_EXTENSIONS_ENABLED

import AirshipAppExtensions
class NotificationService: UAMediaAttachmentExtension {

}

#else

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let content = bestAttemptContent else {
            return
        }

        // Modify the notification content here...
        content.title = "\(content.title) [1]"

        DispatchQueue.main.async { [weak self] in
            let userInfo: [AnyHashable: Any] = request.content.userInfo
            content.attachments = self?.attachmentsFor(userInfo) ?? []
            guard let copy = self?.bestAttemptContent else {
                return
            }
            contentHandler(copy)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}

#endif
