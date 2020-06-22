//
//  ZPPluginUrlSchemeHandler.swift
//  Pods
//
//  Created by Miri on 31/03/2017.
//
//

import Foundation
import ZappCore

@objc public class ZPPluginUrlSchemeHandler: NSObject {
    
    fileprivate static let kPluginType = "type";
    
    @objc open class func handleUrlScheme(_ params: NSDictionary?) -> Void
    {
        if let params = params, let type = params[kPluginType] as? String {
            if let pluginType = ZPPluginType(rawValue: type), var pluginModels = ZPPluginManager.pluginModels() {
                pluginModels = pluginModels.filter { $0.pluginType == pluginType }
                
                for pluginModel in pluginModels {
                    if let classType = ZPPluginManager.adapterClass(pluginModel) as? ZPAdapterProtocol.Type {
                        let plugin = classType.init(configurationJSON: pluginModel.configurationJSON)
                        plugin.handleUrlScheme?(params)
                    }
                }
            }
        }
    }
}
