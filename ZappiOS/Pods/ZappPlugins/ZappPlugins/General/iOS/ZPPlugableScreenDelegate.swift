//
//  ZPPlugableScreenDelegate.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 10/29/18.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public protocol ZPPlugableScreenDelegate: class, NSObjectProtocol {
    
    /// Instance of ViewController of Screen Plugin
    @objc var screenPluginViewController:UIViewController { get }
    
    /// Remove Screen Plugin from navigation stack
    @objc func removeScreenPluginFromNavigationStack()
}
