//
//  ZLScreenAdvertisingModel.swift
//  AFNetworking
//
//  Created by Anton Kononenko on 18/06/2018.
//

import Foundation

@objc open class ZLScreenAdvertisingModel: ZLBaseModel {
    struct ZLScreenAdvertisingKeys {
        static let bannerAdUnitKey = "banner_ad_unit_id"
        static let interstitialAdUnitKey = "interstitial_ad_unit_id"
        static let interstitialDisplayOnce = "display_interstitial_once"
    }
    
    @objc public var bannerAdUnit:String?
    @objc public var interstitialAdUnit:String?
    @objc public var displayInterstitialOnce:Bool = false
    @objc public var interstitialPresentatationAttempCounter = 0
    public override init(object: [String : Any]) {
        super.init(object: object)
        parse()
    }
    
    func parse() {
        if let bannerAdUnit = object[ZLScreenAdvertisingKeys.bannerAdUnitKey] as? String {
            self.bannerAdUnit = bannerAdUnit
        }
        
        if let interstitialAdUnit = object[ZLScreenAdvertisingKeys.interstitialAdUnitKey] as? String {
            self.interstitialAdUnit = interstitialAdUnit
        }
        
        if let displayInterstitialOnce = object[ZLScreenAdvertisingKeys.interstitialDisplayOnce] as? Bool {
            self.displayInterstitialOnce = displayInterstitialOnce
        }
    }
}
