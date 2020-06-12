//
//  ZLDataSource.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 25/06/2018.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

public enum ZLDataSource {
    case empty
    case category(category:NSObject)
    case collection(collection:NSObject)
    case atomFeed(atomFeed:NSObject)
    case favorites
    case hqme
    case webURL(linkEntry:NSObject)
    case banner(bannerModel:NSObject)
    case userAccountComponent
    
    /// Check if data source is empty
    ///
    /// - Returns: True in case data sorce has empty state
    public func isNoDataSource() -> Bool {
        switch self {
        case .empty:
            return true
        default:
            return false
        }
    }
}

