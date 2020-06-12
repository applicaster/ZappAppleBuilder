//
//  ZPPlayerNotificationsProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 15/05/2016.
//  Copyright © 2016 Applicaster Ltd. All rights reserved.
//

public protocol ZPPlayerNotificationsProtocol {
    func addObservers()
    func removeObservers()
    func removeObserver(_ name: String)
}
