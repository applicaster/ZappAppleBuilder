//
//  ZLBaseModel.swift
//  ComponentsSDK
//
//  Created by Anton Kononenko on 14/11/2016.
//  Copyright © 2016 Applicaster LTD. All rights reserved.
//

import Foundation

open class ZLBaseModel:NSObject {
    open fileprivate(set) var object: [String: Any] = [:]
    public override init() {
        super.init()
    }

    public init(object: [String: Any]) {
        super.init()
        self.object = object
    }
}
