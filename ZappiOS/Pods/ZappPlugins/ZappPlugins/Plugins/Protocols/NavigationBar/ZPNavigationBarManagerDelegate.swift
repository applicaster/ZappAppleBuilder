//
//  ZPNavigationBarManagerDelegate.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 10/01/2018.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public protocol ZPNavigationBarManagerDelegate: class, NSObjectProtocol {
    
    /// Request navigation button for model
    ///
    /// - Parameter model: ZLNavigationItem model
    /// - Returns: NavigationButton instance
    func navigationButton(for model: NSObject) -> UIButton?
    
    /// Request if root is using special button
    ///
    /// - Returns: true if yes, otherwse false
    func isSpecialButtonUsedByRoot() -> Bool
}
