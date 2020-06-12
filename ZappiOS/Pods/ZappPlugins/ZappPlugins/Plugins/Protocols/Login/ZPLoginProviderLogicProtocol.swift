//
//  ZPLoginProviderLogicProtocol.swift
//  Pods
//
//  Created by Reuven Levitsky on 06/07/2017.
//
//

import Foundation

/**
 This is API for login logic that is invoked by the login UI.
 You may use it in your login provider (Or anywhere you want). It defines a generic interface for a login procedure that can be used in most cases of login.
 The intension was that the implementation of this interface will be pure logic.
 For example, if we have a UI of react native with username password, and it needs some kind of an handler to be invoked when it actually wants to call a stranger APIs and perform a login.
 In this case, you would have sent the react (or any other pure ui component) an instance that implements this interface - and it can invoke this instance to make the request.
 For how to use this with react you may refer to `ZPLoginReactNativeBridge` class.
 */
@objc public protocol ZPLoginProviderLogicProtocol: NSObjectProtocol {
    
    /**
     This method is being called in order to start registration process.
     The completion should always be called when the process is done - no matter what is the result.
     */
    func register(params : [String: Any]?, completion: ((_ success: Bool, _ errorMessage: String?) -> Void)?)
    
    /**
     This method is being called in order to start login process.
     The completion should always be called when the process is done - no matter what is the result.
     */
    func login(params : [String: Any]?, completion: ((_ success: Bool, _ errorMessage: String?) -> Void)?)
    
    /**
     This method is being called in order to start recover password process.
     The completion should always be called when the process is done - no matter what is the result.
     */
    func recoverPassword(params : [String: Any]?, completion: ((_ success: Bool, _ errorMessage: String?) -> Void)?)
    
    /**
     This method is being called in order to start logout process.
     The completion should always be called when the process is done - no matter what is the result.
     */
    func logout(params : [String: Any]?, completion: ((_ success: Bool, _ errorMessage: String?) -> Void)?)
    
    /**
     This method is being called from the ui part in order to notify that the login process was done and successful.
     The completion should always be called when the process is done - no matter what is the result.
     */
    func loginDone(params : [String: Any]?, completion: ((_ success: Bool, _ errorMessage: String?) -> Void)?)
    
    /**
     This method is being called from the ui part in order to notify that the login process was cancelled.
     The completion should always be called when the process is done - no matter what is the result.
     */
    func loginCancelled(params : [String: Any]?, completion: ((_ success: Bool, _ errorMessage: String?) -> Void)?)
    
}
