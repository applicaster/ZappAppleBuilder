//
//  ZPAutomationProtocol.swift
//  ZappGeneralPluginsSDK
//
//  Created by Boaz Warshawsky on 05/12/2018.
//

import Foundation

public struct GAAutomationPluginKeys {
    public static let pluginIdentifier = "automation_generic"
}


public protocol ZPAutomationProtocol {
    func setAccessibilityIdentifier(view:UIView?, identifier:String?)
}
