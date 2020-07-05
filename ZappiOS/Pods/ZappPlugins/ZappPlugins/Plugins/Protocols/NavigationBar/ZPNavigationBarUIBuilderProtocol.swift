//
//  ZPNavigationBarUIBuilderProtocol.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 15/12/2017.
//  Copyright © 2017 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public enum ZPNavBarButtonTypes: Int {
    case close
    case special
    case back
    case returnToHome
    case rightGroup
    case leftGroup
}

@objc public protocol ZPNavigationBarViewDelegate {
    
    /// Notifies delegate that navigation bar button was clicked
    ///
    /// - Parameters:
    ///   - navigationBar: Navigation bar view, where click was perfromed
    ///   - buttonWasClicked: Button type that was clicked
    ///   - senderButton: Instance of sender button
    func navigationBar(_ navigationBar: UIView,
                       buttonWasClicked: ZPNavBarButtonTypes,
                       senderButton: UIButton)
}

@objc public protocol ZPNavigationBarUIBuilderProtocol {
    var delegate:ZPNavigationBarViewDelegate? { get }
    @objc optional func updateSpecialButtonsContainer(backButtonHidden: Bool,
                                                      specialButtonHidden: Bool,
                                                      closeButtonHidden: Bool)
}
