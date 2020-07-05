//
//  ZLNavigationItem.swift
//  ZappLayoutsComponentsSDK
//
//  Created by Anton Kononenko on 20/02/2018.
//  Copyright © 2018 Anton Kononenko. All rights reserved.
//

import Foundation

public class ZLNavigationItem: ZLBaseModel {
    fileprivate(set) public var identifier:String?
    fileprivate(set) public var title: String?
    fileprivate(set) public var children:[ZLNavigationItem]?
    fileprivate(set) public var type: ZLNavigationItemTypes = .undefined
    fileprivate(set) public var style: [String:Any] = [:]
    fileprivate(set) public var assets: [String:Any] = [:]
    fileprivate(set) public var rules: [String:Any] = [:]
    fileprivate(set) public var dataSource: ZLDataSource = .empty
    fileprivate(set) public var data:(connected: Bool,
                                      targetID:String?,
                                      dataSource:(source:String,
                                      type:String)?) = (false, nil, nil)
    
    public override init(object: [String : Any]) {
        super.init(object: object)
        parse()
    }

    func parse() {
        if let id = object[ZLNavigationItemKeys.identifier] as? String {
            identifier = id
        }
        
        if let navigationItemTypeKey = object[ZLNavigationItemKeys.type] as? String {
            type = ZLNavigationItemTypes.typeByKey(navigationItemTypeKey)
        }
        
        if let title = object[ZLNavigationItemKeys.title] as? String {
            self.title = title
        }
        
        if let styleDict = object[ZLNavigationItemKeys.styles] as? [String: Any] {
            self.style = styleDict
        }
        
        if let assetsDict = object[ZLNavigationItemKeys.assets] as? [String: Any] {
            self.assets = assetsDict
        }
        
        if let rulesDict = object[ZLNavigationItemKeys.rules] as? [String: Any] {
            rules = rulesDict
        }
        
        if let childrenArray = object[ZLNavigationItemKeys.children] as? [[String: Any]] {
            var childModelsArray = [ZLNavigationItem]()
            childrenArray.forEach({ (childNavItemDict) in
                childModelsArray.append(ZLNavigationItem(object:childNavItemDict))
            })
            
            if childModelsArray.isEmpty == false {
                children = childModelsArray
            }
        }
      
        let connection = ZAAppConnector.sharedInstance().layoutComponentsDelegate.dataSourceHelperGetScreenConnection(with: object)
        data.connected = connection.connected
        data.targetID = connection.targetID
        
        if let dataDict = object[ZLNavigationItemKeys.dataSource] as? [String: AnyObject],
            let source = dataDict[ZLComponentDataSourceAPIKeys.source.rawValue] as? String,
            let type = dataDict[ZLComponentDataSourceAPIKeys.type.rawValue] as? String {
            data.dataSource = (source, type)
        }
        
        dataSource = ZAAppConnector.sharedInstance().layoutComponentsDelegate.dataSourceHelperParseDataSourceEnum(with: object)
    }
}
