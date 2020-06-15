//
//  ZAAppDelegateConnectorRootProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 05/09/2018.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public protocol ZAAppDelegateConnectorRootProtocol {

    @objc func updateNavBarTitle()
    func getHomeScreenDatasourceModel() -> ZLScreenModel?
    
}
