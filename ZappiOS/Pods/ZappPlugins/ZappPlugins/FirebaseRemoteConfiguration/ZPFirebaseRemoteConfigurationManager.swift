//
//  ZPFirebaseRemoteConfigurationManager.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 10/05/2018.
//  Copyright © 2018 Applicaster Ltd. All rights reserved.
//

import ZappCore

@objc public class ZPFirebaseRemoteConfigurationManager: NSObject {
    @objc public static let sharedInstance = ZPFirebaseRemoteConfigurationManager()
    
    private override init() {
        //This prevents others from using the default '()' initializer for this class.
    }

    @objc public func getParametersForMatchingWithRemoteConfigurationKeys() -> [String: Any] {
        let pluginModels = ZPPluginManager.pluginModels()?.filter({ (model: ZPPluginModel) -> Bool in
            var retValue = false
            if let _ = ZPPluginManager.adapterClass(model) as? ZPFirebaseRemoteConfigurationProtocol.Type {
                retValue = true
            }
            return retValue
        })

        var configurationKeys = [String: Any]()
        if let pluginModels = pluginModels {
            for pluginModel in pluginModels {
                if let classType = ZPPluginManager.adapterClass(pluginModel) as? ZPFirebaseRemoteConfigurationProtocol.Type {
                    let provider = classType.init(configurationJSON: pluginModel.configurationJSON)
                    if let params = provider.getParametersForMatchingWithRemoteConfigurationKeys() {
                        for (key, value) in params {
                            configurationKeys[key] = value;
                        }
                    }
                }
            }
        }
        return configurationKeys
    }
}
