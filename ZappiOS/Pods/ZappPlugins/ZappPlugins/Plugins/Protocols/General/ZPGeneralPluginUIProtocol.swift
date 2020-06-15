//
//  ZPGeneralPluginUIProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 08/05/2017.
//  Copyright © 2017 Anton Kononenko. All rights reserved.
//

import Foundation

@objc public protocol ZPGeneralPluginUIProtocol: ZPGeneralPluginProtocol {
    
    /**
     Get view controller for options
     
     - parameter options: - dictionary of values needed for func
     */

    @objc func viewController(options: [AnyHashable: Any]?) -> UIViewController?
}
