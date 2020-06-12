//
//  ZPChromecastProtocol.swift
//  ZappGeneralPluginsSDK
//
//  Created by Anton Kononenko on 9/13/18.
//  Copyright © 2018 Applicaster. All rights reserved.
//

import Foundation

public let kChromecastReceiverAppIdKey = "chromecast_app_id"
public let kChromecastIconColorKey = "chromecast_icon_color"
public let kChromecastPosterPlayerKey = "chromecast_poster"
public let kChromecastPlayerControlIconColorKey = "player_chromecast_icon_color"
public let kPlayableAnalyticsInfo = "playableAnalyticsParams"
public let kCustomPlayableAnalyticsInfo = "customPlayableAnalyticsParams"

public let kChromecastButtonTag = [kChromecastIconColorKey: 0,
                                   kChromecastPlayerControlIconColorKey: 1]

public enum ChromecastButtonOrigin:String {
    case appNavbar = "Navbar"
    case playerNavbar = "Fullscreen Player"
    case expendedNavbar = "Chromecast Intermediate Screen"
}

public struct GAChromecastPlugingKeys {
    public static let pluginIdentifier = "chromecast_generic"
    public static let kChromecastApplicationID = "chromecast_app_id"
    public static let kChromecastPosterURL = "chromecast_poster"
}

public struct ChromecastButtonIcons {
    public static let active = "chromecast_custom_icon_active"
    public static let inactive = "chromecast_custom_icon_inactive"
    public static let animation = "chromecast_custom_icon_animation"
}


public protocol ZPChromecastProtocol {
    var lastActiveChromecastButton: ChromecastButtonOrigin? {get set}
    var triggerdChromecastButton: ChromecastButtonOrigin? {get set}
    var containerViewEventsDelegate: Any? {get set}
    
    func prepareChromecastForUse(fallbackApplicationId:String?,
                                 fallbackPosterURLString:String?) -> Bool
    func hasConnectedCastSession() -> Bool
    func createChromecastButton(frame:CGRect, customIcons: [String: [UIImage]]?) -> UIButton
    func createChromecastButton(frame:CGRect) -> UIButton
    func presentCastInstructionsViewControllerOnce(withCastButton castButton:UIButton)
    func defaultExpandedMediaControlsViewController() -> UIViewController?
    func getShouldPresentIntroductionScreen() -> Bool
    func hasAvailableChromecastDevices() -> Bool
}

public protocol ZPChromecastPluginConfiguration {
    func shouldShowMiniControls() -> Bool
}

public protocol ZPChromecastMiniPlayerViewControllerProtocol: ZPChromecastProtocol {
    func createMiniPlayerViewController()
    func getMiniMediaControlsViewController() -> UIViewController?
    func uninstallMiniPlayerViewController()
    func updateVisibilityOfMiniPlayerViewController()
}

public protocol ZPChromecastExtendedPlayerControlsProtocol: ZPChromecastProtocol {
    func play(playableItems: NSArray,  playPosition: TimeInterval)
    func extendedPlayerControlsOrientationMask() -> UIInterfaceOrientationMask
    func getExpandedPlayerControlsViewController() -> UIViewController
    func getInlinePlayerControlsViewController() -> UIViewController
    func getMiniPlayerControlsViewController() -> UIViewController?
    func presentExtendedPlayerControls()
    func canShowPlayerBeforeCastSync() -> Bool
}
