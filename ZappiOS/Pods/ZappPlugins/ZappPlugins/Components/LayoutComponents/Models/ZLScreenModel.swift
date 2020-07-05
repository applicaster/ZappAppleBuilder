//
//  ZLScreenModel.swift
//  ComponentsSDK
//
//  Created by Anton Kononenko on 14/11/2016.
//  Copyright © 2016 Applicaster LTD. All rights reserved.
//

import Foundation

open class ZLScreenModel: ZLBaseModel {
    
    @objc open fileprivate(set) var screenID:String = ""
    @objc open fileprivate(set) var name:String = ""
    @objc open fileprivate(set) var style:ZLStyleBaseModel?
    @objc open fileprivate(set) var components: [ZLComponentModel]?
    @objc open fileprivate(set) var type:ZLScreenTypes = .general
    public internal(set) var dataSource: ZLDataSource = .empty
    @objc open fileprivate(set) var navigations:[ZLNavigationModel]?
    @objc open fileprivate(set) var isHomeScreen:Bool = false
    @objc open fileprivate(set) var isHomeOfflineScreen:Bool = false
    @objc open fileprivate(set) var supportsOffline:Bool = false
    @objc open fileprivate(set) var advertising:ZLScreenAdvertisingModel?
    @objc open fileprivate(set) var rules: [String: Any] = [:]
    @objc open fileprivate(set) var general: [String: Any] = [:]
    @objc open fileprivate(set) var hooksPlugins: [String: Any] = [:]
    
    public override init(object: [String : Any]) {
        super.init(object: object)
        parse()
    }
    
    func parse() {
        
        func fillStyleData(_ styleDict: [String: Any]?) {
            let familyName = familyNameFrom(styleDict)
            var newStyleDict: [String: Any] = [:]
            if let styleDict = styleDict {
                newStyleDict = styleDict
            }
            
            style = ZLStyleBaseModel(object: newStyleDict,
                                     family:familyName)
            
            if let parsedCompoentsArray = object[ZLScreenModelAPIKeys.component.rawValue] as? [[String: Any]] {
                components = parsedCompoentsArray.map({ZLComponentModel(object: $0,
                                                                        zappFamily: familyName)})
            }
        }
        
        func familyNameFrom(_ styleDict: [String: Any]?) -> String {
            var retVal = ""
            
            if let familyName = styleDict?[ZLStylesModelAPIKeys.family.rawValue] as? String  {
                retVal = familyName
            }
            
            return retVal
        }
        
        if let layoutComponentsDelegate = ZAAppConnector.sharedInstance().layoutComponentsDelegate {
            dataSource = layoutComponentsDelegate.dataSourceHelperParseDataSourceEnum(with: object)     
        }
        
        if let parsedName = object[ZLScreenModelAPIKeys.name.rawValue] as? String {
            name = parsedName
        }
        
        if let parsedID = object[ZLScreenModelAPIKeys.id.rawValue] as? String {
            screenID = parsedID
        }
        
        if let parsedType = typeInString() {
            type = ZLScreenTypes.typeByKey(parsedType)
        }
        
        if let parsedNavigations = object[ZLScreenModelAPIKeys.navigations.rawValue] as? [[String:Any]] {
            navigations = parsedNavigations.map{ ZLNavigationModel(object:$0) }
        }
        
        if let homeScreenState = object[ZLScreenModelAPIKeys.isHomeScreen.rawValue] as? Bool {
            isHomeScreen = homeScreenState
        }

        if let homeOfflineScreenState = object[ZLScreenModelAPIKeys.isHomeOfflineScreen.rawValue] as? Bool {
            isHomeOfflineScreen = homeOfflineScreenState
        }

        if let supportsOfflineState = object[ZLScreenModelAPIKeys.supportsOffline.rawValue] as? Bool {
            supportsOffline = supportsOfflineState
        }

        if let parsedRulesDict = object[ZLScreenModelAPIKeys.rules.rawValue] as? [String: Any] {
            rules = parsedRulesDict
        }
        
        var styleToParse: [String: Any]?
        if let parsedStyle = object[ZLScreenModelAPIKeys.styles.rawValue] as? [String: Any] {
           styleToParse = parsedStyle
        }
        
        if let advertisingDict = object[ZLScreenModelAPIKeys.advertising.rawValue] as? [String: Any] {
            advertising = ZLScreenAdvertisingModel(object: advertisingDict)
        }
        
        if let hooksPluginDict = object[ZLScreenModelAPIKeys.hooksPlugins.rawValue] as? [String: Any] {
            hooksPlugins = hooksPluginDict
        }
        
        if let parsedGeneralDict = object[ZLScreenModelAPIKeys.general.rawValue] as? [String: Any] {
            general = parsedGeneralDict
        }
        
        fillStyleData(styleToParse)
    }
    
    open func navigation(by type:ZLNavigationTypes) -> ZLNavigationModel? {
        return navigations?.filter { $0.type == type }.first
    }
    
    @objc open func navigationOfTypeMenu() -> ZLNavigationModel? {
        return navigations?.filter { $0.type == .menu }.first
    }
}

extension ZLScreenModel {
    @objc public func viewControllerStringFromScreenType() -> String {
        return type.viewControllerInString()
    }
    
    @objc public func typeInString() -> String? {
        return object[ZLScreenModelAPIKeys.type.rawValue] as? String
    }
    
    /// Check if screen is plugin
    ///
    /// - Returns: True if Plugin screen, otherwise false
    @objc public func isPluginScreen() -> Bool {
        return self.type == .plugin
    }
    
    @objc public func isEqualToScreenModel(_ object: Any?) -> Bool {
        guard let otherScreenModel = object as? ZLScreenModel else { return false }
        return (self == otherScreenModel && self.objectHashValue() == otherScreenModel.objectHashValue())
    }
    
    @objc public func objectJsonString() -> String? {
        guard let dataValue = try? JSONSerialization.data(withJSONObject: self.object, options: []) else {
            return nil
        }
        guard let stringValue = String(data: dataValue, encoding: .utf8) else {
            return nil
        }
        return stringValue
    }
    
    @objc public func objectHashValue() -> UInt {
        return (self.object as NSDictionary).hash()
    }
}
