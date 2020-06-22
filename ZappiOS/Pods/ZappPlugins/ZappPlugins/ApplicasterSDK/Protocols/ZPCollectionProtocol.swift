//
//  ZPCollectionProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 22/08/2018.
//

import Foundation

@objc public protocol ZPCollectionProtocol: ZPModelProtocol {

    @objc func getTitle() -> String?
    @objc func getUITag() -> String?

}
