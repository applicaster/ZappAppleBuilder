//
//  ZPAdapterRootProtocol.swift
//  Modular-App
//
//  Created by Anton Kononenko on 23/02/2016.
//  Copyright © 2016 Applicaster. All rights reserved.
//

import Foundation

@objc public protocol ZPAdapterRootProtocol: class, ZPAdapterProtocol  {    
    /**
        The object that acts as the data source of the root adapter protocol
     */
    var adapterDataSource: ZPAdapterRootDataSource? { get set }
    
    /**
     The object that acts as the delegation of the root adapter protocol
     */
    var adapaterDelegate: ZPAdapterRootDelegate? { get set }
    //MARK: Presentation Methods

    /**
        Adapter should prepare root controller for the usage
        
        - parameter completion: The block to execute after the preparation finishes. You may not specify nil for this parameter.
    */
    func prepareRoot(_ completion: @escaping (_ success: Bool) -> Void)
    
    /**
     Application Expected from RootViewController to present sender ViewController
     
     - parameter viewController: UIViewController instance that expected to be presented
     - parameter completion: The block to execute after the preparation finishes. You may specify nil for this parameter.
    */
    func presentViewController(_ viewController: UIViewController, completion: ((_ success: Bool) -> Void)?)
    
    /**
     Application Expected from RootViewController to present sender ViewController
     
     - parameter viewController: UIViewController instance that expected to be presented
     - parameter presentingNavigationControllerCompletion: intermidiate completion to set additional params to navigation controller

     - parameter completion: The block to execute after the preparation finishes. You may specify nil for this parameter.
     */
    func presentViewController(viewController: UIViewController, presentingNavigationControllerCompletion: ((_ navigationController: UINavigationController?) -> Void)?, completion: ((_ success:Bool) -> Void)?)
    
    /**
     Application Expected from RootViewController to present sender ViewController
     
     - parameter viewController: UIViewController instance that expected to be presented
     - parameter shouldEmbedIntoNavigationController: indication about a need to embed the vc into nav controller
     
     - parameter completion: The block to execute after the preparation finishes. You may specify nil for this parameter.
     */
    func presentViewController(viewController: UIViewController, shouldEmbedIntoNavigationController: Bool, completion: ((_ success: Bool) -> Void)?)
    
    /**
     Application Expected from RootViewController to push in current stack sender ViewController
     
     - parameter viewController: UIViewController instance that expected to be pushed
     - parameter completion: The block to execute after the preparation finishes. You may specify nil for this parameter.
     */
    func pushViewController(_ viewController: UIViewController, completion: ((_ success: Bool) -> Void)?)
    
    /**
     Application Expected from RootViewController to add as child sender ViewController
     
     - parameter viewController: UIViewController instance that expected to be added as child viewcontroller
     - parameter completion: The block to execute after the preparation finishes. You may specify nil for this parameter.
     */
    func addChildViewController(_ viewController: UIViewController, completion: ((_ success: Bool) -> Void)?)

    /**
     Application Expected from RootViewController to pop pushed view controller
     */
    func popViewController()
    
    /**
     The view controller that currently open in navigation interface.

     - return: UIViewController instance
     */
    func currentViewController() -> UIViewController?
    
    
    /// Active navigation Controller
    ///
    /// - Returns: Instance of current UINavigationController for active tab
    func activeNavigationController() -> UINavigationController?
    
    /**
     Func should navigate to Home(Main) navigation controller
     */
    func navigateToHomeScreen()

    /**
     Customize Navigation of the root
     
     - parameter data: object for customization
     */
    @objc optional func customizeRoot(with dataModel: AnyObject?)
   
    /**
     Expect to do some specific action that relevant for specific Root. Example: Open Side Menu
     
     - parameter data: object that relevant for specific action
     */
    @objc optional func performSpecialAction(_ data: AnyObject?)
    
    @objc optional func performSelectionOfRootItem(_ url: NSURL?)

    @objc optional func hasOfflineHomeItemInMenu() -> Bool
    
    /**
     Expect to do some specific action that relevant for the params. here we can handle any action we want to perform on the root using the params
     
     -parameter params: dictionary soring the url params used to perform the action Example: the tabPosition parameter is used to open the tab-bar on a specific tab
     */
    @objc optional func performActionForUrlSchemeParams(_ params:[String:Any]?)
}
