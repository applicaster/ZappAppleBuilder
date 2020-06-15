//
//  ZPScreenHookManagerProtocol.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 10/15/18.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public protocol ZPScreenHookManagerProtocol: NSObjectProtocol {
    /// PerformHook post hook
    ///
    /// - Parameters:
    ///   - screenID: Id of the screen
    ///   - model: data source model of screen
    ///   - completion: completion block
    @objc func performPostHook(hookedViewController:UIViewController?,
                               screenID:String,
                               model:NSObject?,
                               completion:@escaping (_ continueFlow:Bool) -> Void)
    
    /// PerformHook pre hook
    ///
    /// - Parameters:
    ///   - screenID: Id of the screen
    ///   - model: data source model of screen
    ///   - completion: completion block
    @objc func performPreHook(hookedViewController:UIViewController?,
                               screenID:String,
                               model:NSObject?,
                               completion:@escaping (_ continueFlow:Bool) -> Void)
    
    var presentInCustomViewController:((_ hookViewController:UIViewController,_ presentationTypeString:String?)->Void)? { get set }
    
    
}
