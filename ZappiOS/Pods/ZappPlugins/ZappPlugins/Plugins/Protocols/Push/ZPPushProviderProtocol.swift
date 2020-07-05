//
//  ZPPushProviderProtocol.swift
//  Pods
//
//  Created by Miri on 23/11/2016.
//
//

import Foundation

@objc public protocol ZPPushProviderProtocol: ZPAdapterProtocol {

    /**
     add base parameters
     */
    func setBaseParameter(_ value:NSObject?, forKey key:String)

    /**
     configure provider
     */
    func configureProvider() -> Bool
    
    /**
     get the provider key
     */
    func getKey() -> String
    
    /**
     add tags to device
     */
    @objc optional func addTagsToDevice(_ tags: [String]?, completion: @escaping (_ success: Bool ,_ tags: [String]?) -> Void)
    
    /**
     remove tags from device
     */
    @objc optional func removeTagsToDevice(_ tags: [String]?, completion: @escaping (_ success: Bool, _ tags: [String]?) -> Void)
    
    /**
     get device's tag list
     */
    @objc optional func getDeviceTags() -> [String]?
    
    /**
     register Token with push server.
     */
    @objc optional func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data)
    
    /**
     register userNotificationSettings with push server
     */
    @objc optional func didRegisterUserNotificationSettings(_ notificationSettings: UIUserNotificationSettings)

}
