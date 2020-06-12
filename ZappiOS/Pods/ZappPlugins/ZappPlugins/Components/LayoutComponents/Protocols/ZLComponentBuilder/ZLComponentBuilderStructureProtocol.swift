//
//  ZLComponentBuilderStructureProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 25/06/2018.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

public protocol ZLComponentBuilderStructureProtocol: ZLComponentBuilderProtocol {
    /// Create full structure of CAComponentModel from ZLModel.
    ///
    /// - Note: Full structure meaning as example Hero(Carousel)component should return CAComponentModel type carousel with children CAComponent model of type cell
    /// - Parameter model: Zapp Layout component model
    /// - Parameter zappFamily: Zapp Family name that will be used for component creation
    /// - Returns: Array of CAComponent Models that relevan for requested component
    static func componentStructureForModel(_ model:ZLComponentModel,
                                           parentСomponentModel:CAComponentModelProtocol?) -> [CAComponentModelProtocol]?

    static func componentStructureForModel(_ model:ZLComponentModel,
                                           parentСomponentModel:CAComponentModelProtocol?,
                                           screenModel:ZLScreenModel?) -> [CAComponentModelProtocol]?
}
