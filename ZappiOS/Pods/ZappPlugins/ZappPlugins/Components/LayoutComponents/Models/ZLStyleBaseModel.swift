//
//  ZLStyleBaseModel.swift
//  ComponentsSDK
//
//  Created by Anton Kononenko on 14/11/2016.
//  Copyright © 2016 Applicaster LTD. All rights reserved.
//

import Foundation

open class ZLStyleBaseModel:ZLBaseModel {
    // In future Family maybe should come per component, in this case. From init method should be removed family. And variable should be getter and return family from an object
    open var family: String?
    public init(object: [String: Any],
                family: String? = nil) {
        super.init(object: object)
        self.family = family
    }
    
    public var layouts: [String] {
        if let cellStylesArray = object[ZLStylesModelAPIKeys.cellStyles.rawValue] as? [String] {
            return cellStylesArray
        } else {
            return []
        }
    }
}
