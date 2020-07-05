//
//  ZPLoginProviderProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 15/03/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//


public extension Notification.Name {
    static let ZPLoginProviderLoggedOut = NSNotification.Name("ZPLoginProviderLoggedOut")
}

@objc public enum ZPLoginOperationStatus: Int {
    case completedSuccessfully = 200
    case failed = 501
    case cancelled = 400
    
    public func logoutDescriptionDefaultValue() -> String {
        let retValue: String
        switch self {
        case .completedSuccessfully:
            retValue = "Logout successful"
        case .failed:
            retValue = "Logout failed"
        case .cancelled:
            retValue = "Logout cancelled"
        }
        return retValue
    }
    
    public func logoutDescriptionLocalizationKey() -> String {
        let retValue: String
        switch self {
        case .completedSuccessfully:
            retValue = "LogoutCompletedSuccessfully"
        case .failed:
            retValue = "LogoutFailed"
        case .cancelled:
            retValue = ""
        }
        return retValue
    }
}

@objc public protocol ZPLoginProviderProtocol: ZPAdapterProtocol {
    func login(_ additionalParameters: [String: Any]?, completion: @escaping ((_ status: ZPLoginOperationStatus) -> Void))
    func logout(_ completion: @escaping ((_ success: ZPLoginOperationStatus) -> Void))
    func isAuthenticated() -> Bool
    func isPerformingAuthorizationFlow() -> Bool
    @objc func getUserToken() -> String
    
    /**
     You can implement this method if you are allowing the token to be set from outside of the plugin.
     For example, in order to allow it to be set from a WebView via JS2Native commands.
     
     - parameter token: The token you would like to override the existing one with. nil will clear the current token.
     */
    @objc optional func setUserToken(token: String?)
}
