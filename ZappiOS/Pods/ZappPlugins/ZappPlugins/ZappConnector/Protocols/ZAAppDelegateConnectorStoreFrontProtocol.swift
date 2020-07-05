//
//  ZAAppDelegateConnectorStoreFrontProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 09/08/2018.
//

import Foundation

@objc public protocol ZAAppDelegateConnectorStoreFrontProtocol {

    /**
     @return true if thie app contains at least one subscription voucher template. else otherwise.
     */
    @objc func hasSubscriptionsInTheApp() -> Bool

    /**
     @return true if the current user has a valid subscription - which means he has purchased one.
     */
    @objc func hasValidSubscriptionsVoucher() -> Bool

    /**
     @return true if can present storefront.
     */
    @objc func canPresentStoreFront() -> Bool

    /**
     @return new storefront handler.
     */
    @objc func createDefaultStoreFrontHandler(with delegate: ZPDefaultStoreFrontProtocol) -> ZPDefaultStoreFrontHandlerProtocol?

    /**
     @return new item.
     */
    @objc func createTempPurchasableItem(with dictionary:[String: Any]) -> ZPPurchasableItemProtocol?
}
