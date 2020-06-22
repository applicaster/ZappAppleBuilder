//
//  ZPGeneralPluginTypes.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 11/11/2019.
//

@objc public enum ZPGeneralPluginsTypes: Int {
    case undefined = 0
    case dynamicShortcutItems
    case spotlightUserActivitySearch
    case spotlightSubscription
    case downloads
    case hqmeLegacy

    public func description() -> String {
        switch self {
        case .dynamicShortcutItems:
            return "DynamicShortcutItems"
        case .spotlightUserActivitySearch:
            return "SpotlightUserActivitySearch"
        case .spotlightSubscription:
            return "SpotlightSubscription"
        case .hqmeLegacy:
            return "hqme_legacy_support"
        case .downloads:
            return "downloads_support"
        default:
            return String(self.rawValue)
        }
    }
}

@objc public enum ZPGeneralPluginsFamily: Int {
    case notDefined = 0
    case ui
    case chromecast
}
