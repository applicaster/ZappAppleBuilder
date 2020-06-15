//
//  ZPHqmeButtonDelegate.swift
//  ZappGeneralPluginDownloads
//
//  Created by Alex Zchut on 17/03/2019.
//

import Foundation

@objc public protocol ZPHqmeButtonDelegate: class {
    @objc func hqmeButton(_ button: ZPHqmeButtonProtocol, stateChanged state: ZPHqmeButtonState)
    @objc func hqmeButton(_ button: ZPHqmeButtonProtocol, tappedWithState state: ZPHqmeButtonState)
    @objc func hqmeStateChangeNotificationName() -> String?
    @objc func hqmeInProgressChangeNotificationName() -> String?
    @objc func hqmeButtonCustomImagesSuffix() -> String?

}

@objc public enum ZPHqmeButtonState: NSInteger {
    case initial
    case pending
    case inProgress
    case completed
    case error
}
