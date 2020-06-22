//
//  ZPScreenAutomationProtocol.swift
//  ZappPlugins
//
//  Created by Boaz Warshawsky on 11/12/2018.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public protocol ZPScreenAutomationProtocol: NSObjectProtocol {
    var screenAccessibilityIdentifier:String? { get }
}

