//
//  ZPPlayerManagerBase.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 11/30/18.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation
import ZappCore

@objc open class ZPPlayerManagerBase: NSObject {
    public struct ZPPlayerManagerKeys {
        static let openWithPluginIdKey = "open_with_plugin_id"
    }
    public static let ZPPlayerManagerActiveInstanceWillChange = Notification.Name(rawValue: "ZPPlayerManagerActiveInstanceWillChange")
    @objc open var lastActiveInstance: ZPPlayerProtocol?
    
    // Retrieve all player plugins
    public lazy var playerPlugins:[ZPPluginModel] = {
        var retVal:[ZPPluginModel] = []
        if let plugins = ZPPluginManager.pluginModels()?.filter({ $0.pluginType == .VideoPlayer }) {
            retVal = plugins
        }
        
        
        //move default player to end
        let defaultPlayer = retVal.first { $0.identifier == ZPPlayerManager.ZPPlayerManagerIOSKeys.applicasterVideoPlayerId }
        if let defaultPlayer = defaultPlayer,
            let index = retVal.firstIndex(of: defaultPlayer) {
            retVal.remove(at: index)
            retVal.append(defaultPlayer)
        }
        
       return retVal
    }()
    
    
    /// Create player instance with content url string
    ///
    /// - Parameter contentURLString: URL of the file to play
    /// - Returns: ZPPlayerProtocol conformed instance of the player. I can not be founded nil
    open func player(with contentURLString:String) -> ZPPlayerProtocol? {
        let playable = ZPPlayableModel(urlString: contentURLString)
        return create(playableItem: playable)
    }
    
    /// Create player instance with data dictionary
    ///
    /// - Parameter dataDict: Dictionary with parameters for Playable item
    /// - Returns: ZPPlayerProtocol conformed instance of the player. I can not be founded nil
    open func player(with dataDict:[String:Any]) -> ZPPlayerProtocol? {
        guard let playable = ZPPlayableModel(dict: dataDict) else {
            return nil
        }
        return create(playableItem: playable)
    }
    
    /// Create and attach new player instance for specific type and use specified playableItem
    ///
    /// - Parameter playableItem: item to use with newly created player instance
    /// - Returns: ZPPlayerProtocol conformed instance of the player. I can not be founded nil
    @objc open func create(playableItem: ZPPlayable?) -> ZPPlayerProtocol? {
        
        guard let playableItem = playableItem else { return nil }
        //try type defined in Zapp
        let retVal = getObjectTypeAndConfigurationJsonFromZapp(playableItem)
        let player = createPlayerWithObject(retVal,
                                            playableItems:[playableItem])
        return player
    }
    
 
    /// Creates player with parameters
    ///
    /// - Parameters:
    ///   - pluggableParams: parameters for the player
    ///   - playableItems: arrey of playable items
    /// - Returns: ZPPlayerProtocol conformed instance of the player. I can not be founded nil
    open func createPlayerWithObject(_ pluggableParams: (type: ZPPlayerProtocol.Type?, configurationJSON: NSDictionary?), playableItems: [ZPPlayable]?) -> ZPPlayerProtocol? {
        let pluggablePlayer = pluggableParams.type?.pluggablePlayerInit?(playableItems: playableItems, configurationJSON: pluggableParams.configurationJSON)
        if pluggablePlayer != nil {
            if lastActiveInstance != nil {
                NotificationCenter.default.post(name: ZPPlayerManager.ZPPlayerManagerActiveInstanceWillChange, object: self.lastActiveInstance)
            }
            lastActiveInstance = pluggablePlayer

        }
        return pluggablePlayer
    }
    
    /// Check if playableItem can play.
    ///
    /// - Parameter playableItem: Item to play
    /// - Returns: true in case item can play
    @objc open func canPlay(playableItem: ZPPlayable?) -> Bool {
        return self.getObjectTypeAndConfigurationJsonFromZapp(playableItem).type != nil
    }

    
    /// Retrieve player instance and its data dictionary
    ///
    /// - Parameter playableItem: Item to play
    /// - Returns: Tuple of player instance and configuration json diction of the player
    func getObjectTypeAndConfigurationJsonFromZapp(_ playableItem: ZPPlayable?) ->  (type: ZPPlayerProtocol.Type?, configurationJSON: NSDictionary?) {
        
        if let data = self.getFirstPluginModelClassType(forPluggableItem: playableItem) {
            return (data.classType, data.pluginModel.configurationJSON)
        }
        
        return (nil, nil)
    }
    
    
    /// Retrieve player that can be used for specific playable item
    ///
    /// - Parameter playableItem: Item to play
    /// - Returns: Tuple of player instance and pluginModel of the player
    func getFirstPluginModelClassType(forPluggableItem playableItem: ZPPlayable?) -> (classType:ZPPlayerProtocol.Type, pluginModel:ZPPluginModel)? {
        var retValue:(classType:ZPPlayerProtocol.Type, pluginModel:ZPPluginModel)? = nil
        let pluginModels = self.getPluginModels(playableItem)
        if let pluginModel = pluginModels?.first,
            let classType = ZPPluginManager.adapterClass(pluginModel) as? ZPPlayerProtocol.Type {
            retValue = (classType:classType, pluginModel:pluginModel)
        }
        return retValue
    }
    
    
    /// Get Player model by model
    ///
    /// - Parameter playableItem: data source model of
    /// - Returns: player model that can be used with this model
    open func getPluginModels(_ playableItem: ZPPlayable?) -> [ZPPluginModel]? {
        guard let playableItem = playableItem else {
            return nil
        }
        
        var retVal: [ZPPluginModel]?

        if let extensions = playableItem.extensionsDictionary as? [String: Any],
            let pluginId = extensions[ZPPlayerManagerKeys.openWithPluginIdKey] as? String,
            let plugin = playerPlugins.first(where: { $0.identifier == pluginId }) {
            retVal = [plugin]
        }  else {
            retVal = playerPlugins
        }

        return retVal
    }
    
}
