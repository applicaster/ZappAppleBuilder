//
//  ZPRootViewContainerControllerDelegate.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 11/12/2017.
//  Copyright © 2017 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public enum ZPNavBarPlacement: NSInteger {
    case onTop
    case overlay
    case hidden
}

@objc public enum ZPNavBarBackgroundType: NSInteger {
    case color
    case image
}

@objc public enum ZPNavBarPresentationStyle: NSInteger {
    case title
    case logo
    case hidden
}

@objc public protocol ZPRootViewContainerControllerDelegate {
    
    /// Request to place navigation bar view in proper place for placement type
    ///
    /// - Parameters:
    ///   - navigationBar: Navigation Bar View to present
    ///   - placementType: Difines presentation type for navigation bar
    @objc func placeNavBarToContainer(navigationBar: UIView,
                                      placementType: ZPNavBarPlacement)
    
    
    /// Request if container is root navigation container
    ///
    /// - Returns: true if yes, othewise false
    @objc func isRootNavigationContainer() -> Bool
}
