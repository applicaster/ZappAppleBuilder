//
//  ZAAppDelegateConnectorStorageProtocol.swift
//  ZappAppConnector
//
//  Created by François Roland on 15/05/2018.
//  Copyright © 2018 Applicaster Ltd. All rights reserved.
//

import Foundation
import ZappCore

/// ZappAppConnector protocol for Quick Brick Apps
@objc public protocol ZAAppDelegateConnectorStorageProtocol: FacadeConnectorStorageProtocol {
    @objc func sessionStorageApplicasterNamespace() -> String
    @objc func sessionStorageAllValues(namespace:String?) -> String?
    @objc func localStorageAllValues(namespace:String?) -> String?
}
