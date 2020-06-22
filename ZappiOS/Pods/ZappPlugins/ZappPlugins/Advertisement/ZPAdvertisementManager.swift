//
//  ZPAdvertisementManager.swift
//  ZappPlugins
//
//  Created by Pablo Rueda on 14/06/2018.
//  Copyright © 2018 Applicaster Ltd. All rights reserved.
//

/// Manager that provides the plugin that manages advertisement.
@objc public class ZPAdvertisementManager: NSObject {
    
    /// Unique instance of the class.
    @objc public static let sharedInstance = ZPAdvertisementManager()
    
    private override init() {
        //This prevents others from using the default '()' initializer for this class.
    }
    
    /// Return the plugin that manages advertisement.
    ///
    /// - Returns: Plugin that manages advertisement
    @objc public func getAdPlugin() -> ZPAdPluginProtocol? {
        if let pluginModel = ZPPluginManager.pluginModel(.Advertisement),
            let classType = ZPPluginManager.adapterClass(pluginModel) as? ZPAdPluginProtocol.Type {
            return classType.init(configurationJSON: pluginModel.configurationJSON)
        }
        
        return nil
    }
}
