//
//  ZAAppDelegateConnectorLayoutComponentsProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 25/06/2018.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

public protocol ZAAppDelegateConnectorLayoutComponentsProtocol {

    func dataSourceHelperParseDataSourceEnum(with object: [String: Any]) -> ZLDataSource

    func dataSourceHelperGetScreenConnection(with object: [String: Any]) -> (connected: Bool, targetID:String?)

    func dataSourceHelperGetModel(from dataSource:ZLDataSource) -> Any?

    func createComponentAdvertisingModel(with object: [String: Any]) -> ZLBaseModel?

    func createComponentType(by key:String) -> ZLComponentTypeProtocol

    func componentsManagerGetScreenComponent(for screenID:String) -> ZLScreenModel?
    
    func componentsManagerGetScreenComponentforPluginID(pluginID: String) -> ZLScreenModel?
}
