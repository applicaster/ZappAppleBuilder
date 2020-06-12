//
//  ZLNavigationItemTypes.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 25/06/2018.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

public enum ZLNavigationItemTypes: Equatable {
    /// This type is used for nav bar plugin as navigation button
    case button
    /// This type is used for menu plugin as cell in menu
    case label
    /// This type is used to define header in menu plugin
    case header
    /// This type is used to define ad in menu plugin
    case ad
    /// This type is used to define model with containerin menu plugin
    case nestedMenu

    /// This type is used for nav bar plugin as Applicaster Feed
    case applicasterFeed

    /// This type is used for nav bar plugin as Applicaster Crossmates
    case applicasterCrossmates

    /// This type is used for menu plugin as Applicaster EPG
    case applicasterEPG

    /// This type is used for nav bar plugin as Applicaster Settings
    case applicasterSettings

    /// This type is used for nav bar plugin as Liwe drawer
    case liveDrawer

    /// This type is used for nav bar plugin as Chromacast
    case chromecast

    case undefined

    static func typeByKey(_ key:String) -> ZLNavigationItemTypes {
        switch key {
        case "button":
            return .button
        case "label":
            return .label
        case "header":
            return .header
        case "ad":
            return .ad
        case "nested_menu":
            return .nestedMenu
        case "applicaster_feed":
            return .applicasterFeed
        case "applicaster_crossmates":
            return .applicasterCrossmates
        case "applicaster_epg":
            return .applicasterEPG
        case "applicaster_settings":
            return .applicasterSettings
        case "live_drawer":
            return .liveDrawer
        case "chromecast":
            return .chromecast
        default:
            return undefined
        }
    }

    public func componentType() -> String {
        switch self {
        case .label:
            return "label"
        case .button:
            return "button"
        case .header:
            return "header"
        case .ad:
            return "ad"
        case .nestedMenu:
            return "nested_menu"
        case .applicasterFeed:
            return "applicaster_feed"
        case .applicasterCrossmates:
            return "applicaster_crossmates"
        case .applicasterEPG:
            return "applicaster_epg"
        case .applicasterSettings:
            return "applicaster_settings"
        case .liveDrawer:
            return "live_drawer"
        case .chromecast:
            return "chromecast"
        default:
            return "undefined"
        }
    }
}
