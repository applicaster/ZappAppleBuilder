//
//  ZPPlayerConfiguration.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 10/05/2016.
//  Copyright © 2016 Applicaster Ltd. All rights reserved.
//

import Foundation

@objc public enum ZPPlayerState:Int {
    case undefined
    case interruption
    case playing
    case paused
    case onHold
    case stopped
}

public extension Notification.Name {
    static let ZPPlayerItemDidFinishPlaying = NSNotification.Name("ZPPlayerItemDidFinishPlaying")
    static let ZPPlayerPlaybackWasInterrupted = NSNotification.Name("ZPPlayerPlaybackWasInterrupted")
    static let ZPPlayerDidDismissed = NSNotification.Name("ZPPlayerDidDismissed")
    static let ZPPlayerPlaybackStateChanged = NSNotification.Name("ZPPlayerPlaybackStateChanged")
    static let ZPPlayerPlaybackPositionChanged = NSNotification.Name("ZPPlayerPlaybackPositionChanged")
}

public struct ZPPlayerNotificationKeys {
    public static let playbackPosition = "playbackPosition"
    public static let playbackDuration = "playbackDuration"
    public static let playbackProgress = "playbackProgress"
}

open class ZPPlayerConfiguration : NSObject{
    public struct Keys {
        public static let startTime = "startTime"
        
        /// Key for the player to ignore default subscription
        public static let ignoreDefaultSubscription = "ignore_default_subscription"
        
        /// Enable share button in the player
        public static let shareButtonEnabled = "share_enabled"
    }
    
    /**
     start from offset <code>NSTimeInterval</code>.
     */
    @objc open var startTime : TimeInterval = -1

    /**
     play until time <code>NSTimeInterval</code>.
     */
    @objc open var endTime : TimeInterval = -1

    /**
     Whether the presentation would be animated or not. Default is true.
     */
    @objc open var animated : Bool = true

    /**
     Should the player wait for the buffer to fill some amount of data before playing, this will help prevent stalling during the playback.
     Note it will cause a delay when starting the playback.
     */
    open var fillBufferToMinimizeStalling : Bool = true

    /**
     Should player start muted until clicked for the first time.
     */
    open var playerShouldStartMuted : Bool = false
    
    /**
     You can use this dictionary in order to pass to your player some custom configuration.
     */
    @objc open var customConfiguration : Dictionary<String, Any>?

    /**
     @param params a dictionary with keys from <code>ZPPlayerConfiguration.Keys</code> struct
     @return <code>ZPPlayerConfiguration</code> with properties set using the corresponding values from the dictionary
     */
    public convenience init(params: NSDictionary) {
        self.init()
        
        if let rawStartTime = params[Keys.startTime] as? String, let startTime = TimeInterval(rawStartTime) {
            self.startTime = startTime
        }
    }
}

@objc public protocol ZPPlayerProtocol: NSObjectProtocol {

    // MARK: - Static functions
    /**
     Initialization of player instance view controller with or without specifying item to play
     */
    @objc optional static func pluggablePlayerInit(playableItem item: ZPPlayable?) -> ZPPlayerProtocol?

    /**
     Initialization of player instance view controller with or without specifying items to play and configuration json
     */
    @objc optional static func pluggablePlayerInit(playableItems items: [ZPPlayable]?, configurationJSON: NSDictionary?) -> ZPPlayerProtocol?

    /**
     Returns the view controller of current playable player instance.
     This ViewController should not be presented, instead use the dedicated presentPlayerFullScreen method for full screen.
     */
    func pluggablePlayerViewController() -> UIViewController?

    /**
     Returns the type of pluggablePlayer instance
     */
    @objc optional func pluggablePlayerType() -> ZPPlayerType
    @objc optional static func pluggablePlayerType() -> ZPPlayerType
    /**
     Returns the playing state of the player
     */
    func pluggablePlayerIsPlaying() -> Bool

    /**
     Returns the first playable item instance.
     */
    @objc optional func pluggablePlayerFirstPlayableItem() -> ZPPlayable?

    /**
     Returns the current playable items instance.
     */
    @objc optional func pluggablePlayerPlayableItems() -> [ZPPlayable]?

    //--------------------------- Available only in Full screen mode ---------------------------//

    /**
     Call this method to start playing the given playable. Because this is a full screen player after calling this method the app doesn't have control of it's flow.
     */
    func presentPlayerFullScreen(_ rootViewController: UIViewController, configuration: ZPPlayerConfiguration?)
    @objc optional func presentPlayerFullScreen(_ rootViewController: UIViewController, configuration: ZPPlayerConfiguration?, completion: (() -> Void)?)

    //--------------------------- Available only in Inline mode ---------------------------//

    /**
     This method should add the player into the given container
     */
    func pluggablePlayerAddInline(_ rootViewController: UIViewController, container : UIView)

    /**
    This method should add the player into the given container with Configuration
    */
    @objc optional func pluggablePlayerAddInline(_ rootViewController: UIViewController, container : UIView, configuration:ZPPlayerConfiguration?)

    /**
     This method should remove the player from it's container
     */
    func pluggablePlayerRemoveInline()

    /**
     Pauses active player
     */
    func pluggablePlayerPause()

    /**
     Stop playing loaded item
     */
    func pluggablePlayerStop()
    
    /**
     Resume playing loaded item
     */
    @objc optional func pluggablePlayerResume()
    
    /**
     Start playing
     */
    func pluggablePlayerPlay(_ configuration: ZPPlayerConfiguration?)

    /**
     Start playing new playable items
     */
    @objc optional func pluggablePlayerPlay(_ items: [ZPPlayable]?, configuration: ZPPlayerConfiguration?)

    /**
     implement this method if you would like your player to ignore the default implementation of creating the subscription page for vod items, and use it's own when starting to play.
     */
    @objc optional func pluggablePlayerCanHandleSubscription() -> Bool
    
    
    /// Define to enable share button in the player
    ///
    /// - Returns: trie will enable share button
    @objc optional func shareButtonEnabled() -> Bool
    
    @objc optional func setOnHold(isOnHold: Bool)
    @objc optional func playerState() -> ZPPlayerState
    
    @objc optional func playbackPosition() -> TimeInterval
    @objc optional func playbackDuration() -> TimeInterval

    /**
     Once an item starts playing, seeks the playback position to the specified seconds (each player decides the behavior when the new position is out of range)
     */
    @objc optional func pluggablePlayerSeekTo(seconds: TimeInterval)
    
    /**
     Move the current position by the specified delta, negative values are also supported
     */
    @objc optional func pluggablePlayerSeekBy(delta: TimeInterval)

    /**
     Starts playing the previous item in the playlist, if currently the first item is playing, each player decides the action (might reset it, might ignore, or stop playback)
     */
    @objc optional func pluggablePlayerMoveBackward()
    
    /**
     Starts playing the next item in the playlist, if currently the last item is playing, each player decides the action (might reset it, might ignore, or stop playback)
     */
    @objc optional func pluggablePlayerMoveForward()
    
    /**
     Checks if the player can play given APAtomEntry
     */
    @objc optional func pluggablePlayerAnalyticsParams(for atomEntryPlayable: ZPAtomEntryPlayableProtocol) -> [String:Any]
}
