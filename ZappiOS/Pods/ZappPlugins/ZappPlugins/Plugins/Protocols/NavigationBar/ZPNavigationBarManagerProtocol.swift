//
//  ZPNavigationBar.swift
//  Zapp-App
//
//  Created by Anton Kononenko on 12/07/16.
//  Copyright © 2016 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public protocol ZPNavigationBarManagerProtocol: NSObjectProtocol {
    
    /// Notify Navigation Naviation bar manager that current Navigation Controller transitionStartedWithViewController
    ///
    /// - Parameters:
    ///   - navigationController: current NavigationController instance
    ///   - viewController: current viewController instance
    ///   - animated: animated
    func navigationController(_ navigationController: UINavigationController,
                              transitionStartedWithViewController viewController: UIViewController,
                              animated: Bool)
    
    /// Notify Navigation Naviation bar manager that current Navigation Controller transitionEndedWithViewController
    ///
    /// - Parameters:
    ///   - navigationController: current NavigationController instance
    ///   - viewController: current viewController instance
    ///   - animated: animated
    func navigationController(_ navigationController: UINavigationController,
                              transitionEndedWithViewController viewController: UIViewController,
                              animated: Bool)
    
    /// Notify Navigation Naviation bar manager that current Navigation Controller displayingRootViewController
    ///
    /// - Parameters:
    ///   - navigationController: current NavigationController instance
    ///   - viewController: current viewController instance
    ///   - animated: animated
    func navigationController(_ navigationController: UINavigationController,
                              displayingRootViewController rootViewController: UIViewController)
    
    /// Notify Navigation Naviation bar manager that current Navigation Controller displayingCurrentViewController
    ///
    /// - Parameters:
    ///   - navigationController: current NavigationController instance
    ///   - viewController: current viewController instance
    ///   - animated: animated
    func navigationController(_ navigationController: UINavigationController,
                              displayingCurrentViewController currentViewController: UIViewController,
                              previousViewController: UIViewController?)
}



