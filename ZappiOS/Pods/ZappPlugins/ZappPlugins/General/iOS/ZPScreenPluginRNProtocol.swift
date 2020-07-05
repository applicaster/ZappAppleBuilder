//
//  ZPScreenPluginRNProtocol.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 10/30/18.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public protocol ZPScreenPluginRNProtocol {
    weak var delegate:ZPScreenPluginRNDelegate? { get set }
    
    // Notify screen plugin when view will appear
    func screenPluginWillAppear(viewController:UIViewController)
    
    // Notify screen plugin when view did appear
    func screenPluginDidAppear(viewController:UIViewController)
    
    // Notify screen plugin when view will disappear
    func screenPluginWillDisappear(viewController:UIViewController)
    
    // Notify screen plugin when view did disappear
    func screenPluginDidDisappear(viewController:UIViewController)
    
    // Notify the screen plugin that a logout event took place
    @objc optional func sendLogoutEvent()
}

@objc public protocol ZPScreenPluginRNDelegate {
    func removeScreenPluginFromNavigationStack()
}
