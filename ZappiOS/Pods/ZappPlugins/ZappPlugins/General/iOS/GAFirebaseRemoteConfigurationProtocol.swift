//
//  GAFirebaseRemoteConfigurationProtocol.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 9/19/19.
//  Copyright © 2019 Applicaster LTD. All rights reserved.
//

import Foundation

public protocol GAFirebaseRemoteConfigurationProtocol {
    func string(forKey key: String) -> String?
    func number(forKey key: String) -> NSNumber?
    func bool(forKey key: String) -> Bool
    func keys(withPrefix prefix: String) -> Set<String>?
}
