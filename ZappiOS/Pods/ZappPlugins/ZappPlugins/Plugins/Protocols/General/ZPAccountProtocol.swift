//
//  ZPAccountProtocol.swift
//  ZappGeneralPluginsSDK
//
//  Created by Alex Zchut on 29/09/2018.
//

import Foundation

public struct GAAccountExtensionsPluginKeys {
    public static let pluginIdentifier = "account_extensons_generic"
    public static let kAccountExtensionsJsonData = "account_extensions_json"
}

public protocol ZPAccountProtocol {
    //nothing for now
}

public protocol ZPAccountExtensionsProtocol: ZPAccountProtocol {
    var accountExtensionsJsonData: [String: Any]? { get }
}
