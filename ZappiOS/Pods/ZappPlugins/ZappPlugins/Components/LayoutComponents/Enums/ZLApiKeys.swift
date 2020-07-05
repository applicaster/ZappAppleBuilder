//
//  ZLApiKeys.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 25/06/2018.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

public enum ZLScreenModelAPIKeys: String {
    case navigations        = "navigations"
    case component          = "ui_components"
    case id                 = "id"
    case styles             = "styles"
    case name               = "name"
    case type               = "type"
    case isHomeScreen       = "home" // Defines if screen is home screen
    case isHomeOfflineScreen  = "home_offline" // Defines if screen is home screen
    case supportsOffline    = "supports_offline" // Defines if screen supports offline
    case advertising        = "advertising"
    case rules              = "rules"
    case hooksPlugins       = "hooks"
    case general         = "general"

}

public enum ZLComponentAPIKeys: String {
    case id              = "id"
    case dataSource      = "data"
    case rules           = "rules"
    case type            = "component_type"
    case styles          = "styles"
    case component       = "ui_components"
}

public enum ZLRulesAPIKeys: String {
    case itemsLimit = "item_limit"
    /// Configure web view components to show/hide the navigation buttons
    case webPageShowsNavigation = "web_page_shows_navigation"
}

public enum ZLComponentDataSourceAPIKeys: String {
    case source      = "source"
    case type        = "type"
    case connected   = "connected"
    case target      = "target"

    public enum DataSourceType: String {
        case undefined
        case applicasterCategory     = "APPLICASTER_CATEGORY"
        case applicasterCollection   = "APPLICASTER_COLLECTION"
        case applicasterAtomFeed     = "APPLICASTER_ATOM_FEED"
        case applicasterFavorites    = "APPLICASTER_FAVORITES"
        case webURL                  = "WEB_URL"
        case banner                  = "BANNER"
        case hqme               = "DOWNLOADS"
        case userAccountComponent               = "USER_ACCOUNT_COMPONENT"

        public static func typeByKey(_ key:String) -> DataSourceType {
            switch key {
            case "APPLICASTER_CATEGORY":
                return .applicasterCategory
            case "APPLICASTER_COLLECTION":
                return .applicasterCollection
            case "APPLICASTER_ATOM_FEED":
                return .applicasterAtomFeed
            case "APPLICASTER_FAVORITES":
                return .applicasterFavorites
            case "WEB_URL":
                return .webURL
            case "BANNER":
                return .banner
            case "SMART_BANNER":
                return .banner
            case "BOX_BANNER":
                return .banner
            case "DOWNLOADS":
                return .hqme
            case "USER_ACCOUNT_COMPONENT":
                return .userAccountComponent
            default:
                return .undefined
            }
        }
    }
}

public enum ZLStylesModelAPIKeys: String {
    case cellBodyStyles    = "cell_body_styles"
    case cellBodyType      = "cell_body_component_type"
    case footer            = "footer"
    case cellStyles        = "cell_styles"
    case header            = "header"
    case family            = "family"
    case tabsHidden        = "hide_tabs" //this is a specific key for the screen picker
    case tabsStyle         = "tabs_style" //this is a specific key for the screen picker
    case defaultTab        = "default_tab" //this is a specific key for the screen picker
    case overlayTab        = "overlay" //this is a specific key for the screen picker
}

public enum ZLSupplementaryModeAPIKeys: String {
    case enabled     = "visible"
    case style       = "style"
    case dataSource  = "data" // TargetID data source
}


