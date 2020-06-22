//
//  ZPHqmeSupportingItemProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 27/01/2019.
//

import Foundation

@objc public protocol ZPHqmeSupportingItemProtocol: ZPJsonSerializableProtocol {
    ///get download url of the item
    func hqmeContentUrl() -> URL?

    ///get array of additional content to be saved with the model
    func relatedAssets() -> [String]?

    ///get item title
    func title() -> String?

    ///get identifier
    @objc optional func objectIdentifier() -> String?

    ///is valid
    @objc optional func isValidForHqme() -> Bool

    ///is free or purchased
    @objc optional func isFreeOrPurchased() -> Bool

    ///has valid expiration date
    @objc optional func hasValidHqmeExpirationDate() -> Bool
}
