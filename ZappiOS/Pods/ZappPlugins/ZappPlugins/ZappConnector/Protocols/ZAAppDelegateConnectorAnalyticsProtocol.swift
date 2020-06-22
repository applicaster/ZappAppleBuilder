//
//  ZAAppDelegateConnectorAnalyticsProtocol.swift
//  ZappAppConnector
//
//  Created by Simon Borkin on 2/9/18.
//

import Foundation

// Allows lower layer classes like plugins to send analytics using the analytics providers set for the app
@objc public protocol ZAAppDelegateConnectorAnalyticsProtocol {
    // The event will be sent using all the analytics providers added as plugins
    // It might be the event is blacklisted in the provider plugin configuration, in that case it will be ignored
    @objc func trackEvent(name: String,
                          parameters: Dictionary<String, Any>)
    @objc func trackEvent(name: String,
                          parameters: Dictionary<String, Any>,
                          model: Any?)
    @objc func trackEvent(name: String?,
                          action: String?,
                          label: String?,
                          value: Int)
    
    // Sends an event with the parameter title indicating the selected screen was presented to the user
    // Each provider names the event itself differently (for example Page View)
    // The event will also include a Trigger parameter which indicates the title of the previous screen
    @objc func trackScreenView(screenTitle: String,
                               parameters: Dictionary<String, Any>)
    @objc func trackEvent(name: String,
                          parameters:  Dictionary<String, Any>?,
                          timed: Bool)
    @objc func endTimedEvent(_ eventName: String,
                            parameters: [String : Any]?)
    
    @objc func startManager(withAccountId accountId: String?)
    @objc func updateUserProfile(fbParamteters:[String: Any]?)
    @objc func setEventUserGenericProperties(_ userGenericProperties: [String : Any]?)
    @objc func setEventDefaultProperties(_ parameters: [String : Any]?)
    @objc func setUserProfileProperties(_ parameters: [AnyHashable : Any]?)
    @objc func isAnalyticsEnabled() -> Bool
    @objc func setAnalyticsEnabled(_ value: Bool)
    @objc func trackScreenView(withModelTitle modelTitle: String?)
}
