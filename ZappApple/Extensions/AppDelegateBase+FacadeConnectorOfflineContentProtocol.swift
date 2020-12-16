//
//  AppDelegateBase+FacadeConnectorOfflineContentProtocol.swift
//  ZappiOS
//
//  Created by Alex Zchut on 16/12/2020.
//  Copyright © 2020 Applicaster Ltd. All rights reserved.
//

import Foundation
import OfflineContent
import ZappCore

extension AppDelegateBase: FacadeConnectorOfflineContentProtocol {
    public func localUrl(for identifier: String?) -> String? {
        guard let identifier = identifier,
              let avUrlAsset = OfflineContentManager.shared.localUrlAsset(for: identifier) else {
            return nil
        }

        return avUrlAsset.url.absoluteString
    }
}
