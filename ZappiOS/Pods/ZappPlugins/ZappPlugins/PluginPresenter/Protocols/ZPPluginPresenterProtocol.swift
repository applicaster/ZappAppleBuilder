//
//  ZPArticleScreenAdapterProtocol.swift
//  ZappPlugins
//
//  Created by Avi Levin on 05/02/2018.
//

import Foundation
import UIKit
import ZappCore

@objc public protocol ZPPluginPresenterProtocol: ZPAdapterProtocol {
    /**
     Create a view controller for presenting an article
     - parameter plugin: The plugin used for creating the view controller
     - parameter model: The datasource model to present
     - parameter configurationJSON: The configuration dictionary used when initialising the plugin component
     - returns: A view controller displaying the content from the plugin
     */
    @objc static func viewController(for plugin: ZPPluginModel,
                                     model: NSDictionary?,
                                     configurationJSON: NSDictionary?) -> UIViewController?
}
