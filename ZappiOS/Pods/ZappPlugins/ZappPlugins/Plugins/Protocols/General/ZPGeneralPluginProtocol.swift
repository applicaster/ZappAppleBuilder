//
//  ZPGeneralPluginProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 02/02/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//

import Foundation

@objc public protocol ZPGeneralPluginProtocol: ZPAdapterProtocol {
    
    /**
     Activate plugin function to be implemented on plugin 
     
     - parameter options: - dictionary of values needed for plugin
     */
    @objc func activate(options: [AnyHashable: Any]?)
    
    /**
     Activate plugin function to be implemented on plugin
     
     - parameter object: - APModel or other model object that should have the plugin required info
     */
    @objc func activate(object: NSObject?)
    
    /**
     Activate plugin function to be implemented on plugin
     
     - parameter object: - APModel or other model object that should have the plugin required info
     - parameter completion: - some filled NSObject
     */
    @objc func activate(object: NSObject?, completion: ((NSObject?) -> Void)?)
    
    /**
     Activate plugin function to be implemented on plugin
     */
    @objc func activate()
    
    /**
     Deactivate plugin function to be implemented on plugin
     
     - parameter completion: Bool status of completion
     */
    @objc func deactivate(completion: ((Bool) -> Void)?)
    
    
    /**
     Deactivate all plugin related data function to be implemented on plugin
     
     - parameter completion: Bool status of completion
     */
    @objc func deactivateAll(completion: ((Bool) -> Void)?)    
}
