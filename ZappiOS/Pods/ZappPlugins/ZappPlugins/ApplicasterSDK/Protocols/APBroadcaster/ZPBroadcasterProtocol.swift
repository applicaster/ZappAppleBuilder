//
//  ZPBroadcasterProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 28/08/2018.
//

import Foundation

@objc public protocol ZPBroadcasterProtocol: ZPModelProtocol {

    @objc func getName() -> String?
    @objc func getExtensionsDictionary() -> [String: Any]?
    @objc func getObject(forKey: String) -> Any?
}
