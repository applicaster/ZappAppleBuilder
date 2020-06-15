//
//  ZLScreenModel+Refresh.swift
//  
//
//  Created by Anton Kononenko on 8/27/18.
//

import Foundation
@objc public enum ZLScreenModelRefreshType:NSInteger {
    case none
    case auto
    case pull
    case autoAndPull
}

@objc public enum ZLPullToRefreshSpinnerType:NSInteger {
    case `default`
    case customImage
}

extension ZLScreenModel {
    private struct RefreshKeys {
        static let refresh = "refresh"
        struct RefreshType {
            static let none = "none"
            static let auto = "auto"
            static let pull = "pull"
            static let autoAndPull = "auto_and_pull"
        }
        static let refreshRate = "refresh_rate"
        static let autoRefreshImageURL = "auto_refresh_image_url"
        static let autoRefreshTextColor = "auto_refresh_text_color"
        static let autoRefreshFontFamily = "auto_refresh_ios_font_family"
        static let autoRefreshFontSize   = "auto_refresh_title_size"
        static let autoRefreshBackgroundColor = "auto_refresh_background_color"
        static let pullToRefreshLoaderColor = "pull_to_refresh_loader_color"
        static let pullToRefreshBackgroundColor = "pull_to_refresh_background_color"
        static let pullToRefreshSpinnerType = "pull_to_refresh_style"
        struct PullToRefreshSpinnerType {
            static let none = "default_spinner"
            static let custom = "custom_spinner"
        }
    }
    
    @objc public var refreshType:ZLScreenModelRefreshType {
        guard let refreshType = rules[RefreshKeys.refresh] as? String else {
            return .none
        }
        switch refreshType {
        case RefreshKeys.RefreshType.auto:
            return .auto
        case RefreshKeys.RefreshType.pull:
            return .pull
        case RefreshKeys.RefreshType.autoAndPull:
            return .autoAndPull
        default:
            return .none
        }
    }
    
    @objc public var isAutoRefreshEnabled:Bool {
        return refreshType == .auto || refreshType == .autoAndPull
    }
    
    @objc public var isPullRefreshEnabled:Bool {
        return refreshType == .pull || refreshType == .autoAndPull
    }
    
    @objc public var autoRefreshImageUrl:URL? {
        guard let imageURLString = rules[RefreshKeys.autoRefreshImageURL] as? String,
        String.isNotEmptyOrWhitespace(imageURLString),
        let url = URL(string: imageURLString) else {
            return nil
        }
        return url
    }
    
    @objc public var autoRefreshBackgroundColor:UIColor? {
        guard isAutoRefreshEnabled == true,
            let color = rules[RefreshKeys.autoRefreshBackgroundColor] as? String else {
                return nil
        }
        return UIColor(argbHexString: color) ?? UIColor.clear
    }
    
    @objc public var autoRefreshTextColor:UIColor? {
        guard isAutoRefreshEnabled == true,
            let color = rules[RefreshKeys.autoRefreshTextColor] as? String else {
                return nil
        }
        return UIColor(argbHexString: color) ?? UIColor.clear
    }
    
    @objc public var autoRefreshFont:UIFont? {
        guard isAutoRefreshEnabled == true,
            let fontName = rules[RefreshKeys.autoRefreshFontFamily] as? String,
            let fontSizeString = rules[RefreshKeys.autoRefreshFontSize] as? String,
            let fontSize = CGFloat(fontSizeString) else {
                return nil
        }
        return UIFont(name: fontName,
                      size: fontSize)
    }
    
    @objc public var refreshRate:TimeInterval {
        guard isAutoRefreshEnabled == true else {
            return 0
        }
        
        if let refreshRate = rules[RefreshKeys.refreshRate] as? Double {
            return TimeInterval(refreshRate)
        } else if let refreshRateString = rules[RefreshKeys.refreshRate] as? String,
            let refreshRate = TimeInterval(refreshRateString) {
            return refreshRate
        }
        return 0
    }
    
    @objc public var pullToRefreshIndicatorColor:UIColor? {
        guard isPullRefreshEnabled == true,
            let color = rules[RefreshKeys.pullToRefreshLoaderColor] as? String else {
                return nil
        }
        return UIColor(argbHexString: color) ?? UIColor.black
    }
    
    @objc public var pullToRefreshBackgroundColor:UIColor? {
        guard isPullRefreshEnabled == true,
            let color = rules[RefreshKeys.pullToRefreshBackgroundColor] as? String else {
                return nil
        }
        return UIColor(argbHexString: color) ?? UIColor.clear
    }
    
    @objc public var pullToRefreshSpinnerType:ZLPullToRefreshSpinnerType {
        guard let refreshType = rules[RefreshKeys.pullToRefreshSpinnerType] as? String else {
            return .default
        }
        switch refreshType {
        case RefreshKeys.PullToRefreshSpinnerType.custom:
            return .customImage
        default:
            return .default
        }
    }
}

