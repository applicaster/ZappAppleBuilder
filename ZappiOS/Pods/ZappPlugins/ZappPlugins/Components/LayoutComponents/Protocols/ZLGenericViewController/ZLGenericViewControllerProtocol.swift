//
//  ZLGenericViewControllerProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 25/06/2018.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public protocol ZLGenericViewControllerProtocol: CABasicGenericViewControllerProtocol {
    @objc var navBarLogoEnabled:Bool {get set}
}
