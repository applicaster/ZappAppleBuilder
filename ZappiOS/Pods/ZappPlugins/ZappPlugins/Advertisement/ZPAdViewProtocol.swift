//
//  AdViewProtocol.swift
//  ApplicasterSDK
//
//  Created by Anna Bauza on 14/06/2018.
//

import Foundation

/// State of the ad
@objc public enum ZPAdViewState: Int {
    /// The ad hasn't been initialized yet
    case uninitialized
    /// The ad was requested to load
    case loading
    /// The ad has failed to being loaded
    case failed
    /// The ad has being loaded with success
    case loaded
    /// The add has been shown on screen with atleast 50% visibility
    case impressed
    /// The add has been clicked
    case clicked
    /// The interstitial ad is closed
    case closed
}

/// Type of advertisement
@objc public enum ZPAdType: Int {
    /// Banners that appers between cells or between components
    case inlineBanner
    /// Ads that appears fullscreen when you are visiting a screen
    case interstitial
    // Banners that are fixed at the bottom of the screen
    case screenBanner
}

/// Protocol that you should implement to receive callbacks from the presenter when important events are happening.
@objc public protocol ZPAdViewProtocol {
    
    /// Callback when an ad has being loaded. Usually you should implement this method to add the ad to your view or present it.
    ///
    /// - Parameter view: The view of the advertisement.
    func adLoaded(view: UIView?)
    
    /// Callback when the advertisement change his state.
    ///
    /// - Parameter adViewState: New state of the ad.
    func stateChanged(adViewState: ZPAdViewState)
    
    /// Callback when the ad fail to load.
    ///
    /// - Parameter error: Error description.
    func adLoadFailed(error: Error)
}
