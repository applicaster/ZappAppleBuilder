//
//  ZPAdapterNavBarProtocol.swift
//  NavigationBarPlugins
//
//  Created by Anton Kononenko on 01/12/2017.
//  Copyright © 2017 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public protocol ZPAdapterNavBarProtocol: class, ZPAdapterProtocol  {
    
    /// Instance of nav bar view
    var navBarView: UIView? { get }
    
    /// Define if navigation bar was created for lagecy mode
    var legacyMode:Bool {get}
    
    
    /// Prepare navigation bar plugin for the usage
    ///
    /// - Parameters:
    ///   - customizationHelper: Instance of Customization Helper
    ///   - completion: completion handler
    func prepareManager(customizationHelper: ZPNavigationBarCustomizationHelperDelegate,
                        completion:(_ success: Bool) -> Void)
    
    /// Customize navigation bar for current screen
    ///
    /// - Parameter model: model to customize
    func customizeForScreen(model: AnyObject?,
                            dataSource:AnyObject?)
    
    /// Ask navigation bar to update title
    func updateNavBarTitle()
    
    func setNavigationBarCloseButtonHidden(_ value: Bool)
    
    /// Delegate of the root container instance where nav bar placed
    weak var rootContainerDelegate: ZPRootViewContainerControllerDelegate? { get set }
    
    /// Instance of navigation bar manager delegate
    weak var navBarManagerDelegate: (ZPNavigationBarViewDelegate & ZPNavigationBarManagerDelegate)? { get set }
    
    /// Customization dict of the nav bar
    var customizationDictionary: [String : AnyObject]? { get }
    
    /// Currently presented view controller
    var currentViewController: UIViewController? { get set }
    
    @objc optional var customizationHelper: ZPNavigationBarCustomizationHelperDelegate? { get set }
    @objc optional var navigationBarButtonClassType: NavigationButton.Type? { get }
}

