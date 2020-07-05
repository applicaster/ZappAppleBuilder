//
//  AdPresenterProtocol.swift
//  ApplicasterSDK
//
//  Created by Anna Bauza on 14/06/2018.
//

import Foundation

/// An ad presenter is the class that manages the presentation of an ad.
@objc public protocol ZPAdPresenterProtocol {
    
    /// Creates a new ad presenter.
    ///
    /// - Parameters:
    ///   - adView: ZPAdViewProtocol that will receive the callbacks from the presenter when important events are happening.
    ///   - parentVC: View controller where the ad will be added or presented from.
    init(adView: ZPAdViewProtocol, parentVC: UIViewController)
    
    /// Load a new ad.
    ///
    /// - Parameter adConfig: Parameters needed to configure the ad.
    func load(adConfig: ZPAdConfig)
    
    /// Return the size of the banner.
    ///
    /// - Returns: Size of the banner.
    func getSize() -> CGSize
    
    /// Show an interstitial ad. Only call this method when the ad has being loaded.
    func showInterstitial()
}
