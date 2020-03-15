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

#if FIREBASE_EXTENSIONS_ENABLED
import Firebase
#endif

//default implementation
class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let content = bestAttemptContent else {
            return
        }

        #if FIREBASE_EXTENSIONS_ENABLED
        Messaging.serviceExtension().populateNotificationContent(content,withContentHandler: contentHandler)
        #else
        
        self.getAttachments(for: content.userInfo) { (attachments) in
            content.attachments = attachments
            
            DispatchQueue.main.async {
                contentHandler(content)
            }
        }
        
        #endif
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}

#endif
