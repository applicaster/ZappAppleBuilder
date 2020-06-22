//
//  Ditctionary+Extension.swift
//  ZappLayoutsComponentsSDK
//
//  Created by Anton Kononenko on 20/11/2016.
//  Copyright © 2016 Anton Kononenko. All rights reserved.
//

import Foundation
import CoreGraphics

public func ==(lhs: [String: AnyObject],
               rhs: [String: AnyObject]) -> Bool {
    return NSDictionary(dictionary: lhs).isEqual(to: rhs)
}

public extension Dictionary {
    
    /// Parsing generic value with String check
    ///
    /// - Parameter key: Key for expected value
    /// - Returns: LosslessStringConvertible protocol conformed instance
    func value<T>(key: Key) -> T? where T: LosslessStringConvertible {
        if let retVal = self[key] as? T {
            return retVal
        } else if let retValString = self[key] as? String,
            let retVal = T(retValString) {
            return retVal
        }
        return nil
    }
    
    /// Parsing Double value with String check
    ///
    /// - Parameter key: Key for expected value
    /// - Returns: Double value if value exists and conforms LosslessStringConvertible otherwise Nil
    func doubleNumber(key:Key) -> Double? {
        return value(key:key)
    }
    
    /// Parsing Float value with String check
    ///
    /// - Parameter key: Key for expected value
    /// - Returns: Float value if value exists and conforms LosslessStringConvertible otherwise Nil
    func floatNumber(key:Key) -> Float? {
        return value(key:key)
    }
    
    /// Parsing CGFloat value with String check
    ///
    /// - Parameter key: Key for expected value
    /// - Returns: CGFloat value if value exists and conforms LosslessStringConvertible otherwise Nil
    func cgFloatNumber(key:Key) -> CGFloat? {
        return value(key: key)
    }
    
    /// Parsing Int value with String check
    ///
    /// - Parameter key: Key for expected value
    /// - Returns: Int value if value exists and conforms LosslessStringConvertible otherwise Nil
    func intNumber(key:Key) -> Int? {
        return value(key: key)
    }

    func merge(_ dict: Dictionary<Key,Value>) -> Dictionary<Key,Value> {
        var mutableCopy = self
        for (key, value) in dict {
            // If both dictionaries have a value for same key, the value of the other dictionary is used.
            mutableCopy[key] = value
        }
        return mutableCopy
    }
    
    /// Retrieve JSON string from Dictionary
    ///
    /// - Parameter dictionary: item to convert to JSON string
    /// - Returns: JSON String if can be created, otherwise nil
    func getJsonString() -> String? {
        let jsonData = try? JSONSerialization.data(withJSONObject: self, options: [])
        guard let jsonString = String(data: jsonData!, encoding: .utf8) else {
            return nil
        }
        return jsonString
    }
}
