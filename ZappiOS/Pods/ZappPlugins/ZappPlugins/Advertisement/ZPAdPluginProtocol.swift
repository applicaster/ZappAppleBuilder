//
//  AdPluginProtocol.swift
//  ApplicasterSDK
//
//  Created by Anna Bauza on 14/06/2018.
//

import Foundation
import ZappCore

/// An ad plugin is a class that mananges the construction and visualization of custom advertisement for your app.
@objc public protocol ZPAdPluginProtocol: ZPAdapterProtocol {
    
    /// Creates and return an ad presenter so you could show an ad.
    ///
    /// - Parameters:
    ///   - adView: ZPAdViewProtocol that will receive the callbacks from the presenter when important events are happening.
    ///   - parentVC: View controller where the ad will be added or presented from.
    /// - Returns: Ad presenter that manages the presentation of an ad.
    func createAdPresenter(adView:ZPAdViewProtocol, parentVC:UIViewController) -> ZPAdPresenterProtocol
    
    /// Returns the size of an inline banner.
    ///
    /// - Parameter inlineBannerSize: Size identifier of the inline banner.
    /// - Returns: Size of an inline banner
    func size(forInlineBannerSize inlineBannerSize: String) -> CGSize
    
    /// Returns the provider name.
    ///
    /// - Returns: Provider name.
    func providerName() -> String
}
