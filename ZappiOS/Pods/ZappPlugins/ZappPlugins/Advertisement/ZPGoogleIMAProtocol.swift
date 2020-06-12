//
//  ZPGoogleIMAProtocol.swift
//  ZappPlugins
//
//  Created by Roman Karpievich on 2/6/19.
//

import Foundation
import AVFoundation

@objc public class GoogleIMAPlugingKeys: NSObject {
    
    @objc public static func pluginIdentifier() -> String {
        return "google_ima_generic"
    }
}

@objc public protocol ZPGoogleIMAProtocol {
    
    /**
     *  Reflects if the ad in pressent on screen,
     */
    var hasOnScreenAd: Bool {get}
    
    /// Are the ads being loaded.
    var isAdLoading: Bool {get}
    
    /// Called when an ad is ready to play.
    var pause: () -> Void {get set}
    
    /// Called when an ad has finished or an error occurred during the playback.
    var play: () -> Void {get set}
    
    /**
     *  Plays google ima vast ad on top of the player view controller.
     *
     *  @param adTagURL             VAST IMA adUrl
     *  @param playerViewController Applicaster player view controller that contains avplayer.
     *  @param displayPlayerCommercialsCompletion completion block that will called in the following cases:
     *  preroll or postroll finised and if the playlist (postroll) finished.
     *  @param completionHandler completionHandler
     */
    @objc func playIMA(withAdTagURL adTagURL: String,
                 playerViewController: UIViewController,
                 displayPlayerCommercialsCompletion: (Bool) -> Void,
                 completionHandler: (_ success: Bool, _ canceled: Bool, _ analyticParameters: NSDictionary) -> Void)
    
    /**
     *  Setup playlist that listen to time events of the player.
     *  Playlist maycontain VAST of Prerolls, Midrolls, Postrolls, each VAST may conatin multiple number of ads.
     *
     *  @param adTagURL             VAST IMA adUrl
     *  @param playerViewController Applicaster player view controller that contains avplayer.
     *  @param player               Instance of AVPlayer.
     */
    @objc func setupIMAPlaylist(adTagURL: String,
                          withPlayerViewController playerViewController: UIViewController,
                          player: AVPlayer,
                          completionHandler: (_ success: Bool, _ canceled: Bool, _ analyticParameters: NSDictionary) -> Void)
    
    /**
     *  Unload current ads manager.
     *
     */
    @objc func unloadAdsManager(_ success: Bool)
}
