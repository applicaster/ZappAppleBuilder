//
//  AdConfig.swift
//  ApplicasterSDK
//
//  Created by Anna Bauza on 14/06/2018.
//

import Foundation

/// Class with the parameters needed to configure a single ad.
@objc public class ZPAdConfig : NSObject {
    /// Ad unit id.
    @objc public var adUnitId: String
    /// Kind of ad.
    @objc public var adType: ZPAdType
    /// Size identifier used for inline banners.
    @objc public var inlineBannerSize: String?
    
    /// Create a config object to present an inline banner.
    ///
    /// - Parameters:
    ///   - adUnitId: Ad unit id.
    ///   - inlineBannerSize: Size identifier of the inline banner.
    @objc public init(adUnitId: String, inlineBannerSize: String) {
        self.adUnitId = adUnitId
        self.inlineBannerSize = inlineBannerSize
        self.adType = .inlineBanner
    }
    
    /// Create a config object to present a single ad.
    ///
    /// - Parameters:
    ///   - adUnitId: Ad unit id.
    ///   - adType: Kind of ad.
    @objc public init(adUnitId: String, adType: ZPAdType) {
        self.adUnitId = adUnitId
        self.adType = adType
    }
}
