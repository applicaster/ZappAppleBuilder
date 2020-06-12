//
//  ZPReactNativeBaseProvider.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 09/01/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//

import UIKit
import ZappCore

open class ZPReactNativeBaseProvider : UIViewController, ZPReactNativeProviderProtocol, ZPPluginPresenterProtocol, ZPPluggableScreenProtocol {
    public var screenPluginDelegate: ZPPlugableScreenDelegate?
    
    public private(set) var screenModel:ZLScreenModel?
    
    fileprivate struct PluggableScreen {
        // Init props for screen plugin
        static let screenModelInitPropsKey = ZPReactNativeManager.Constants.uiBuilderScreenModelParam
        static let dataSourceInitPropsKey = ZPReactNativeManager.Constants.dataSourceModelParam
    }
    
    var className: String {
        return String(describing: type(of: self))
    }
    
    public let bundleIdentifier: String = ConnectorResolver.bundleIndentifier() ?? ""
    public let isIpad = UIDevice.current.userInterfaceIdiom == .pad
    public lazy var dictApplicasterSettings: NSDictionary = {
            if let filePath = Bundle.main.path(forResource: "ApplicasterSettings", ofType: "plist"),
                let dictionary = NSDictionary(contentsOfFile: filePath) {
                return dictionary
            }
            return NSDictionary()
    }()
    
    public lazy var dictGAUICustomization: NSDictionary = {
        if let filePath = Bundle.main.path(forResource: "GAUICustomization", ofType: "plist"),
            let dictionary = NSDictionary(contentsOfFile: filePath) {
            return dictionary
        }
        return NSDictionary()
    }()
    
    public lazy var appUrlScheme: String? = {
        if let arrUrlTypes = Bundle.main.object(forInfoDictionaryKey: "CFBundleURLTypes") as? [[String: AnyObject]],
            let arrUrlSchemes = arrUrlTypes.first?["CFBundleURLSchemes"] as? [AnyObject],
            let firstObject = arrUrlSchemes.first as? String {
            return firstObject
        }
        else {
            return nil
        }
    }()
    
    public var configurationJSON: NSDictionary?
    public var bundleName: String = ""
    public var bundleUrl: URL?
    public var moduleName: String = ""
    public var extraParams: [AnyHashable: Any]?
    
    // Array of objects implementing `RCTBridgeModule` interface
    public var extraReactBridgeModules: [Any]?

    public required init() {
        super.init(nibName: nil, bundle: nil)
    }

    public class func viewController(for plugin: ZPPluginModel, model: NSDictionary?, configurationJSON: NSDictionary?) -> UIViewController? {
        
        guard plugin.isReactNativePlugin else {
            return nil
        }
        
        let bundleParams = ZPReactNativeManager.sharedInstance.reactBundleParams(by: plugin.identifier)
        
        var extraParams = [AnyHashable: Any]()
        if let model = model {
            extraParams[ZPReactNativeManager.Constants.dataSourceModelParam] = model
        }
        let rnComponent = self.init(configurationJSON: configurationJSON,
                                    bundleUrl: bundleParams.bundleUrl,
                                    moduleName: bundleParams.moduleName,
                                    extraParams: extraParams)
        rnComponent.startLoadingReact(completion: nil)
        return rnComponent
    }
    
    public required init(configurationJSON: NSDictionary?) {
        super.init(nibName: nil, bundle: nil)
        self.configurationJSON = configurationJSON
    }
    
    public required init(configurationJSON: NSDictionary?, bundleUrl: URL?, moduleName: String, extraParams: [AnyHashable:Any]) {
        super.init(nibName: nil, bundle: nil)
        self.configurationJSON = configurationJSON
        self.bundleUrl = bundleUrl
        self.moduleName = moduleName
        self.extraParams = extraParams
    }
    
    open func startLoadingReact(completion: (() -> Void)?) {
        // Does nothing in this class, must be implemented in it's subclass.
        let failureMessage: String = self.className + " - This method must be overridden"
        preconditionFailure(failureMessage)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Retrieve extra props for plugin screen
    ///
    /// - Parameters:
    ///   - screenModel: screen model of existing screen
    ///   - dataSourceModel: model that will be used as screen data source
    /// - Returns: Dictionary of props for RN
    public class func extraScreenPropsWithData(screenModel:ZLScreenModel,
                                         dataSourceModel:NSObject?) -> [String: Any] {
        
        var retVal = [String:Any]()
        
        // Flat screen model keys for supporing backward compatibility
        // Will pass in example
        // [styles: [key1: value, key2:value]]
        // We will pass [key1: value, key2:value]
        screenModel.object.forEach {
            if let dict = $0.value as? [String:Any] {
                dict.forEach({ (innerDictTuple) in
                    retVal[innerDictTuple.key] = innerDictTuple.value
                })
            } else {
                retVal[$0.key] = $0.value
            }
        }
        
        // Pass in props dictionary of the ui builder screen mode
        retVal[PluggableScreen.screenModelInitPropsKey] = screenModel.object
        
        // Pass data source if availible to props
        if let modelDict = ZAAppConnector.sharedInstance().genericDelegate?.datasourceModelDictionary(withModel: dataSourceModel) {
            retVal[PluggableScreen.dataSourceInitPropsKey] = modelDict
        }
        
        return retVal
    }
    
    //MARK: ZPPlugableScreenProtocol
    public required convenience init?(pluginModel:ZPPluginModel,
                          screenModel:ZLScreenModel,
                          dataSourceModel:NSObject?) {
        
        let bundleParams = ZPReactNativeManager.sharedInstance.reactBundleParams(by: pluginModel.identifier)
        guard let bundleUrl = bundleParams.bundleUrl else {
            return nil
        }
        
        self.init(configurationJSON: pluginModel.configurationJSON,
                  bundleUrl: bundleUrl,
                  moduleName:  bundleParams.moduleName,
                  extraParams: ZPReactNativeBaseProvider.extraScreenPropsWithData(screenModel: screenModel,
                                                                                  dataSourceModel: dataSourceModel))
        self.screenModel = screenModel
    }
    
}

