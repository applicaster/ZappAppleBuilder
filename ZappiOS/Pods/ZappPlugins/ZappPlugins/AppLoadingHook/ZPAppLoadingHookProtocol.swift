//
//  ZPHookProtocol.swift
//  Pods
//
//  Created by Miri on 19/03/2017.
//
//

import Foundation
import ZappCore

/* 
   This protocol should be implemented by plugin that need to add some logic before application load data and before rootViewController presented. example: login plugin will implement this inteface in order to make login flow before application data launched.
*/

@objc public protocol ZPAppLoadingHookProtocol: ZPAdapterProtocol {
    /*
     This method called after Plugins loaded locally, but the account load failed
     */
    @objc optional func executeOnFailedLoading(completion: (() -> Void)?)
    
    /*
       This method called after Plugins loaded, and also after initial account data retrieved, you can add logic that not related to the application data.
    */
    @objc optional func executeOnLaunch(completion: (() -> Void)?)
    
    /*
       This method called after all the data loaded and before viewController presented.
    */
    @objc optional func executeOnApplicationReady(displayViewController: UIViewController?, completion: (() -> Void)?)
    
    /*
     This method called after viewController is presented.
     */
    @objc optional func executeAfterAppRootPresentation(displayViewController: UIViewController?, completion: (() -> Void)?)

    /*
     This method called when the application:continueUserActivity:restorationHandler is called.
     */
    @objc optional func executeOnContinuingUserActivity(_ userActivity: NSUserActivity?, completion: (() -> Void)?)
    
}
