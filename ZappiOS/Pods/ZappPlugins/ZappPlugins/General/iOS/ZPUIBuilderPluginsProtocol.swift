//
//  ZPUIBuilderPluginsProtocol.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 10/10/18.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation
import ZappCore

@objc public protocol ZPUIBuilderPluginsProtocol: class, NSObjectProtocol {
    
    /// Initialize plugin adapter for pluggable screen.
    /// Plugin should either be a view controller or implement the create screen function.
    ///
    /// - Parameters:
    ///   - pluginModel: Plugin model of the screen that will be created
    ///   - screenModel: UIbuilder screen model of the screen
    ///   - dataSourceModel: Data Source of the screen
    init?(pluginModel:ZPPluginModel,
          screenModel:ZLScreenModel,
          dataSourceModel:NSObject?)
}
