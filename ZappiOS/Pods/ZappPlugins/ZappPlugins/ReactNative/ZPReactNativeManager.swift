//
//  ZPReactNativeManager.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 09/01/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//
import Foundation
import ZappCore

@objc public class ZPReactNativeManager: NSObject {
    @objc public static let sharedInstance = ZPReactNativeManager()
    
    public lazy var supportsSingleBundle:Bool = {
        return ZAAppConnector.sharedInstance().genericDelegate.reactNativeSingleBundleEnabled()
    }()
    
    public struct Constants {
        
        /**
         The default react module name that should be used if none is given.
         */
        public static let defaultReactModuleName = "RNRoot"
        
        /**
         The default react plugin name that should be used if none is given.
         */
        static let defaultProviderName = "ReactNativeDefault"

        /// The key used for the data source model in the `extraParams` to pass in the model's dictionary to the RN component
        public static let dataSourceModelParam = "reactProps[data_source_model]"
        
        /// The key used for the data source model in the `extraParams` to pass in the uibuilder screen model's dictionary to the RN component
        public static let uiBuilderScreenModelParam = "reactProps[uibuilder_screen_model]"
        
        /// The key used for the styles model in the `extraParams` to pass in the uibuilder model's dictionary to the RN component
        public static let stylesModelParam = "reactProps[styles]"

        /**
         The default react class name that should be used if none is given.
         */
        static let defaultReactClassName = "ZappReactNativeAdapter.ZPReactNativeDefaultProvider"
    }
    
        private override init() {
            //This prevents others from using the default '()' initializer for this class.
        }
    
    /// Create a RN plugin with plugin model and screen model. This method is used to create plugin from UIBulder screens
    ///
    /// - Parameters:
    ///   - pluginModel: Model of the plugin to create
    ///   - screenModel: ScreenModel for the defined plugin
    ///   - dataSourceModel: Optional Data source for RN
    ///   - Returns: Returns ZPReactNativeProviderProtocol instance in case plugin can be created
    public func create(pluginModel: ZPPluginModel,
                       screenModel: ZLScreenModel,
                       dataSourceModel: NSObject?) -> ZPReactNativeProviderProtocol? {
        var reactNativeProvider: ZPReactNativeProviderProtocol?

        if let pluginData = self.getPluginClassType(pluginName: pluginModel.pluginName) {
            let pluggableScreenClass = pluginData.classType as ZPPluggableScreenProtocol.Type

            if let provider = pluggableScreenClass.init(pluginModel: pluginModel,
                                                        screenModel: screenModel,
                                                        dataSourceModel: dataSourceModel) as? ZPReactNativeProviderProtocol {
                reactNativeProvider = provider
                reactNativeProvider?.startLoadingReact(completion: nil)
            }
        }
        return reactNativeProvider
    }
    
    /**
     private method - Get providers types from Zapp
     */
    public func create(pluginName: String, extraParams: [AnyHashable: Any]) -> ZPReactNativeProviderProtocol? {
        var provider: ZPReactNativeProviderProtocol? = nil
        
        if let pluginData = self.getPluginClassType(pluginName: pluginName) {
            let bundleParams = self.reactBundleParams(by: pluginData.model.identifier)
            provider = pluginData.classType.init(configurationJSON: pluginData.model.configurationJSON,
                                                 bundleUrl: bundleParams.bundleUrl,
                                                 moduleName: bundleParams.moduleName,
                                                 extraParams: extraParams)
        }
        return provider
    }
    
    func getPluginClassType(pluginName: String) -> (classType: ZPReactNativeBaseProvider.Type, model: ZPPluginModel)?  {
        var providerType: (ZPReactNativeBaseProvider.Type, ZPPluginModel)?

        var pluginNameUpdated: String = Constants.defaultProviderName
        if !pluginName.isEmpty  {
            pluginNameUpdated = pluginName
        }
        
        let pluginModel = ZPPluginManager.pluginModels()?.first(where: { $0.isReactNativePlugin && $0.pluginName == pluginNameUpdated })
        if let pluginModel = pluginModel {
            var classType = ZPPluginManager.adapterClass(pluginModel) as? ZPReactNativeBaseProvider.Type
            if classType == nil {
                classType = NSClassFromString(Constants.defaultReactClassName) as? ZPReactNativeBaseProvider.Type
            }
            if let classType = classType {
                providerType = (classType, pluginModel)
            }
        }
        return providerType
    }
    
    /**
     Returns the react bundle parameters by plugin identifier.
     */
    public func reactBundleParams(by pluginIdentifier: String) -> (bundleUrl:URL?, moduleName: String) {
        var retValue: (bundleUrl:URL?, moduleName: String) = (nil, ZPReactNativeManager.Constants.defaultReactModuleName)

        var filename = pluginIdentifier
        if supportsSingleBundle {
            //for single bundle, use plugin identifier as module name and find the bundle file by "index" hash
            filename = "index"
            retValue.moduleName = pluginIdentifier
        }

        retValue.bundleUrl = RNSettings.reactBundleSettingsUrl(prodUrl: self.reactBundleUrl(by: filename))
        
        return retValue
    }
    
    public func reactBundleUrl(by name: String) -> URL? {
        var retValue:URL?
        guard let reactBundlesUrl = Bundle.main.url(forResource: "ReactNativeBundles", withExtension: "bundle"),
            let bundle = Bundle(url: reactBundlesUrl),
            let pluginBundleUrl = bundle.url(forResource: "\(name.md5hash()).bundle", withExtension: "js") else {
                return retValue
        }
        retValue = pluginBundleUrl
        
        return retValue
    }
        
    /**
     Get providers types from Zapp
     */
    public func getProviders() -> [ZPReactNativeProviderProtocol]? {
        return ZPPluginManager.pluginModels()?.compactMap { pluginModel in
            guard pluginModel.isReactNativePlugin,
                let pluginData = self.getPluginClassType(pluginName:pluginModel.pluginName) else {
                    return nil
            }
            
            let bundleParams = self.reactBundleParams(by: pluginData.model.identifier)

            return pluginData.classType.init(configurationJSON: pluginData.model.configurationJSON,
                                             bundleUrl: bundleParams.bundleUrl,
                                             moduleName: bundleParams.moduleName,
                                             extraParams: [:])
        }
    }
}

//MARK - React Bundle URL Settings
extension UserDefaults {
    public enum Keys {
        static let ReactBundleServerType    = "reactbundle_server_type"
        static let ReactBundleCustomUrl     = "reactbundle_custom_url_textfield"
        static let ReactAllowCaching        = "reactbundle_allow_caching"
    }
}

public class RNSettings {
    enum SettingServerType: String {
        case production = "reactbundle_production_server"
        case staging = "reactbundle_staging_server"
        case local = "reactbundle_local_server"
        case custom = "reactbundle_custom_branch"
    }
    
    enum SettingsAPI {
        static let localAddress = "http://localhost:8081/index.ios.bundle?platform=ios"
        static let stagingAddress = "http://localhost:8081/index.ios.bundle?platform=ios"
    }
    //decide which bundle URL to retrieve based on settings page
    static func reactBundleSettingsUrl(prodUrl: URL?) -> URL? {
        let bundleURL: URL?
        switch currentSettingsServer() {
        case .production:
            bundleURL = prodUrl
        case .local:
            bundleURL = URL(string: SettingsAPI.localAddress)
        case .staging:
            //Todo - change staging address once it's operational
            bundleURL = URL(string: SettingsAPI.stagingAddress)
        case .custom:
            bundleURL = RNSettings.reactBundleCustomUrl()
        }
        return bundleURL
    }
    
    static func reactBundleCustomUrl() -> URL? {
        var customBundleURL: URL?
        if let customUrl = UserDefaults.standard.string(forKey: UserDefaults.Keys.ReactBundleCustomUrl) {
            customBundleURL = URL(string: customUrl)
        }
        return customBundleURL
    }
    
    public static func allowCaching() -> Bool {
        switch currentSettingsServer() {
        case .production:
            return UserDefaults.standard.object(forKey: UserDefaults.Keys.ReactAllowCaching) as? Bool ?? true
        case .local, .staging, .custom:
            return false
        }
    }
    
    fileprivate static func currentSettingsServer() -> SettingServerType {
        guard let settingsServerType = UserDefaults.standard.string(forKey: UserDefaults.Keys.ReactBundleServerType) else {
            return .production
        }
        return SettingServerType(rawValue: settingsServerType) ?? .production
    }
    
}
