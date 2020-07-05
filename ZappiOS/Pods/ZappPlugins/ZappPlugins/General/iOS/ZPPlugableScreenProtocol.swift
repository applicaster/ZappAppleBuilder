//
//  ZPPlugableScreenProtocol.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 8/16/18.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

///Note this protocol must be implemented to have ability to create screen plugin
@objc public protocol ZPPluggableScreenProtocol: ZPUIBuilderPluginsProtocol {
    /// Create a view controller for a pluggable screen from a plugin.
    ///
    ///
    /// - Returns:
    ///   - Plugable screen view controller
    @objc optional func createScreen() -> UIViewController
    
    // Notify screen plugin when view will appear (More likely to be used by RN plugins)
    @objc optional func screenPluginWillAppear(viewController:UIViewController)
    
    // Notify screen plugin when view did appear (More likely to be used by RN plugins)
    @objc optional func screenPluginDidAppear(viewController:UIViewController)
    
    // Notify screen plugin when view will appear (More likely to be used by RN plugins)
    @objc optional func screenPluginWillDisappear(viewController:UIViewController)
    
    /// Notify screen plugin when it did dissapiar
    ///
    /// - Parameter viewController: viewController instance that will be removed
    @objc optional func screenPluginDidDisappear(viewController:UIViewController)

    /// Delegation for screen instance
    @objc weak var screenPluginDelegate:ZPPlugableScreenDelegate? { get set }
    
    /// Passing a custom title for navigation bar
    @objc optional var customTitle:String? { get }
    
    // Request displaying without alligning container to safe borders
    @objc optional var ignoreSafeBordersForContainer:Bool { get }
}

