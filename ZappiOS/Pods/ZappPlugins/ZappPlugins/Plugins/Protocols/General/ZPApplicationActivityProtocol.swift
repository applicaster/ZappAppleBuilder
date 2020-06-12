//
//  ZPApplicationActivityProtocol.swift
//  ZappGeneralPluginsSDK
//
//  Created by Alex Zchut on 21/02/2019.
//

import UIKit

@objc public protocol ZPApplicationActivityProtocol: NSObjectProtocol {
    @objc static var activities: [UIActivity] { get }
}
