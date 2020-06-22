//
//  ZAAppDelegateConnectorIdentityProtocol.swift
//  ZappPlugins
//
//  Created by Avi Levin on 08/07/2018.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public protocol ZAAppDelegateConnectorIdentityProtocol {
    /**
     The unique identifier for this user.
     @return The unique identifier if one has been generated. <code>nil</code> otherwise.
     */
    @objc func getDeviceId() -> String?

    @objc func authorizationTokens() -> [String: AnyObject]?
    
    /**
     This method updates the authorization tokens file and deletes all the providers that are no longer received from the server.
     Be carefull when you call it and make sure this array is the exact one coming from the server and there wasn't a loading failure / weird HQME mode or something.
    
     @param authorizationProviders - NSArray containing objects from type APAuthorizationProvider.
     */
    @objc func updateAuthorizationTokens(withAuthorizationProviders authorizationProviders: [Any]?)
    
    @objc func isLoginPluginAuthenticated() -> Bool

    @objc func getLoginPluginToken() -> String
    
    @objc func getLoginPluginName() -> String
    
    @objc func login(_ additionalParameters: [String: Any]?, completion: @escaping (Bool) -> Void)
    
    @objc func logout(completion: @escaping (Bool) -> Void)
}
