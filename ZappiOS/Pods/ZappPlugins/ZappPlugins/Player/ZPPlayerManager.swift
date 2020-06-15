//
//  ZPPlayerManager.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 10/05/2016.
//  Copyright © 2016 Applicaster Ltd. All rights reserved.
//

import AVFoundation
import AVKit
import ZappCore

@objc public enum ZPPlayerType: Int {
    case undefined = 0
    case `default`
    case avPlayer
    case player360
    case audio

    var relatedClassString: String {
        var str: String
        switch self {
        case .undefined:
            str = "ApplicasterSDK.APPlugablePlayerBase"
            break
        case .default:
            str = "ApplicasterSDK.APPlugablePlayerDefault"
            break
        case .avPlayer:
            str = "ApplicasterSDK.APPlugablePlayerAVPlayer"
            break
        case .player360:
            str = "NotDefined"
            break
        case .audio:
            str = "ApplicasterSDK.AudioPlayerViewController"
            break
        }
        return str
    }

    func description() -> String {
        switch self {
        case .default:
            return "Default"
        case .avPlayer:
            return "AVPlayer"
        default:
            return String(rawValue)
        }
    }
}

@objc open class ZPPlayerManager: ZPPlayerManagerBase {
    public struct ZPPlayerManagerIOSKeys {
        public static let ttPluginExternalIdentifier = "a623b3e4fd8de96a549ec9f7bdc8c4d2"
        static let applicasterAudioPlayerId = "applicaster_audio_player"
        static let applicasterVideoPlayerId = "applicaster_video_player"
    }

    @objc public static let sharedInstance = ZPPlayerManager()

    fileprivate override init() {
        // This prevents others from using the default '()' initializer for this class.
    }

    open override func getPluginModels(_ playableItem: ZPPlayable?) -> [ZPPluginModel]? {
        // We do not need to call super, we are fully overriding this func
        var retVal: [ZPPluginModel]?
        guard let playableItem = playableItem else {
            return retVal
        }

        if let extensions = playableItem.extensionsDictionary as? [String: Any],
            let pluginId = extensions[ZPPlayerManagerKeys.openWithPluginIdKey] as? String,
            let plugin = playerPlugins.first(where: { $0.identifier == pluginId }) {
            retVal = [plugin]
        } else if let specificPlayerHash = playableItem.playerExternalIdentifier as String?,
            specificPlayerHash.isEmpty == false,
            let plugin = playerPlugins.first(where: { $0.identifier.md5hash() == specificPlayerHash }) {
            retVal = [plugin]
        } else if playableItem.isAudioOnly ?? false,
            let plugin = playerPlugins.first(where: { $0.identifier == ZPPlayerManagerIOSKeys.applicasterAudioPlayerId }) {
            retVal = [plugin]
        } else { // If we don't define any plugin id in our extension or is not valid, we try to check for the player plugin type (old logic)
            retVal = playerPlugins.filter { self.canPlay($0, playableItem: playableItem) == true }
        }

        return retVal
    }

    func canPlay(_ pluginModel: ZPPluginModel, playableItem: ZPPlayable?) -> Bool {
        var retValue = false

        func canPlayPlayerType(_ playerType: ZPPlayerType) -> Bool {
            var canPlay = false

            switch playerType {
            case .player360:
                if playableItem?.is360Video ?? false {
                    canPlay = true
                }
            default:
                if let specificPlayerHash = playableItem?.playerExternalIdentifier as String?,
                    specificPlayerHash.isEmpty == false {
                    if pluginModel.identifier.md5hash() == specificPlayerHash {
                        canPlay = true
                    }
                } else if let atomEntryPlayable = playableItem as? ZPAtomEntryPlayableProtocol,
                    let supportedItemContentType = pluginModel.configurationValue(for: "item_content_type") as? String {
                    if atomEntryPlayable.contentType() == supportedItemContentType {
                        canPlay = true
                    }
                } else if pluginModel.identifier.md5hash() == ZPPlayerManager.ZPPlayerManagerIOSKeys.ttPluginExternalIdentifier,
                    playableItem is ZPAtomEntryPlayableProtocol == false {
                    // dont play non-atom entry items with tt player
                    canPlay = false
                } else {
                    canPlay = true
                }
            }
            return canPlay
        }

        if pluginModel.pluginType == .VideoPlayer {
            if let classType = ZPPluginManager.adapterClass(pluginModel) as? ZPPlayerProtocol.Type,
                let playerType = classType.pluggablePlayerType?() {
                retValue = canPlayPlayerType(playerType)
            }
        }
        return retValue
    }

    var backgroundActivePlayerInstance: ZPPlayerProtocol?

    @objc open override var lastActiveInstance: ZPPlayerProtocol? {
        didSet {
            ZAAppConnector.sharedInstance().audioSessionDelegate?.activateAudioSessionWithPlayback()
        }
    }

    /**
     Create and attach new player instance for specific type and use specified playableItem

     - parameter playableItem: - item to use with newly created player instance
     */
    @objc open override func create(playableItem: ZPPlayable?) -> ZPPlayerProtocol? {
        // We do not need to call super, we are fully overriding this func
        return create(playableItem: playableItem, forType: .undefined)
    }

    /**
     Create and attach new player instance for specific type and use specified playableItem

     - parameter playableItem: - item to use with newly created player instance
     - parameter type: - type of player to create
     */
    @objc open func create(playableItem: ZPPlayable?, forType type: ZPPlayerType) -> ZPPlayerProtocol {
        var items: [ZPPlayable]?
        if let playableItem = playableItem {
            items = [playableItem]
        }
        return create(playableItems: items, forType: type)
    }

    /**
     Create and attach new player instance for specific type and use specified playableItems

     - parameter playableItems: - items to use with newly created player instance,
       Note, all playableItems should be of the same type.
     - parameter type: - type of player to create
     */
    @objc open func create(playableItems: [ZPPlayable]?, forType type: ZPPlayerType) -> ZPPlayerProtocol {
        var player: ZPPlayerProtocol!
        var objType: ZPPlayerProtocol.Type?
        let playableItem = playableItems?.first

        // check if class conforms to protocol
        if type != .undefined {
            objType = getObjectType(type: type)
            let pluggableParams: (ZPPlayerProtocol.Type?, NSDictionary?) = (objType, nil)
            // create new player
            player = createPlayerWithObject(pluggableParams, playableItems: playableItems)
        } else { // Undefined type
            // **** legacy **** - try to get 360 player type
            if playableItem?.is360Video ?? false {
                objType = getObjectTypeFor360Player()
                let pluggableParams: (ZPPlayerProtocol.Type?, NSDictionary?) = (objType, nil)
                player = createPlayerWithObject(pluggableParams, playableItems: playableItems)
            }

            if player == nil && playableItem?.isAudioOnly ?? false {
                if let extensionsDictionary = playableItem?.extensionsDictionary,
                    let pluginID = extensionsDictionary[ZPPlayerManagerKeys.openWithPluginIdKey] as? String,
                    let plugin = ZPPluginManager.pluginModelById(pluginID),
                    let supportsAudioPlayback = plugin.configurationValue(for: "supports_audio") {
                    var shouldSupportsAudioPlayback = false
                    if let supportsAudioPlayback = supportsAudioPlayback as? String {
                        shouldSupportsAudioPlayback = supportsAudioPlayback.boolValue()
                    } else if let supportsAudioPlayback = supportsAudioPlayback as? Bool {
                        shouldSupportsAudioPlayback = supportsAudioPlayback
                    }
                    if shouldSupportsAudioPlayback == true {
                        let retVal = getObjectTypeAndConfigurationJsonFromZapp(playableItem)
                        player = createPlayerWithObject(retVal, playableItems: playableItems)
                    }
                }

                if player == nil {
                    if let objType = self.getObjectType(type: .audio) {
                        let pluggableParams: (ZPPlayerProtocol.Type?, NSDictionary?) = (objType, nil)
                        player = createPlayerWithObject(pluggableParams, playableItems: playableItems)
                    }
                }
            }

            if player == nil {
                //try type defined in Zapp
                let retVal = getObjectTypeAndConfigurationJsonFromZapp(playableItem)
                player = createPlayerWithObject(retVal, playableItems: playableItems)
            }
        }

        if player == nil {
            // if not exists use default
            let objType: ZPPlayerProtocol.Type = getObjectType(type: .default)!
            let pluggableParams: (ZPPlayerProtocol.Type?, NSDictionary?) = (objType, nil)
            player = createPlayerWithObject(pluggableParams, playableItems: playableItems)
        }

        assert(player != nil, "No plugins available to create a player!")

        return player
    }

    open override func createPlayerWithObject(_ pluggableParams: (type: ZPPlayerProtocol.Type?, configurationJSON: NSDictionary?), playableItems: [ZPPlayable]?) -> ZPPlayerProtocol? {
        if let pluggablePlayer = super.createPlayerWithObject(pluggableParams,
                                                              playableItems: playableItems) {
            clearBackgroundInstance()

            // For the audio player keep a strong reference
            if playableItems?.first?.isAudioOnly == true {
                createBackgroundInstance(pluggablePlayer: pluggablePlayer)
            }
            return pluggablePlayer
        }
        return nil
    }

    open func getPlayerType(_ playableItem: ZPPlayable?) -> ZPPlayerType {
        if let data = self.getFirstPluginModelClassType(forPluggableItem: playableItem),
            let playerType = data.classType.pluggablePlayerType {
            return playerType()
        }
        return .undefined
    }

    open func getPlayerClass(_ playableItem: ZPPlayable?) -> ZPPlayerProtocol.Type? {
        if let data = self.getFirstPluginModelClassType(forPluggableItem: playableItem) {
            return data.classType
        }
        return nil
    }

    open func matchingPlayerInstance(playable: ZPPlayable) -> ZPPlayerProtocol? {
        var result: ZPPlayerProtocol?

        if let globalPlayerInstance = ZPPlayerManager.sharedInstance.lastActiveInstance,
            let globalPlayable = globalPlayerInstance.pluggablePlayerFirstPlayableItem?() {
            if globalPlayable === playable {
                result = globalPlayerInstance
            } else if playable.responds(to: #selector(getter: ZPPlayable.identifier)),
                globalPlayable.responds(to: #selector(getter: ZPPlayable.identifier)),
                let playableId = playable.identifier,
                playableId == globalPlayable.identifier {
                result = globalPlayerInstance
            } else if let streamUrl = playable.contentVideoURLPath(), self.isPlayableMatchingStreamUrl(globalPlayable, streamUrl: streamUrl) {
                result = globalPlayerInstance
            }
        }

        return result
    }

    open func matchingPlayerInstance(streamUrl: String) -> ZPPlayerProtocol? {
        var result: ZPPlayerProtocol?

        if let globalPlayerInstance = ZPPlayerManager.sharedInstance.lastActiveInstance,
            let globalPlayable = globalPlayerInstance.pluggablePlayerFirstPlayableItem?(),
            self.isPlayableMatchingStreamUrl(globalPlayable, streamUrl: streamUrl) {
            result = globalPlayerInstance
        }

        return result
    }

    func isPlayableMatchingStreamUrl(_ playable: ZPPlayable, streamUrl: String) -> Bool {
        var result = false

        if let playableStreamUrl = playable.contentVideoURLPath(), playableStreamUrl == streamUrl {
            result = true
        }

        return result
    }

    func createBackgroundInstance(pluggablePlayer: ZPPlayerProtocol) {
        // Hold a reference to the player so when the owner view is removed the player will keep playing
        // This is for audio players
        backgroundActivePlayerInstance = pluggablePlayer
    }

    func clearBackgroundInstance() {
        backgroundActivePlayerInstance = nil
    }

    // **** legacy **** - try to get 360 player type
    func getObjectTypeFor360Player() -> ZPPlayerProtocol.Type? {
        if let obj = NSClassFromString("GAAP360PlayerWrapper") as? ZPPlayerProtocol.Type {
            // check and return obj conforms to protocol
            return obj
        } else {
            return nil
        }
    }

    /**
     private method - Get the object for type

     - parameter type: - type of pluggable player
     */
    func getObjectType(type: ZPPlayerType) -> ZPPlayerProtocol.Type? {
        // check if can get class from string
        if let obj = NSClassFromString(type.relatedClassString) as? ZPPlayerProtocol.Type {
            // check and return obj conforms to protocol
            return obj
        } else {
            return nil
        }
    }

    @objc public func presentPlayer(playerInstance: ZPPlayerProtocol,
                                    rootViewController: UIViewController,
                                    configuration: ZPPlayerConfiguration?,
                                    playableItems: [ZPPlayable]?) {
        let playableItem = playableItems?.first
        if let pluginModels = self.getPluginModels(playableItem),
            let pluginModel = pluginModels.first,
            let screenModel = ZAAppConnector.sharedInstance().genericDelegate.screenModelForPluginID(pluginID: pluginModel.identifier,
                                                                                                     dataSource: playableItem as? NSObject) {
            ZAAppConnector.sharedInstance().genericDelegate.hookManager().performPreHook(hookedViewController: playerInstance as? UIViewController,
                                                                                         screenID: screenModel.screenID,
                                                                                         model: playableItems as NSObject?) { continueFlow in
                if continueFlow {
                    playerInstance.presentPlayerFullScreen(rootViewController,
                                                           configuration: configuration)
                } else {
                    ZPPlayerManager.sharedInstance.lastActiveInstance = nil
                }
            }

        } else {
            playerInstance.presentPlayerFullScreen(rootViewController,
                                                   configuration: configuration)
        }
    }
}
