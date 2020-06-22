//
//  ZLNavigationModel.swift
//  ZappLayoutsComponentsSDK
//
//  Created by Anton Kononenko on 27/11/2017.
//  Copyright © 2017 Anton Kononenko. All rights reserved.
//

import Foundation

open class ZLNavigationModel: ZLBaseModel {
    fileprivate(set) public var identifier:String?
    fileprivate(set) public var type: ZLNavigationTypes = .undefined
    fileprivate(set) public var assets: [String:Any] = [:]
    fileprivate(set) public var style: [String:Any] = [:]
    fileprivate(set) public var rules: [String:Any] = [:]
    fileprivate(set) public var dataSource: ZLDataSource = .empty
    fileprivate(set) public var navItems:[ZLNavigationItem]?
    fileprivate(set) public var navigationType:String?

    public override init(object: [String : Any]) {
        super.init(object: object)
        parse()
    }
    
    func parse() {
        if let id = object[ZLNavigationsKeys.id.rawValue] as? String {
            identifier = id
        }
        
        if let navigationTypeKey = object[ZLNavigationsKeys.type.rawValue] as? String {
            type = ZLNavigationTypes.typeByKey(navigationTypeKey)
        }
        
        if let assetsDict = object[ZLNavigationsKeys.assets.rawValue] as? [String: Any] {
            self.assets = assetsDict
        }
        
        if let styleDict = object[ZLNavigationsKeys.styles.rawValue] as? [String:Any] {
            style = styleDict
        }
        
        if let rulesDict = object[ZLNavigationsKeys.rules.rawValue] as? [String:Any] {
            rules = rulesDict
        }
        
        if let navigationTypeString = object[ZLNavigationsKeys.navigationType.rawValue] as? String {
            navigationType = navigationTypeString
        }
        
        if let navigationItemsDict = object[ZLNavigationsKeys.navigationItems.rawValue] as? [[String: Any]] {
            var items = [ZLNavigationItem]()
            navigationItemsDict.forEach({ (itemDict) in
                items.append(ZLNavigationItem(object: itemDict))
            })
            
            if items.isEmpty == false {
                navItems = items
            }
        }
            
        dataSource = ZAAppConnector.sharedInstance().layoutComponentsDelegate.dataSourceHelperParseDataSourceEnum(with: object)
    }
}

