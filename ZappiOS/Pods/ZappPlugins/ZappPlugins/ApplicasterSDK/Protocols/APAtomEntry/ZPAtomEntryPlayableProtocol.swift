//
//  ZPAtomEntryPlayableProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 20/09/2018.
//

import Foundation

@objc public protocol ZPAtomEntryPlayableProtocol: ZPPurchasableItemProtocol {

    @objc func getMediaGroups() -> [APAtomMediaGroup]?
    @objc func assetForContentUrl() -> AVURLAsset
    @objc func contentType() -> String?
    @objc func getContentVideoURLPath() -> String?
}
