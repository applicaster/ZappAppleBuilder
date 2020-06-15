//
//  ZPHqmeButtonProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 19/03/2019.
//

import Foundation

@objc public protocol ZPHqmeButtonProtocol {
    var delegate: ZPHqmeButtonDelegate? { get set }
    var state: ZPHqmeButtonState { get set }
    
    func hqmeButtonTapped()
    func hqmeStateChange(to state: ZPHqmeButtonState)
    func hqmeStateDidChanged(from oldState: ZPHqmeButtonState, to newState: ZPHqmeButtonState)
    func hqmeProgressChanged(to progress: CGFloat)
    func defineButtonsForStates()
}
