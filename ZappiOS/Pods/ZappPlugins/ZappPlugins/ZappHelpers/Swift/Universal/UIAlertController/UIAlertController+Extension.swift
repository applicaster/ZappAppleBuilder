//
//  UIAlertController+Extension.swift
//  ZappPlugins
//
//  Created by Pablo Rueda on 22/01/2018.
//  Copyright © 2018 Applicaster Ltd. All rights reserved.
//

import UIKit

@objc public extension UIAlertController {
    
    /// Presents the alert controller over all the elements in the screen
    func show() {
        let win = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        win.rootViewController = vc
        win.windowLevel = UIWindow.Level.alert + 1
        win.makeKeyAndVisible()
        vc.present(self, animated: true, completion: nil)
    }
}
