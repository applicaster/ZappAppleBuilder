//
//  ZPLoginProviderUserDataProtocol.swift
//  Pods
//
//  Created by Alex Zchut on 04/06/2017.
//
//

import Foundation

@objc public protocol ZPLoginProviderUserDataProtocol: ZPLoginProviderProtocol {
    @objc optional func isUserComply(policies:[String: NSObject]) -> Bool
    @objc optional func isUserComply(policies:[String: NSObject], completion: @escaping (Bool) -> ())
}
