//
//  ZLComponentModel.swift
//  ComponentsSDK
//
//  Created by Anton Kononenko on 14/11/2016.
//  Copyright © 2016 Applicaster LTD. All rights reserved.
//

import Foundation
import ZappCore

open class ZLComponentModel:ZLBaseModel {
    open internal(set) var identifier:String?
    public internal(set) var type: ZLComponentTypeProtocol?
    public internal(set) var style: ZLComponentStyleModel?
    public internal(set) var rules: [String: Any] = [:]
    public internal(set) var dataSource: ZLDataSource = .empty
    public internal(set) var connection:(connected: Bool, targetID:String?) = (false, nil)
    public internal(set) var advertising: ZLBaseModel?
    public internal(set) var components: [ZLComponentModel]?
    public init(object: [String: Any],
         zappFamily: String) {
        
        super.init(object: object)
        parse(zappFamily)
    }
    
    static func ==(lhs: ZLComponentModel, rhs: ZLComponentModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    
    /// Return string value of component type
    ///
    /// Note: Was done to get from objC type of component
    /// - Returns: Name of component or undifined
    @objc public func componenType() -> String {
        return type?.componentType() ?? "undefined"
    }
}

extension ZLComponentModel {
    func parse(_ zappFamily: String) {
        
        if let id = object[ZLComponentAPIKeys.id.rawValue] as? String {
            identifier = id
        }
        
        if let parsedTypeString = object[ZLComponentAPIKeys.type.rawValue] as? String {
            type = ZAAppConnector.sharedInstance().layoutComponentsDelegate.createComponentType(by: parsedTypeString)
        }
        
        if let parsedRulesDict = object[ZLComponentAPIKeys.rules.rawValue] as? [String: Any] {
            rules = parsedRulesDict
        }
        if let layoutComponentsDelegate = ZAAppConnector.sharedInstance().layoutComponentsDelegate {
            dataSource = layoutComponentsDelegate.dataSourceHelperParseDataSourceEnum(with: object)
            connection = layoutComponentsDelegate.dataSourceHelperGetScreenConnection(with: object)
            style = parseStyle(zappFamily)
            advertising = layoutComponentsDelegate.createComponentAdvertisingModel(with: object)
        }
        if let parsedCompoentsArray = object[ZLComponentAPIKeys.component.rawValue] as? [[String: Any]] {
            components = parsedCompoentsArray.map({ZLComponentModel(object: $0,
                                                                    zappFamily: zappFamily)})
        }
    }
    
    func parseStyle(_ zappFamily: String) -> ZLComponentStyleModel? {
        var retVal:ZLComponentStyleModel?
        
        if let parsedStyleDict = object[ZLComponentAPIKeys.styles.rawValue] as? [String: Any] {
            let newStyle = ZLComponentStyleModel(object: parsedStyleDict,
                                                 family: zappFamily)
            retVal = newStyle
        }
        
        return retVal
    }
    
    
}

extension ZLComponentModel {
    public var pluginModel: ZPPluginModel? {
        guard let componentType = self.type?.componentType() else {
            return nil
        }
        return ZPPluginManager.pluginModels()?.first(where: { $0.identifier == componentType })
    }
}
