//
//  ZPUIBuilderScreenProtocol.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 11/2/18.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public protocol ZPUIBuilderScreenProtocol: NSObjectProtocol {
    
    /// Screen Model of the UIBuilder screen, retrieved from the river.json
    var screenModel:ZLScreenModel? { get set }
    var dataSourceModel:NSObject? { get set }
    var screenName:String? { get set }

    func reloadScreen()
}



