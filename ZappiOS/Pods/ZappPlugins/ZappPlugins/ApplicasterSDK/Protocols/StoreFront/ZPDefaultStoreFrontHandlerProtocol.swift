//
//  ZPDefaultStoreFrontHandlerProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 09/08/2018.
//

import Foundation

@objc public protocol ZPDefaultStoreFrontHandlerProtocol: NSObjectProtocol {

    /**
     Attempting to purchase purchasableItem.
     */
    func attemptToPurchasePurchasableItem(_ purchasableItem : ZPPurchasableItemProtocol?)
}
