//
//  CABasicGenericViewControllerProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 25/06/2018.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public protocol CABasicGenericViewControllerProtocol: CAComponentDelegate, CAComponentProtocol, CABasicGenericViewControllerDataSource, CAGenericViewControllerProtocol {

    @objc func removeMainComponent()
    @objc var hasMainComponent:Bool {get}
    @objc var shouldRefreshScreen:Bool {get set}
}
