//
//  NSObject+Additions.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 11/9/18.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

extension NSObject {
    public func swiftPointer() -> String {
        return NSString(format: "%p", unsafeBitCast(self, to: Int.self)) as String
    }
}
