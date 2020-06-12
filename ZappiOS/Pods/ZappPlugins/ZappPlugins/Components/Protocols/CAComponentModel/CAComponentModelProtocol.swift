//
//  CAComponentModelProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 25/06/2018.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

@objc public protocol CAComponentModelProtocol : NSObjectProtocol, NSCopying, NSCoding {

    @objc var object:NSDictionary {get}

    @objc weak var parentModel:CAComponentModelProtocol? {get set}
    @objc var children:[CAComponentModelProtocol] {get set}
    @objc var uiTag:String? {get set}
    @objc var type:String? {get set}
    @objc var attributes:NSDictionary? {get set}
    @objc var actions:NSDictionary? {get set}
    @objc var style:NSDictionary? {get set}
    @objc var dataSource:NSObject {get set}
    @objc var componentLoaded:Bool {get}
    @objc var url:URL {get}
    
    
    /// Instance of the component that store information for create CAComponentModel
    @objc var baseComponentModel:ZLComponentModel? {get set}
    
    /// Instance of the component that store information about grouping that current CAComponentModel belong to
    @objc var groupComponentModel:ZLComponentModel? {get set}

    @objc func childsByGroups() -> [AnyObject]?
    @objc func uniqueChildren() -> [CAComponentModelProtocol]?
    @objc func setModel(_ model: NSObject)
    @objc func findChildModel(byUITag uiTag: NSString) -> CAComponentModelProtocol?
    @objc func topMostComponentModel() -> CAComponentModelProtocol?
    @objc func parseModel(data dataDictionary: NSDictionary) -> CAComponentModelProtocol?
}
