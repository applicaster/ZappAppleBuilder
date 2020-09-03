//
//  FirebaseHandler.swift
//  ZappiOS
//
//  Created by Anton Kononenko on 2/28/20.
//  Copyright © 2020 Applicaster Ltd. All rights reserved.
//

import Foundation
import XrayLogger
import ZappApple

#if canImport(FirebaseCore)
    import FirebaseCore
#endif

let kGoogleServiceFileName = "GoogleService-Info"
let kGoogleServicePlistExtension = "plist"

public class FirebaseHandler: NSObject {
    public class func configure() {
        #if canImport(FirebaseCore)
            guard FirebaseApp.app() == nil,
                FirebaseHandler.hasValidConfiguration() == true else {
                return
            }

            let logger = Logger.getLogger(for: FirebaseLogs.subsystem)
            logger?.debugLog(template: FirebaseLogs.firebaseConfigure)
            FirebaseApp.configure()

        #endif
    }

    public class func hasValidConfiguration() -> Bool {
        let logger = Logger.getLogger(for: FirebaseLogs.subsystem)

        guard let path = Bundle.main.path(forResource: kGoogleServiceFileName,
                                          ofType: kGoogleServicePlistExtension),
            let content = NSDictionary(contentsOfFile: path),
            content.count > 0 else {
            logger?.warningLog(template: FirebaseLogs.firebaseConfigureHasNoValidConfiguration)
            return false
        }
        logger?.debugLog(template: FirebaseLogs.firebaseConfigureHasValidConfiguration)
        return true
    }
}
