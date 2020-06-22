//
//  ConnectorResolver.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 9/24/19.
//  Copyright © 2019 Applicaster LTD. All rights reserved.
//

import Foundation
import ZappCore

@objc public class ConnectorResolver:NSObject {
    
    public static var isFacadeConnector: Bool {
        return FacadeConnector.connector != nil
    }
    
    @objc public class func bundleIndentifier() -> String? {
        return isFacadeConnector ?
            FacadeConnector.connector?.applicationData?.bundleIdentifier() :
            ZAAppConnector.sharedInstance().genericDelegate?.getBundleIdentifier()
    }
    
    @objc public class func pluginsURL() -> URL? {
        return isFacadeConnector ?
            FacadeConnector.connector?.applicationData?.pluginsURLPath() :
            ZAAppConnector.sharedInstance().genericDelegate?.pluginsURLPath()
    }
}
