//
//  ZAAppDelegateConnectorComponentsProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 24/06/2018.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public protocol ZAAppDelegateConnectorComponentsProtocol {

    @objc func customization(for element:NSObject,
                             attributeKey: String,
                             attributesDictionary: [String: String],
                             defaultAttributesDictionary: [String: String]?,
                             componentModel:CAComponentModelProtocol,
                             componentDataSourceModel: NSObject?,
                             componentState: CAComponentState)
    
    func getScreenPluginViewController(viewController: UIViewController) -> UIViewController?

    func getScreenPluginViewToTopConstraint(viewController: UIViewController) -> NSLayoutConstraint?

    @objc func playerLoadingScreen() -> String?
}
