//
//  ZPPurchasableItemProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 09/08/2018.
//

import Foundation
@objc public enum ZPPurchasableItemPurchaseResult: Int {
    case failure = 0
    case success
    case cancel
}

@objc public protocol ZPPurchasableItemProtocol: ZPPlayable {

    /**
     Get authorization providers ids
     */
    func authorizationProvidersIDs() -> [String]
    func associatedProductIdentifiers() -> [String]?
    func isEqualToItem(_ item: NSObject?) -> Bool
    func isOwned() -> Bool
    @discardableResult func attemptToPurchase() -> Error?
    @objc @discardableResult optional func attemptToPurchaseItem(with completion: ((ZPPurchasableItemPurchaseResult) -> ())?) -> NSError?

    func storeKitPurchaseParamsByVoucherTemplateIDs() -> [String: AnyObject]?
    func authorizationProvidersHeaders() -> [String: AnyObject]?
}
