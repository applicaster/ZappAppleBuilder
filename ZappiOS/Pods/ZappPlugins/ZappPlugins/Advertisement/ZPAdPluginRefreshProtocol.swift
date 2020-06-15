//
//  ZPAdPluginRefreshProtocol.swift
//  ZappPlugins
//
//  Created by Oliver Stowell on 09/01/2019.
//  Copyright © 2019 Applicaster LTD. All rights reserved.
//

import Foundation

/// Protocol to allow for custom reloading points
@objc public protocol ZPAdPluginRefreshProtocol {
    
    /// Should the banner reload when the view has been refreshed.
    ///
    /// - Returns: A `Bool` describing if the view should refresh.
    func reloadOnPullToRefresh() -> Bool
    
    /// Should the banner reload when the banner's `viewDidAppear()` is called.
    ///
    /// - Returns: A `Bool` describing if the view should refresh.
    func reloadOnDidAppear() -> Bool
}
