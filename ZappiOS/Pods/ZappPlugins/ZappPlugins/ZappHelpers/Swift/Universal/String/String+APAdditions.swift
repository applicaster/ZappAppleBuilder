//
//  String+APAdditions.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 03/07/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//

import Foundation
import UIKit
public extension String {
	static func isNotEmptyOrWhitespace(_ obj: String?) -> Bool {
		return obj?.isEmptyOrWhitespace() == false
	}

    func isEmptyOrWhitespace() -> Bool {
        return self.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty
    }
    
    //can not use this function because self can be nil and the result will be nil and not bool
    @available(*, deprecated, message: "Use String.isNotEmptyOrWhitespace class function instead")
    func isNotEmptyOrWhitespace() -> Bool {
        return !self.isEmptyOrWhitespace()
    }
    
	func boolValue() -> Bool {
		let trueValues = ["true", "yes", "1"]
		return trueValues.contains(self.lowercased())
	}

	//https://gist.github.com/albertbori/0faf7de867d96eb83591
	func replace(_ target: String, withString: String) -> String {
		return self.replacingOccurrences(of: target,
		                                 with: withString,
		                                 options: NSString.CompareOptions.literal,
		                                 range: nil)
	}

	var isDigits: Bool {
		// The inverted set of .decimalDigits is every character minus digits
		let nonDigits = CharacterSet.decimalDigits.inverted
		return self.rangeOfCharacter(from: nonDigits) == nil
	}
    
    static func tryAddHost(to urlString:String) -> String? {
        let urlWithHost = "https://" + urlString
        if let url = URL(string: urlString),
            UIApplication.shared.canOpenURL(url) == true {
            return urlString
        } else if let url = URL(string: urlWithHost),
            UIApplication.shared.canOpenURL(url) == true {
            return urlWithHost
        }
        
        return nil
    }
    
	var isURLScheme: Bool {
		let url = URL(string: self)
        return url?.scheme != nil && url?.host != nil
	}
    
    // Modify zapp style color string #aarrggbb -> rrggbbaa
    func normalizedZappColorString() -> String {
        // Make sure color string is of the expected length and NOT empty string from Zapp
        if self.count == 9 {
            let modifiedColor = self.dropFirst().uppercased()
            let colorIndex = String.Index(utf16Offset: 2, in: modifiedColor)
            let correctedColorValue = String(modifiedColor.suffix(from: colorIndex) + modifiedColor.prefix(upTo: colorIndex))
            return correctedColorValue
        } else {
            return self
        }
    }

    func md5hash() -> String {
         return (self as NSString).md5Hash()
    }
    
    func getDictFromJsonString() -> [String: Any]? {
        guard let jsonData = self.data(using: .utf8) else { return nil }
        let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
        guard let retVal = dictionary as? [String: Any] else { return  nil }
        return retVal
    }
    
    static func pointer(_ object: AnyObject?) -> String {
        guard let object = object else { return "nil" }
        let opaque: UnsafeMutableRawPointer = Unmanaged.passUnretained(object).toOpaque()
        return String(describing: opaque)
    }
}

