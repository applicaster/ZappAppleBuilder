//
//  DateFormatter+APAdditions.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 31/07/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//

import Foundation

public extension DateFormatter {
    /// Create instance of predefined default date formatter
    ///
    /// - Returns: Prepared Instance of default time date formatter
    class func defaultDateFormatterTimeFormat(locale:Locale?) -> DateFormatter {
        let retVal = DateFormatter()
        retVal.defaultTimeFormat(locale: locale)
        return retVal
    }

    /// Create instance of predefined default date formatter
    ///
    /// - Returns: Prepared Instance of default full date formatter
    class func defaultFullDateFormatterFullFormat(locale:Locale?) -> DateFormatter {
        let retVal = DateFormatter()
        retVal.defaultFullDateFormat(locale: locale)
        return retVal
    }
    
    /// Setup Date formatter to use for work with short time format
    private func defaultTimeFormat(locale:Locale?) {
        formatterBehavior = .default
        timeStyle = .short
        dateStyle = .none
        updateLocale(locale: locale)
    }
    
    /// Setup Date formatter to use for work with short date and short time format
    private func defaultFullDateFormat(locale:Locale?) {
        defaultTimeFormat(locale: locale)
        dateStyle = .short
    }
    
    /// Set locale of the date formatter
    ///
    /// - Parameter locale: excpected locale format
    func updateLocale(locale: Locale?) {
        if let locale = locale {
            if self.locale.identifier != locale.identifier {
                if locale.identifier == "th" {
                    calendar = Calendar(identifier: .buddhist)
                }
                self.locale = locale
            }
        }
    }
}
