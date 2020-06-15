//
//  ZPCustomUrlSchemeHandler.swift
//  ZappPlugins
//
//  Created by Simon Borkin on 23.04.20.
//  Copyright © 2020 Applicaster LTD. All rights reserved.
//

import Foundation

public protocol ZPCustomUrlSchemeHandler {
    static func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool
}
