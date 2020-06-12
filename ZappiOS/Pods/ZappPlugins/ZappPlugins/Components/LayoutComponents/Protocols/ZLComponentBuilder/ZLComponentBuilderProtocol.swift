//
//  ZLComponentBuilderProtocol.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 15/11/2016.
//  Copyright © 2016 Anton Kononenko. All rights reserved.
//

import Foundation


/// This struct representation for request component to search styles in another components
public struct ZLZappLayoutDependantComponentStyles {
    public init(componentType:ZLComponentTypeProtocol, containerCell:Bool) {
        self.componentType = componentType
        self.containerCell = containerCell
    }
    
    /// Type of component that will be used as dependant
    public let componentType:ZLComponentTypeProtocol

    /// Explain to search if dependent component need to be searched in containerCell
    public let containerCell:Bool
}

public protocol ZLComponentBuilderProtocol {
    
    static func componentSkeletonForContainerCellLayout(_ zappParentLayoutName:String?,
                                                        baseModel:ZLComponentModel?,
                                                        zappParentComponentType:String?,
                                                        zappParentFamily:String?,
                                                        uniqueDataSourceIdentifier:String?,
                                                        actions: [String: Any]?,
                                                        uiTag:String?,
                                                        parentСomponentModel:CAComponentModelProtocol?) -> CAComponentModelProtocol?

    static func dictionaryForSkeletonComponent(_ zappLayoutName:String?,
                                               zappComponentType:String?,
                                               zappFamily: String?,
                                               uniqueDataSourceIdentifier:String?,
                                               actions: [String: Any]?,
                                               uiTag:String?,
                                               dependentStyles:[ZLZappLayoutDependantComponentStyles]?) -> [String: Any]?
    

    static func dictionaryForSkeletonContainerCellComponent(_ zappParentLayoutName:String?,
                                                            zappParentComponentType:String?,
                                                            zappParentFamily: String?,
                                                            uniqueDataSourceIdentifier:String?,
                                                            actions: [String: Any]?,
                                                            uiTag:String?) -> [String: Any]?

    static func componentFromDictionary(_ dictionary: [String: Any]?,
                                        baseModel:ZLComponentModel?,
                                        parentСomponentModel:CAComponentModelProtocol?) -> CAComponentModelProtocol?

    static func createHeaderComponent(_ model:ZLComponentModel,
                                      uniqueDataSourceIdentifier: String,
                                      parentСomponentModel:CAComponentModelProtocol?) -> CAComponentModelProtocol?

    static func addDataSourceToComponentModel(_ componentModel: CAComponentModelProtocol,
                                              dataSource:ZLDataSource)
}
