//
//  ZAAppDelegateConnectorConnectivityProtocol.swift
//  ZappPlugins
//
//  Created by Liviu Romascanu on 02/07/2018.
//

import Foundation

@objc public enum ZAConnectivityState:NSInteger {
    case offline   = 0
    case cellular  = 1
    case wifi      = 2
}

@objc public protocol ZAAppDelegateConnectorConnectivityListener {
    @objc func connectivityStateChanged(_ updatedStatus: ZAConnectivityState)
}

@objc public protocol ZAAppDelegateConnectorConnectivityProtocol {

    /**
     Show offline screen if needed
     */
    @objc func showOfflineScreenIfNeeded(on viewController: UIViewController & ZPUIBuilderScreenProtocol)
    @objc func showOfflineScreenIfNeeded(on legacyViewController: UIViewController, screenModel: ZLScreenModel?)
    @objc func bringOfflineScreenToFrontIfNeeded(on viewController: UIViewController)
    /**
     Get online status
     */
    @objc func isOnline() -> Bool
    /**
     Get offline status
     */
    @objc func isOffline() -> Bool
    /**
     Get current connectivity state
     */
    @objc func getCurrentConnectivityState() -> ZAConnectivityState
    
    /**
     Add listener to get calls for connectivity state changes
     */
    @objc func addConnectivityListener(_ listener: ZAAppDelegateConnectorConnectivityListener)
    
    /**
     Remove listener to get calls for connectivity state changes
     */
    @objc func removeConnectivityListener(_ listener: ZAAppDelegateConnectorConnectivityListener)
}
