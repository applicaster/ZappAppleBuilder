//
//  ZPNavigationControllerProtocol.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 12/12/2017.
//  Copyright © 2017 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public protocol ZPNavigationControllerProtocol {
    var adapterDataSource:ZPAdapterRootDataSource? { get set }
    
    
    /// Initialization for ZPNavigationControllerProtocol
    ///
    /// - Parameters:
    ///   - rootViewController: root view controller of the navigtion controller
    ///   - adapterDataSource: pointer to root adapter data source 
    init(rootViewController: UIViewController,
         adapterDataSource: ZPAdapterRootDataSource?)
}
