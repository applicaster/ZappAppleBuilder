//
//  NotificationService+Helper.swift
//  NotificationServiceExtension
//
//  Created by Alex Zchut on 13/12/2018.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import UserNotifications

#if AIRSHIP_EXTENSIONS_ENABLED
    // do nothing
#elseif FIREBASE_EXTENSIONS_ENABLED
    // do nothing
#else
extension NotificationService {
    /// Helper function to extract Attachments from an userInfo object
    ///
    /// - Attribute userInfo: The user info extracted from the notification,
    ///                       which should contain one of the available keys to create
    ///                       a rich push notification.
    public func getAttachments(for userInfo: [AnyHashable: Any], completion: @escaping ([UNNotificationAttachment]) -> Void) {
        let uniqueString = ProcessInfo.processInfo.globallyUniqueString
        var attachments:[UNNotificationAttachment] = []
        
        if let attachmentURLString = userInfo["image-url-png"] as? String {
            guard let attachmentURL = URL(string: attachmentURLString),
                let imageData = try? Data(contentsOf: attachmentURL),
                let attachment = self.save("\(uniqueString).png", data: imageData, options: nil) else {
                    completion(attachments)
                    return
            }
            attachments.append(attachment)
        }
        else if let attachmentURLString = userInfo["image-url-jpg"] as? String {
            guard let attachmentURL = URL(string: attachmentURLString),
                let imageData = try? Data(contentsOf: attachmentURL),
                let attachment = self.save("\(uniqueString).jpg", data: imageData, options: nil) else {
                    completion(attachments)
                    return            }
            attachments.append(attachment)
        }
        else if let attachmentURLString = userInfo["image-url-gif"] as? String {
            guard let attachmentURL = URL(string: attachmentURLString),
                let imageData = try? Data(contentsOf: attachmentURL),
                let attachment = self.save("\(uniqueString).gif", data: imageData, options: nil) else {
                    completion(attachments)
                    return
            }
            attachments.append(attachment)
        }
        else if let attachmentURLString = userInfo["attachment-url"] as? String {
            guard let attachmentURL = URL(string: attachmentURLString),
                let imageData = try? Data(contentsOf: attachmentURL),
                let attachment = self.save(attachmentURL.lastPathComponent, data: imageData, options: nil) else {
                    completion(attachments)
                    return
            }
            attachments.append(attachment)
        }
        else if let attachment = userInfo["com.urbanairship.media_attachment"] as? [AnyHashable: Any],
            let attachmentURLarray = attachment["url"] as? [String],
            let attachmentURLString = attachmentURLarray.first {
            guard let attachmentURL = URL(string: attachmentURLString),
                let imageData = try? Data(contentsOf: attachmentURL),
                let attachment = self.save(attachmentURL.lastPathComponent, data: imageData, options: nil) else {
                    completion(attachments)
                    return
            }
            attachments.append(attachment)
        }

        completion(attachments)
    }

    /// Save data object onto disk and return an optional attachment linked to this path.
    ///
    /// - Attributes:
    ///   - identifier: The unique identifier of the attachment.
    ///                 Use this string to identify the attachment later. If you specify an
    ///                 empty string, this method creates a unique identifier string for you.
    ///   - data: The data stored onto disk.
    ///   - options: A dictionary of options related to the attached file.
    ///              Use the options to specify meta information about the attachment,
    ///              such as the clipping rectangle to use for the resulting thumbnail.
    private func save(_ identifier: String, data: Data, options: [AnyHashable: Any]?) -> UNNotificationAttachment? {
        // Create paths
        let directory = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(ProcessInfo.processInfo.globallyUniqueString, isDirectory: true)
        let fileURL = directory.appendingPathComponent(identifier)
        // Write data on disk
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        try? data.write(to: fileURL, options: [])
        // Create Notification attachment
        return try? UNNotificationAttachment(identifier: identifier, url: fileURL, options: options)
    }

    /// Something went wrong, so maybe we want to clean up and present a fallback to the user.
    ///
    /// - Attribute reason: The reason why something went wrong.
    private func exitGracefully(_ reason: String = "") {
        guard let copy = bestAttemptContent?.mutableCopy() as? UNMutableNotificationContent else { return }
        copy.title = reason
        contentHandler?(copy)
    }
}

#endif
