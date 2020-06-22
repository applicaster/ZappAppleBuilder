//
//  ZLComponentStyleSupplementaryModel.swift
//  ComponentsSDK
//
//  Created by Anton Kononenko on 14/11/2016.
//  Copyright © 2016 Applicaster LTD. All rights reserved.
//

import Foundation

open  class ZLComponentStyleSupplementaryModel:ZLStyleBaseModel {
    public var enabled:Bool {
        var retVal = false
        if let enabled = object[ZLSupplementaryModeAPIKeys.enabled.rawValue] as? Bool {
            retVal = enabled
        }
        return retVal
    }
    
    public override var layouts: [String] {
        var retVal:[String] = []
        if let parsedStyle = object[ZLSupplementaryModeAPIKeys.style.rawValue] as? String {
            retVal = [parsedStyle]
        }
        return retVal
    }
    
    public var supplementaryLayout:String? {
        return layouts.first
    }
    
    public var connection:(connected: Bool, targetID:String?) {
        var retVal:(connected: Bool, targetID:String?) = (false, nil)

        retVal = ZAAppConnector.sharedInstance().layoutComponentsDelegate.dataSourceHelperGetScreenConnection(with: object)
        
        if retVal.targetID != nil {
            retVal.connected = true
        }
        return retVal
    }
}
