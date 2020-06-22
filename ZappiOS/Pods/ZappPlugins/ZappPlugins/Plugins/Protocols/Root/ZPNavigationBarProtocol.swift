//
//  ZPNavigationBarProtocol.swift
//  Zapp-App
//
//  Created by Anton Kononenko on 17/07/16.
//  Copyright © 2016 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public protocol ZPNavigationBarProtocol: ZPNavigationBarUIBuilderProtocol {
    var specialButton: UIButton? {get}
    var backButton: UIButton? {get}
    var homeButton: UIButton? {get}
    
    var logoImageView: ZPImageView? {get}
    var backgroundImageView : ZPImageView? {get}
    
    var rightMenuButtons : [UIButton]? {get}
    var leftMenuButtons : [UIButton]? {get}

    @objc optional var leftMenuButtonsPaddingConstraint: NSLayoutConstraint? { get }
	@objc optional var leftMenuButtonsSpacingConstraints: [NSLayoutConstraint]? { get }
	@objc optional var rightMenuButtonsPaddingConstraint: NSLayoutConstraint? { get }
	@objc optional var rightMenuButtonsSpacingConstraints: [NSLayoutConstraint]? { get }
    
    func handleUserPushSpecialButton(_ sender: UIButton)
    func handleUserBackButton(_ sender: UIButton)
    func handleUserHomeButton(_ sender: UIButton)
    func handleUserPushGroupButtons(_ sender: UIButton)
}
