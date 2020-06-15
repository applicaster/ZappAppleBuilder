//
//  ZPCategoryProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 22/08/2018.
//

import Foundation

@objc public protocol ZPCategoryProtocol: ZPModelProtocol {

    @objc func getName() -> String?
    @objc func getShowName() -> String?
    @objc func getSeasonName() -> String?
    @objc func getLinkDictionary() -> [String: Any]?


}
