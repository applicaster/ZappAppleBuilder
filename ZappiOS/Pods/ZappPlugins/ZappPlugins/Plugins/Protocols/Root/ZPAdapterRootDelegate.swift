//
//  ZPAdapterRootDelegate.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 11/5/18.
//  Copyright © 2018 Applicaster. All rights reserved.
//

import Foundation

@objc public protocol ZPAdapterRootDelegate {
    func adapterWillAppearViewController(viewController:UIViewController, inNavigationViewController navigationViewController:UINavigationController)
}
