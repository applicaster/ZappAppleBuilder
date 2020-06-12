//
//  Collection+Extension.swift
//  ZappLayoutsComponentsSDK
//
//  Created by Anton Kononenko on 22/11/2016.
//  Copyright © 2016 Anton Kononenko. All rights reserved.
//

import Foundation

public extension Collection {
    func nilIfEmpty() -> Self? {
         return self.isEmpty == false ? self : nil
    }
}
