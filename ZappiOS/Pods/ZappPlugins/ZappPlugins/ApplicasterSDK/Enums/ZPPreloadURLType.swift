//
//  ZPPreloadURLType.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 03/02/2019.
//

import Foundation

@objc public enum ZPPreloadURLType: Int {
    case unknown = 0        /**< Unknown type - URL exists but not of specified type */
    case none               /**< No App Preload */
    case web                /**< Web page preload */
    case image              /**< Image preload */
    case video              /**< Video preload - should be either mp4 or m4v - preferably under 2 mb */
}
