//
//  ZLScreenModel+HooksPlugins.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 10/9/18.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

extension ZLScreenModel {
    private struct HookKeys {
        static let preLaunchPlugins   = "preload_plugins"
        static let postLaunchPlugins  = "postload_plugins"
        struct HooksPluginApiKey {
            static let screenId = "screen_id"
            static let identifier = "identifier"
            static let type = "type"
        }
    }
    
    /// Prehooks dictionary - plugins that must be presetnted before current screen will be shown
    @objc open var preLaunchPlugins: [[String: Any]] {
        var retVal:[[String: Any]] = []
        if let preLaunchPluginDict = hooksPlugins[HookKeys.preLaunchPlugins] as? [[String: Any]] {
            retVal = preLaunchPluginDict
        }
        return retVal
    }
    
    /// Posthooks dictionary - plugins that must be presetnted after screen will be presented
    @objc open var postLaunchPlugins: [[String: Any]]  {
        var retVal:[[String: Any]] = []

        if let postLaunchPluginDict = hooksPlugins[HookKeys.postLaunchPlugins] as? [[String: Any]] {
            retVal = postLaunchPluginDict
        }
        return retVal
    }
    
    public func pluginData(dict:[String: Any]) -> (identifier:String, type:String, screenId:String?)? {
        guard let identifier = dict[HookKeys.HooksPluginApiKey.identifier] as? String,
        let type = dict[HookKeys.HooksPluginApiKey.type] as? String else {
            return nil
        }
        
        let screenId = dict[HookKeys.HooksPluginApiKey.screenId] as? String
        
        
        let retVal:(identifier:String, type:String, screenId:String?) = (identifier, type, screenId)
        return retVal
    }
}
