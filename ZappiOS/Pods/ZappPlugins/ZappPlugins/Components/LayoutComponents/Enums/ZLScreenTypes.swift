//
//  ZLScreenTypes.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 25/06/2018.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public enum ZLScreenTypes: Int {
    case general
    case favorites
    case plugin
    static func typeByKey(_ key:String) -> ZLScreenTypes {
        var retVal:ZLScreenTypes = .general
        if key == "favorites" {
            retVal = .favorites
        } else if key == "general_content" {
            retVal = .general
        } else if key != "favorites" && key != "general_content" {
            retVal = .plugin
        }
        return retVal
    }

    func viewControllerInString() -> String {
        var retVal = "GAGenericViewController"

        switch self {
        case .favorites:
            retVal = "GAFavoritesViewController"
        case .plugin:
            retVal = "ZappSDK.GAScreenPluginGenericViewController"
        default:
            break
        }
        return retVal
    }
}
