//
//  DateFormatterManager.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 31/07/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//

import Foundation

@objc public class DateFormatterManager: NSObject {
    @objc static public let sharedInstance = DateFormatterManager()

    private var defaultTimeFormatter = DateFormatter.defaultDateFormatterTimeFormat(locale: nil)
    private var defaultFullDateFormatter = DateFormatter.defaultFullDateFormatterFullFormat(locale: nil)
    private var dateFormatterCustomFormat = DateFormatter()
    
    @objc public func stringFromDefaultTimeFormat(date:Date,
                                                  locale:Locale?) -> String {
        dateFormatterCustomFormat.updateLocale(locale: locale)
        return defaultTimeFormatter.string(from: date)
    }
    
    @objc public func stringFromDefaultFullDateFormat(date:Date,
                                                      locale:Locale?) -> String {
        dateFormatterCustomFormat.updateLocale(locale: locale)
        return defaultFullDateFormatter.string(from: date)
    }
    
    @objc public func stringFrom(date:Date,
                                 dateFormatString:String,
                                 locale:Locale?) -> String {
        dateFormatterCustomFormat.updateLocale(locale: locale)
        dateFormatterCustomFormat.dateFormat = dateFormatString
        return dateFormatterCustomFormat.string(from: date)
    }
}
