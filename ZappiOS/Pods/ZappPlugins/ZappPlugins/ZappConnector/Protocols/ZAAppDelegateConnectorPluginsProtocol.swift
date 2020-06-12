//
//  ZAAppDelegateConnectorPluginsProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 11/11/2019.
//

import Foundation

@objc public protocol ZAAppDelegateConnectorPluginsProtocol {
    var analyticsPluginsManager: ZPAnalyticsPluginsManagerProtocol? {get}
    var generalPluginsManager: ZPGeneralPluginsManagerProtocol? {get}
    var broadcasterPickerPluginsManager: ZPBroadcasterPickerPluginsManagerProtocol? {get}
    var crashlogPluginsManager: ZPCrashlogPluginsManagerProtocol? {get}
    var loginPluginsManager: ZPLoginPluginsManagerProtocol? {get}
    var pushNotificationsPluginsManager: ZPPushNotificationsPluginsManagerProtocol? {get}
}

//managers protocols
@objc public protocol ZPAnalyticsPluginsManagerProtocol {
    @objc func getProviders() -> [ZPAnalyticsProviderProtocol]
    @objc func trackEvent(name: String, parameters: Dictionary<String, Any>)
    @objc func trackEvent(name: String, parameters: Dictionary<String, Any>, model: Any?)
    @objc func trackEvent(name: String?, action: String?, label: String?, value: Int)
    @objc func trackScreenView(screenTitle: String, parameters: Dictionary<String, Any>)
    @objc func trackEvent(name: String, parameters:  Dictionary<String, Any>?, timed: Bool)
    @objc func endTimedEvent(_ eventName: String, parameters: [String : Any]?)
    
    @objc func startManager(withAccountId accountId: String?)
    @objc func updateUserProfile(fbParamteters:[String: Any]?)
    @objc func setEventUserGenericProperties(_ userGenericProperties: [String : Any]?)
    @objc func setEventDefaultProperties(_ parameters: [String : Any]?)
    @objc func setUserProfileProperties(_ parameters: [AnyHashable : Any]?)
    @objc func isAnalyticsEnabled() -> Bool
    @objc func setAnalyticsEnabled(_ value: Bool)
    @objc func trackScreenView(withModelTitle modelTitle: String?)
    
    /*storage is dictionary that looks like:
    "analytics_storage" : {
    "default_event_properties": dictionary 1,
    "user_profile": dictionary 2,
    "standard_event_properties": dictionary 3,
    etc.
    }
    */
    //get specific dictionaries from storage
    @objc func userGenericProperties() -> [AnyHashable : Any]?
    @objc func defaultEventProperties() -> [AnyHashable : Any]?
}

@objc public protocol ZPGeneralPluginsManagerProtocol {
    @objc func adapter(by pluginId:String) -> ZPGeneralPluginProtocol?
    @objc func adapterClass(by pluginId:String) -> ZPGeneralPluginProtocol.Type?
    @objc func adapterConfigurationJson(by pluginId:String) -> NSDictionary?
    @objc func create(pluginType: ZPGeneralPluginsTypes) -> ZPGeneralPluginProtocol?
    @objc func getPluginsModels(forFamilyType family: ZPGeneralPluginsFamily) -> [ZPPluginModel]
    @objc func getPlugins(forFamilyType family: ZPGeneralPluginsFamily) -> [ZPGeneralPluginProtocol]
    @objc func getApplicationCustomActivities() -> [UIActivity]
}

@objc public protocol ZPBroadcasterPickerPluginsManagerProtocol {
    @objc func create() -> ZPBroadcasterPickerProviderProtocol?
}

@objc public protocol ZPCrashlogPluginsManagerProtocol {
    @objc func create() -> [CrashlogsPluginProtocol]?
}

@objc public protocol ZPLoginPluginsManagerProtocol {
    @objc func create() -> ZPLoginProviderProtocol?
    @objc func create(_ pluginId: String) -> ZPLoginProviderProtocol?
    @objc func createWithUserData() -> ZPLoginProviderUserDataProtocol?
    @objc func canResumeAuthorizationFlow(_ url: URL) -> Bool
    @objc func resumeAuthorizationFlow(_ url: URL)
}

@objc public protocol ZPPushNotificationsPluginsManagerProtocol {
    @objc func getProviders() -> [ZPPushProviderProtocol]
}
