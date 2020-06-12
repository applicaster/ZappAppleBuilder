//
//  ZPChromecastNotificationsProtocol.swift
//  ZappPlugins
//
//  Created by Simon Borkin on 8/21/18.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public protocol ZPChromecastNotificationsProtocol {
    func chromecastContainerView() -> UIView?
    func chromecastContainerViewHeightConstraint() -> NSLayoutConstraint?
    func chromecastContainerParentViewController() -> UIViewController?
}
