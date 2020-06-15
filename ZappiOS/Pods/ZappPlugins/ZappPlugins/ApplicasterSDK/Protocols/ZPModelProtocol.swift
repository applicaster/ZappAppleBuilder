//
//  ZPModelProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 29/08/2018.
//

import Foundation

@objc public protocol ZPModelProtocol: ZPJsonSerializableProtocol {
    @objc func getUniqueID() -> String?
    @objc func getImagesDictionary() -> [String: AnyObject]?
    @objc optional func getBroadcasterID() -> String?

    @objc func isLoading() -> Bool
    @objc func isLoaded() -> Bool
    @objc func load()
    @objc func isEqualToModel(_ model: ZPModelProtocol) -> Bool
    @objc func addLoadingObserver(_ observer:NSObject)
}
