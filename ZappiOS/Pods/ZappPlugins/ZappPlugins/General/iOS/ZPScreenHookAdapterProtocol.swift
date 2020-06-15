//
//  ZPScreenHookProtocol.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 10/10/18.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation
import ZappCore

@objc public enum GAScreenHookManagerTypes:NSInteger {
    case screenPrehook
    case screenPostLaunchhook
}

@objc public protocol ZPScreenHookAdapterProtocol: ZPUIBuilderPluginsProtocol {

    
    /// Define if current hook can block flow
    @objc optional var isFlowBlocker:Bool { get }
    
    /// Request if manager must present hook with screen plugin
    ///
    @objc optional func requestScreenPluginPresentation(completion:@escaping (_ allowScreenPluginPresentation:Bool) -> Void)
    
    
    /// Request if hook want to be called reccuring when same screen instance invoke post launch hook
    ///
    @objc optional func reccuringPostLaunchHook( completion: @escaping (_ isReccurring:Bool) -> Void)
    
    
    /// Sends data to adapter that user removed screen
    ///
    /// - Parameter viewController: ViewController instance that will be removed
    @objc optional func hookPluginDidDisappear(viewController:UIViewController)
    
    
    /// Execute hook
    ///
    /// - Parameters:
    ///   - presentationIndex: Index of presenatation for same hook
    ///   - dataDict: dictionary that can be passed beetween hooks
    ///   - taskFinishedWithCompletion: Completion hook finish it task
    @objc func executeHook(presentationIndex:NSInteger,
                           dataDict:[String:Any]?,
                           taskFinishedWithCompletion:@escaping (_ succeed:Bool, _ error:NSError?, _ dataDict:[String:Any]?) -> Void)
    
    /// Execute hook
    ///
    /// - Parameters:
    ///   - presentationIndex: Index of presenatation for same hook
    ///   - model: model that can be passed beetween hooks
    ///   - taskFinishedWithCompletion: Completion hook finish it task
    @objc optional func executeHook(presentationIndex:NSInteger,
                           model:NSObject?,
                           taskFinishedWithCompletion:@escaping (_ succeed:Bool, _ error:NSError?, _ dataDict:[String:Any]?) -> Void)
    
    init?(pluginModel:ZPPluginModel,
          dataSourceModel:NSObject?)
}


