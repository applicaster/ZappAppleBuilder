//
//  ZPAnalyticsProviderProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 12/07/2016.
//  Copyright © 2016 Applicaster Ltd. All rights reserved.
//

import Foundation
import ZappCore

@objc public protocol ZPAnalyticsProviderProtocol: ZPAdapterProtocol {
    
    
    /**
     get max allowed parameters
     */
    func analyticsMaxParametersAllowed() -> Int
    
    /**
     add base parameters
     */
    func setBaseParameter(_ value:NSObject?, forKey key:String)
    
    /**
     sort properties alphabetically and cut by limitation
     */
    func sortPropertiesAlphabeticallyAndCutThemByLimitation(_ properties: [String:NSObject]) -> [String:NSObject]
    
    /**
     create provider with settings - getting provider data from allProvidersSetting, assign it to provider and calls to configureProvider
     */
    func createAnalyticsProvider(_ allProvidersSetting: [String:NSObject]) -> Bool
    func configureProvider() -> Bool
    
    /**
     get the provider key
     */
    func getKey() -> String
    
    /**
     update generic user profile properties
     */
    @objc func updateGenericUserProperties(_ genericUserProfile: [String:NSObject])
    
    /**
     update default event properties
     */
    @objc func updateDefaultEventProperties(_ eventProperties: [String:NSObject])
    
    
    /**
     trackCampaignParamsFromUrl - tracking url params if implemented on one of the plugins
     */
    @objc optional func trackCampaignParamsFromUrl(_ url:NSURL)

    /**
     trackEvents - track event functions
     */
    @objc optional func trackEvent(_ eventName:String)
    @objc optional func trackEvent(_ eventName:String, parameters:[String:NSObject])
    @objc optional func trackEvent(_ eventName:String, parameters:[String:NSObject], model: Any?)
    @objc optional func trackEvent(_ eventName:String, message:String, exception:NSException)
    @objc optional func trackEvent(_ eventName:String, message:String, error:NSError)
    @objc optional func trackEvent(_ eventName:String, timed:Bool)
    @objc optional func trackEvent(_ eventName:String, parameters:[String:NSObject], timed:Bool)
    @objc optional func trackEvent(_ eventName:String, action:String, label:String, value:Int)
    @objc optional func trackError(_ errorID:String, message:String, exception:NSException)
    @objc optional func trackError(_ errorID:String, message:String, error:NSError)
    @objc optional func endTimedEvent(_ eventName:String, parameters:[String:NSObject])
    @objc optional func trackScreenView(_ screenName:String, parameters:[String:NSObject])

    
    @objc func trackEvent(_ eventName:String, parameters:[String:NSObject], completion: ((_ wasSent:Bool, _ logText:String?) -> Void)?)
    @objc func trackScreenView(_ screenName:String, parameters:[String:NSObject], completion: ((_ wasSent:Bool, _ logText:String?) -> Void)?)
    @objc func presentToastForLoggedEvent(_ eventDescription:String?)
    @objc func canPresentToastForLoggedEvents() -> Bool
    @objc func shouldTrackEvent(_ eventName:String) -> Bool
    
    
    /**
     sets the user profile
     */
    @objc @available(*, deprecated, message: "Will be not in use starting 'ZappAnalyticsPlugins 0.5.0', use setUserProfile(genericUserProperties, piiUserProperties) instead")
    optional func setUserProfile(parameters:[String:NSObject])
    
    @objc optional func setUserProfile(genericUserProperties dictGenericUserProperties: [String:NSObject], piiUserProperties dictPiiUserProperties: [String:NSObject])
    
    /**
     sets the Push Notification deviceToken
     */
    @objc optional func setPushNotificationDeviceToken(_ deviceToken:Data)
}
