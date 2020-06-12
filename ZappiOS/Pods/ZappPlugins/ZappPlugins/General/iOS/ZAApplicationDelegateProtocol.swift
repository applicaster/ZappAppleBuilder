//
//  ZAApplicationDelegateProtocol.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 9/19/19.
//  Copyright © 2019 Applicaster LTD. All rights reserved.
//

import Foundation

public protocol ZAApplicationDelegateProtocol {
    func setApplicasterParams(_ appParams:[String: String])
    func setRemoteConfigurationDelegate(_ delegate: GAFirebaseRemoteConfigurationProtocol?)
    func setIsDebug(_ value: Bool)
}
