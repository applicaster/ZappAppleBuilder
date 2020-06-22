//
//  CGFloat+Extensions.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 30/10/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGFloat: LosslessStringConvertible {
    public init?(_ string: String) {
        guard let doubleValue = Double(string) else {
            return nil
        }
        self.init(doubleValue)
    }
}
