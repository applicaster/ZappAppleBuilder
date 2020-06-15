//
//  ZAAppDelegateConnectorGenericProtocol.swift
//  ZappAppConnector
//
//  Created by Alex Zchut on 06/03/2018.
//  Copyright © 2018 Applicaster Ltd. All rights reserved.
//

import Foundation

@objc public protocol ZAAppDelegateConnectorGenericProtocol {
    #if os(iOS)

    // Retrieve current selected broadcaster extensions dictionary
    @objc func currentBroadcasterExtensions() -> Dictionary<String, AnyObject>

    // Retrieve account extensions dictionary
    @objc func accountExtensionsDictionary() -> Dictionary<String, AnyObject>

    /// Retreive view controller from navigation item
    ///
    /// - Parameter navigationItem: ZLNavigationItemInstance
    /// - Returns: UIViewController instance nil if can not be created
    @objc func viewController(fromNavigationItem navigationItem:Any) -> UIViewController?

    /**
     @return Indicate Nav Bar UI Builder API Enable or Disable.
     */
    @objc func navBarUIBuilderApiEnabled() -> Bool

    /**
     @return Indicate ReactNativeSingleBundle Enable or Disable.
     */
    @objc func reactNativeSingleBundleEnabled() -> Bool
    
    /**
     @return Indicate Root UI Builder API Enable or Disable.
     */
    @objc func rootUIBuilderApiEnabled()-> Bool

    /// ApplicasterSDK accountID
    ///
    /// - Returns: String Instance
    @objc func accountID() -> String?
    /**
     @return Is this app running on debug configuration, this method useful for static frameworks instead of the DEBUG precompiler flag
     */
    @objc func isDebug()-> Bool

    /**
     Returns RTL status
    */
    @objc func isRTL() -> Bool

    /**
     Splash Helper
     @return Local background video name for screen size
     */
    @objc func splashHelperGetLocalBackgroundVideoNameForScreenSize(baseFileName: String) -> String


    /**
     Create new video background view
     @return new instance conforming protocol ZPVideoBackgroundViewProtocol
     */
    @objc func createVideoBackgroundViewInstance() -> ZPVideoBackgroundViewProtocol

    /// Retrieve collection by ui tag
    ///
    /// - Parameter uiTag: collection ui tag
    /// - Returns: collection in completion
    @objc func loadCollection(forUiTag uiTag:String, completion: @escaping ([NSObject]) -> Void)
    @objc func loadCollectionItems(forUiTag uiTag: String, completion: @escaping (ZPCollectionProtocol?) -> Void)

    /// Retrieve dictionary from model
    ///
    /// - Parameter model: model to retrieve dictionary
    /// - Returns: dictionary from model or nil
    @objc func datasourceModelDictionary(withModel model: NSObject?) -> NSDictionary?


    /// Try to close view controller created from navigation bar
    ///
    /// - Parameter viewController: UIViewController must be GARootViewControllerController
    /// - Returns: True if succeded otherwise false
    @objc func closeViewControllerCreatedFromNavigationBar(viewController:UIViewController?) -> Bool

    /// Get broadcaster functions
    @objc func getBroadcaster(byID: String) -> ZPBroadcasterProtocol?
    @objc func getBroadcasters() -> [ZPBroadcasterProtocol]?
    @objc func getCurrentBroadcaster() -> ZPBroadcasterProtocol?

    //Logger
    @objc func sendLoggerError(message:String)
    @objc func sendLoggerDebug(message:String)
    @objc func sendLoggerInfo(message:String)


    @objc func hookManager() -> ZPScreenHookManagerProtocol

    @objc func screenModel(for screenID:String?) -> ZLScreenModel?
    @objc func screenModelForPluginID(pluginID:String?,
                                      dataSource:NSObject?) -> ZLScreenModel?
    @objc func screenModelForLegacyScreenID(_ screenID:String?) -> ZLScreenModel?

    @objc func extensionDictForModel(withModel model: NSObject?) -> NSDictionary?
    @objc func valueFromExtensionDictForModel(withModel model: NSObject?, for key:String) -> Any?

    /// Checks if there is home offline screen
    @objc func hasScreenModelForOfflineHome() -> Bool

    /// Set automation identifier
    @objc func setAutomationAccessibilityIdentifier(forView view:UIView?, identifier:String?)
    
    /// Populate generic view and return view Controller
    @objc func viewControllerByScreenName(screenName: String, title: String?, dataSourceModel: NSObject?) -> UIViewController?
    
    /// Updates view controller content by given feeds url
    @objc func updateViewControllerFeedUrl(vc: UIViewController, feedUrl: String) -> APContainerProtocol?
    
    #endif

    //App Bundle Identifier
    @objc func getBundleIdentifier() -> String

    /// Retreive path for plugins for plugin_configurations
    ///
    /// - Returns: URL instance
    @objc func pluginsURLPath() -> URL?
    
    /// Replace s3 host url with custom host
    //
    /// - Returns: URL instance
    @objc func replaceS3hostname(in urlString: String) -> String
}
