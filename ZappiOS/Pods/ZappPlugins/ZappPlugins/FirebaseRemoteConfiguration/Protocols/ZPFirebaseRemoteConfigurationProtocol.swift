//
//  ZPFirebaseRemoteConfigurationProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 10/05/2018.
//  Copyright © 2018 Applicaster Ltd. All rights reserved.
//

import Foundation
import ZappCore

@objc public protocol ZPFirebaseRemoteConfigurationProtocol: ZPAdapterProtocol {

    /// Stops to track events related with the player.
    @objc func getParametersForMatchingWithRemoteConfigurationKeys() -> [String: Any]?

}
