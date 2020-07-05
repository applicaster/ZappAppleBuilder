//
//  SwiftSwizzler.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 1/29/19.
//  Copyright © 2019 Applicaster LTD. All rights reserved.
//

import Foundation

import ObjectiveC

// Good article about implamentation and problems of swizzeling https://medium.com/@abhimuralidharan/method-swizzling-in-ios-swift-1f38edaf984f

/// Swizzle class method, Allow to call new class metthod instead original one
///
/// - Parameters:
///   - originalClass: Class that need to be overrided
///   - swizzledClass: Class to swizzle
///   - originalSelector: Selector that needed to be overrided
///   - swizzledSelector: New Selector to swizzle (part of swizzeled class)
///   - revert: if should revert swizzle, need to prevent edge cases like in test, not to call swizzle on swizzle
public func swizzleClassMethod(originalClass: AnyClass,
                          swizzledClass: AnyClass,
                          originalSelector: Selector,
                          swizzledSelector: Selector,
                          revert:Bool = false) {
    guard let _OriginalClass = object_getClass(originalClass),
        let _SwizzledClass = object_getClass(swizzledClass) else {
            return
    }
    
    guard let method1: Method = class_getClassMethod(_OriginalClass,
                                                        originalSelector),
        let method2: Method = class_getClassMethod(_SwizzledClass,
                                                      swizzledSelector) else {
        return
    }
    
    if revert == false {
        method_exchangeImplementations(method1, method2)
    } else {
        method_exchangeImplementations(method2, method1)
    }
}

/// Swizzle instance method, Allow to call new instance metthod instead original one
///
/// - Parameters:
///   - originalClass: Class that need to be overrided
///   - swizzledClass: Class to swizzle
///   - originalSelector: Selector that needed to be overrided
///   - swizzledSelector: New Selector to swizzle (part of swizzeled class)
///   - revert: if should revert swizzle, need to prevent edge cases like in test, not to call swizzle on swizzle
public func swizzleInstanceMethod(originalClass: AnyClass,
                                  swizzledClass: AnyClass,
                                  originalSelector: Selector,
                                  swizzledSelector: Selector,
                                  revert:Bool = false) {
    guard let method1: Method = class_getInstanceMethod(originalClass,
                                                        originalSelector),
        let method2: Method = class_getInstanceMethod(swizzledClass,
                                                      swizzledSelector) else {
                                                        return
    }
    
    if revert == false {
        method_exchangeImplementations(method1, method2)
    } else {
        method_exchangeImplementations(method2, method1)
    }
}
