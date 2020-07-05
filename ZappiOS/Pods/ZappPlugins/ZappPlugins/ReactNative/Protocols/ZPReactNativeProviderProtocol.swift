//
//  ZPBroadcasterPickerProviderProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 09/01/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//

import Foundation
import ZappCore

@objc public protocol ZPReactNativeProviderProtocol: ZPAdapterProtocol {
    
    /**
     Use this in order to add to your React provider runtime handlers for JS2Native events.
     
     @param extraReactBridgeModules - Array of objects implementing `RCTBridgeModule` interface.
     */
    var extraReactBridgeModules: [Any]? { get set }
    
    /**
     Init method.
     */
    init(configurationJSON: NSDictionary?, bundleUrl: URL?, moduleName: String, extraParams: [AnyHashable: Any])
    
    /**
     Call this method in order to start loading of React (before presentation but after setup - better call right before presentation).
     React will not be loaded until this method is being called.
     MAKE sure to set all the configuration you need on your react provider before calling this method - most of the properties 
     are locked and not changeable after starting the load.
     */
    func startLoadingReact(completion: (() -> Void)?)
}

extension Notification.Name {
    public static let ZPReactNativeContentSizeDidChange = Notification.Name("ZPReactNativeContentSizeDidChange")
}
