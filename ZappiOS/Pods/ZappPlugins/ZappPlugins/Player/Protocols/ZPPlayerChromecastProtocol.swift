//
//  ZPPlayerChromecastProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 25/09/2016.
//  Copyright © 2016 Applicaster. All rights reserved.
//

import Foundation

public protocol ZPPlayerChromecastProtocol: NSObjectProtocol {

    /**
     returns current playing media info dictionary
     */
    func chromecastGetCurrentPlayingMediaInfo() -> Any?
    
    /**
     returns current playing media id
     */
    func chromecastGetCurrentPlayingMediaId() -> String
    
    /**
     returns current playing media position
     */
    func chromecastGetCurrentPlayingMediaPosition() -> TimeInterval
    
    /**
     returns current playing media type
     */
    func chromecastGetCurrentPlayingMediaType() -> Int
    
    /**
     returns current playing media custom object
     */
    func chromecastGetCurrentPlayingMediaCustomObject() -> [String:NSObject]
    
    /**
     present extended player controls
     */
    func chromecastPresentExtendedPlayerControls()
    
    /**
     checking whenever extended player controls are presented
     */
    func chromecastIsExtendedPlayerControlsPresented() -> Bool
}
