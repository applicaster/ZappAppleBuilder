//
//  ZPPlayable.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 28/06/2016.
//  Copyright © 2016 Applicaster. All rights reserved.
//

import Foundation

/**
 A protocol for playable items.
 An object can be played by the <code>APPlayerController</code> if it conforms to this protocol.
 */
@objc public protocol ZPPlayable : NSObjectProtocol {

    /**
     The name of the item to be used for the different player features.
     */
    func playableName() -> String!

    /**
     The name of the item to be used for the different player features.
     */
    func playableDescription() -> String!

    /**
     A path to the content video.
     */
    func contentVideoURLPath() -> String!

    /**
     Get AssetURL for playable
     */
    func assetUrl() -> AVURLAsset?

    /**
     A path to the overlay HTML.
     */
    func overlayURLPath() -> String!

    /**
     Indicates if the item is being played live or not.
     */
    func isLive() -> Bool
    
    /**
     Indicates if the item is free or not.
     */
    @objc func isFree() -> Bool

    /**
     The public page for this playable.
     */
    func publicPageURLPath() -> String!

    /**
     @return the parameters for this playable to be sent for all the analytics events.
     */
    @available(OSX 10.0, *)
    func analyticsParams() -> [AnyHashable: Any]!

    /**
     The last time reached during playback. This will need to be set by the <APPlayerController>.
     */
    @objc optional var lastPlayedTime: TimeInterval { get set }

    /**
     The item's duration. This will need to be set by the <APPlayerController>.
     */
    @objc optional var playbackDuration: TimeInterval { get set }

    /**
     A path to the image preroll.
     */
    @objc optional func prerollSplashURLPath() -> String!

    /**
     A path to the video preroll.
     */
    @objc optional func prerollVideoURLPath() -> String!

    /**
     Implement this method in order for the player to know if your playable is capture moment enabled.
     */
    @objc optional func captureMomentEnabled() -> Bool

    /**
     Implement this method in order to supply more params for the different features to have.
     */
    @objc @available(OSX 10.0, *)
    optional func extraPlayableInfo() -> [AnyHashable: Any]!

    /**
     The Facebook object ID for the Facebook comments feature.
     */
    @objc optional func facebookObjectID() -> String!

    /**
     Is video a 360 degress video
     */
    @objc optional var is360Video: Bool { get }

    /**
     Is audio only stream
     */
    @objc optional var isAudioOnly: Bool { get }
    
    /**
     specific player identifier hash
     */
    @objc optional var playerExternalIdentifier: NSString { get set }

    /**
     Skip ads for this playable.
     */
    @objc optional var shouldSkipAds: Bool { get set }
    
    /**
     Is video a playlist.
     */
    @objc optional var isPlaylist: Bool { get set }
    
    /**
     Identifier
     */
    @objc var identifier: NSString? { get }
    
    /**
     Implement this variable for all Playable objects with extensions fields
     */
    @objc var extensionsDictionary: NSDictionary? { get set }
}

