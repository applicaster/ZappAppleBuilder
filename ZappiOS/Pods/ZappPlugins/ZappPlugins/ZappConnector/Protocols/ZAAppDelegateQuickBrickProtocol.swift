//
//  ZAAppDelegateQuickBrickProtocol.swift
//  ZappAppConnector
//
//  Created by François Roland on 15/05/2018.
//  Copyright © 2018 Applicaster Ltd. All rights reserved.
//

import Foundation

/// ZappAppConnector protocol for Quick Brick Apps
@objc public protocol ZAAppDelegateConnectorQuickBrickProtocol {
    /// - returns: react native packager root url, as defined by zapptool
    @objc func reactNativePackagerRoot() -> String?
}
