//
//  ZLNavigationTypes.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 25/06/2018.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

public enum ZLNavigationTypes: Equatable {
    case navigationBar
    case menu
    case undefined

    static func typeByKey(_ key:String) -> ZLNavigationTypes {
        switch key {
        case "nav_bar":
            return .navigationBar
        case "menu":
            return .menu
        default:
            return undefined
        }
    }

    func componentType() -> String {
        switch self {
        case .navigationBar:
            return "nav_bar"
        case .menu:
            return "menu"
        default:
            return "undefined"
        }
    }
}

