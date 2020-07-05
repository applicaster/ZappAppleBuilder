//
//  ZPArticleManager.swift
//  ZappPlugins
//
//  Created by Avi Levin on 05/02/2018.
//

import Foundation
import UIKit
import ZappCore

@objc public class ZPPluginPresenterManager: NSObject {

    /**
     Checks for a plugin whose identifier matches the screen name and use it to load a new view controller.
     - parameter plugin: Contains the article plugin configurations.
     - parameter model: The datasource model data, used to populate the view controller.
     - returns: A view controller created by the plugin.
     */
    @objc public static func newPluginPresenter(plugin: ZPPluginModel, model: NSDictionary?) -> UIViewController? {
        var viewController: UIViewController?
        
        if let screenProvider = ZPPluginManager.adapterClass(plugin) as? ZPPluginPresenterProtocol.Type {
            viewController = screenProvider.viewController(for: plugin,
                                                           model: model,
                                                           configurationJSON: plugin.configurationJSON)
        }
        
        return viewController
    }

}
