//
//  ZPPluginManager+iOS.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 11/13/18.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

extension ZPPluginManager {
    /**
     Look for a plugin defined to present a screen.
     This method will check first if there is a plugin whose identifier is defined in the 'open_with_plugin_id' key inside the 'extensions' values of the model. If it is not defined it will check among the plugins types to match the screenName provided.
     - parameter screenName: The screen name provided by the model. This is used to check for the plugin's `pluginType`.
     - parameter model: The datasource model that will be used to populate the view controller. If it is defined the key 'open_with_plugin_id' inside the 'extensions' values, it will try to load that plugin.
     - returns: A view controller created by a plugin.
     */
    public class func viewController(screenName: String, model: NSDictionary?) -> UIViewController? {
        var viewController: UIViewController?
        
        if let plugin = self.plugin(withScreenName:screenName, model:model) {
            viewController = ZPPluginPresenterManager.newPluginPresenter(plugin: plugin, model: model)
        }
        
        return viewController
    }

}
