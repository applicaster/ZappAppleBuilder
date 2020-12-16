//
//  AppDelegateBase+FacadeConnectorOfflineContentProtocol.swift
//  ZappiOS
//
//  Created by Alex Zchut on 16/12/2020.
//  Copyright © 2020 Applicaster Ltd. All rights reserved.
//

import Foundation

#if canImport(OfflineContent)
    import OfflineContent
#endif

import ZappCore

extension AppDelegateBase: FacadeConnectorOfflineContentProtocol {
    public func localUrl(for identifier: String?) -> String? {
        #if canImport(OfflineContent)
            guard let identifier = identifier,
                  let avUrlAsset = OfflineContentManager.shared.localUrlAsset(for: identifier) else {
                return nil
            }

            return avUrlAsset.url.absoluteString
        #else
            return nil
        #endif
    }
}
