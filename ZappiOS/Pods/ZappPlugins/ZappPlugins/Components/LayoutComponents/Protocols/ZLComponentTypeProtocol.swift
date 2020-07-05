//
//  ZLComponentTypeProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 25/06/2018.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

public protocol ZLComponentTypeProtocol {
    func componentType() -> String
    func uiTagWithUniqueIdentifier(_ uniqueIdentifier: String) -> String
    func cellComponentTypeKey() -> String
    func builderClass() -> ZLComponentBuilderStructureProtocol.Type?
}
