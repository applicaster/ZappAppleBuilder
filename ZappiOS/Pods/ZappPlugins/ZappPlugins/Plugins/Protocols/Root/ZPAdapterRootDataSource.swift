 //
//  ZPAdapterRootDataSource.swift
//  Zapp-App
//
//  Created by Anton Kononenko on 17/04/16.
//  Copyright © 2016 Applicaster LTD. All rights reserved.
//

import Foundation
 
@objc public protocol ZPAdapterRootDataSource {
    
    /**
     Request create viewController with params
     
     - parameter  model: APModel instance that will be used as viewController data source. Also models ui_tag property may be used for creation specific screen
     - parameter metaData: APCollectionChildMetadata instance used to pass meta data from APCollection for APModel that used for datasource
     
     - returns: UIViewController instance or nil in case creation problem
     */
    func viewController(_ model: AnyObject?, metaData: AnyObject?) -> UIViewController?
    
    /**
     Request create viewController with params
     
     - parameter  screenType: Screen id in rivers.json
     - parameter  model: APModel instance that will be used as viewController data source.
     - parameter itemName: title of the screen
     
     - returns: UIViewController instance or nil in case creation problem
     */
    func viewController(screenType:String,
                        model: Any?,
                        itemName: String?) -> UIViewController?
    
    /**
     - returns: Expected UIInterfaceOrientationMask for rootViewController
     */
    func rootInterfaceOrientation() -> UIInterfaceOrientationMask
    
    /**
     - returns: NavigationBarmanager Instance
     */
    func navigationBarManager() -> (ZPNavigationBarManagerProtocol & ZPAdapterNavBarProtocol)?
    
    /**
     - returns: Style dictionary
     */
    func getStyleParamsByStyleName(_ style: String) -> NSDictionary
    
    /**
     - returns: Status bar settings dictionary
     */
    func getStatusBarStateSettings() -> NSDictionary
    
    
    /// UIBuilder model for Root Menu
    ///
    /// - Returns: Instance of ZPNavigationModel
    func homeNavigationModel() -> Any?
}
