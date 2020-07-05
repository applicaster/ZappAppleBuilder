//
//  ZPDefaultStoreFrontProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 09/08/2018.
//

import Foundation

@objc public protocol ZPDefaultStoreFrontProtocol {

    /**
     This delegate method is being called when the purchase is completed successfully.
     */
    func itemPurchaseCompleted(_ purchasableItem : ZPPurchasableItemProtocol?)

    /**
     This delegate method is being called when the purchase is failed.
     */
    func itemPurchaseFailed(_ purchasableItem : ZPPurchasableItemProtocol?)

    /**
     This delegate method is being called when the purchase is being canceled by the user.
     */
    func itemPurchaseCancelled(_ purchasableItem : ZPPurchasableItemProtocol?)
}
