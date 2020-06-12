//
//  ZLComponentStyleModel.swift
//  ComponentsSDK
//
//  Created by Anton Kononenko on 14/11/2016.
//  Copyright © 2016 Applicaster LTD. All rights reserved.
//

import Foundation

open class ZLComponentStyleModel:ZLStyleBaseModel {
    public fileprivate(set) var header:ZLComponentStyleSupplementaryModel?
    public fileprivate(set) var footer:ZLComponentStyleSupplementaryModel?
    
    public override init(object: [String: Any],
                         family:String? = nil) {
        super.init(object: object,
                   family: family)
        parse()
    }
}

extension ZLComponentStyleModel {
    func parse() {
        header = parseSupplementaryModelWithDict(object, type: .header)
        footer = parseSupplementaryModelWithDict(object, type: .footer)
    }
    
    func parseSupplementaryModelWithDict(_ dictionary: [String: Any],
                                         type:ZLSupplementaryModelType) -> ZLComponentStyleSupplementaryModel? {
        var retVal:ZLComponentStyleSupplementaryModel?
        
        let supplementaryModelKey = type == .header ? ZLStylesModelAPIKeys.header.rawValue : ZLStylesModelAPIKeys.footer.rawValue
        
        if let supplementaryModelDict = dictionary[supplementaryModelKey] as? [String: Any] {
            let supplementaryModel = ZLComponentStyleSupplementaryModel(object: supplementaryModelDict)
            retVal = supplementaryModel
        }
        
        return retVal
    }
}
