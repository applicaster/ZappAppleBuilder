//
//  ZAAppDelegateConnectorAudioSessionProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 02/10/2018.
//

import Foundation

public protocol ZAAppDelegateConnectorAudioSessionProtocol {

    func activateAudioSessionWithPlayback()
    func deactivateAudioSession()
    func temporaryEnablePlaybackCategoryMutingBackgroundAudio()
    func temporaryEnablePlaybackCategoryMutingBackgroundAudio(forItem item: AVPlayerItem?)
    func notifyBackgroundAudioToContinuePlaying()
}

