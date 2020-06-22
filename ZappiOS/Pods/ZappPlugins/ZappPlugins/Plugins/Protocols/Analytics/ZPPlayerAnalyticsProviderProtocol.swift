//
//  ZPPlayerAnalyticsProviderProtocol.swift
//  ZappPlugins
//
//  Created by Pablo Rueda on 15/12/2017.
//  Copyright © 2017 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public protocol ZPPlayerAnalyticsProviderProtocol: ZPAnalyticsProviderProtocol {
    
    /// Starts to track events related with the player.
    ///
    /// - Parameter player: player whose analytics we want to track. Can be any class but usually will be an AVPlayer.
    @objc optional func startTrackingPlayerEvents(forPlayer player: Any)
    
    /// Stops to track events related with the player.
    @objc optional func stopTrackingPlayerEvents()
    
    /// Starts a new streaming session.
    ///
    /// - Parameter url: URL of the streaming session that you are about to start.
    @objc optional func startStreaming(withURL url: URL)
    
    /// Stops the streaming session.
    @objc optional func stopStreaming()
}
