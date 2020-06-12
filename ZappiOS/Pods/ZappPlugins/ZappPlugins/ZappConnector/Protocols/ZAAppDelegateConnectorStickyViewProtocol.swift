//
//  ZAAppDelegateConnectorStickyViewProtocol.swift
//  ZappPlugins
//
//  Created by Miri on 23/12/2018.
//

import Foundation

//Allows display and remove sticky view sent
//For example: to display mini player at the bottom of the rootViewController. you can send the mini player view from the player plugin and implement this protocol at the root plugin.
@objc public protocol ZAAppDelegateConnectorStickyViewProtocol {

    @objc func stickyViewDisplay(view: UIView?)
    @objc func stickyViewRemove()

}
