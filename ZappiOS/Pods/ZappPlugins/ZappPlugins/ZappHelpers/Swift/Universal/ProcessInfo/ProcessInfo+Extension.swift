//
//  ProcessInfo+Extension.swift
//  ZappPlugins
//
//  Copyright © 2017 Applicaster. All rights reserved.
//

import Foundation

public extension ProcessInfo {
    @objc static func isOperatingSystemAtLeast(majorVersion: Int,
                                               minorVersion: Int = 0,
                                               patchVersion: Int = 0) -> Bool {
        let version = OperatingSystemVersion(majorVersion: majorVersion, minorVersion: minorVersion, patchVersion: patchVersion)
        return processInfo.isOperatingSystemAtLeast(version)
    }
}
