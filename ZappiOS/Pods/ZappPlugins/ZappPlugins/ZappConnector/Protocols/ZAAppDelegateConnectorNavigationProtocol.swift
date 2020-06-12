//
//  ZAAppDelegateConnectorNavigationProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 21/11/2019.
//  Copyright © 2019 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public enum ZAAppDelegateConnectorNavigationType:NSInteger {
    case push
    case present
    case asChild
    case pushNoNavigation
}

@objc public protocol ZAAppDelegateConnectorNavigationProtocol {

    @objc func currentViewController() -> UIViewController?
    @objc func navigateToHomeScreen()
    @objc func navigateToHomeOfflineScreen()
    @objc func rootViewControllerPerformAction(forUrlSchemeParams params: NSDictionary?)

    @objc func customizeNavigation(model:AnyObject?, dataSource: AnyObject?, forViewController viewControllerToUpdate: UIViewController?)
    @objc func isNavigationBarRNScreenForcedHidden(model: AnyObject, dataSource: AnyObject) -> Bool
    @objc func setNavigationBarCloseButtonHidden(_ value: Bool)
    @objc func topmostModal() -> UIViewController?
    
    /**
    Retrieve navigationbar height with status bar
    @return Returns: height on the navigation bar container including status bar
    */
    @objc func navigationBarHeightPlusStatusBar() -> CGFloat
    @objc func rootViewController() -> UIViewController?
    
    /**
    Present a view controller on top of the current stack
    @param viewController - View controller to present
    @param presentationType - ZAAppDelegateConnectorNavigationType Presentation type enum
    @param animated - boolean stating if the presentation should be animated or not
    */
    @objc func present(_ viewController: UIViewController, presentationType: ZAAppDelegateConnectorNavigationType, animated: Bool)
    @objc func isPreload(_ viewController: UIViewController?) -> Bool
    @objc func dismissModalPresentedScreen()
    @objc func dismissPushPresentedScreen()
    @objc func reloadCurrentScreen(shouldReloadStack: Bool)
    @objc func reloadRootViewController()

    func createNavigationController(for rootViewController: UIViewController, adapterDataSource: ZPAdapterRootDataSource?) -> ZPNavigationControllerProtocol & UINavigationController
    func shouldSelectNavigationItem(url: URL) -> Bool
}
