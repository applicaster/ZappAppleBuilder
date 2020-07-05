//
//  ZAAppDelegateConnectorHqmeProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 31/01/2019.
//

import UIKit

@objc public enum ZPHqmeState: Int {
    case initial = 0
    case online
    case offline
    case unavailable
    case detached

    func description() -> String {
        var retValue = ""
        switch (self) {
        case .initial:
            retValue = "HQME state: Initial"
        case .online:
            retValue = "HQME state: Online"
        case .unavailable:
            retValue = "HQME state: Unavailable"
        case .detached:
            retValue = "HQME state: Detached"
        default:
            break
        }
        return retValue
    }
}

@objc public enum ZPHqmeItemState: Int {
    case notExists
    case inProgress
    case completed
}

@objc public protocol ZAAppDelegateConnectorHqmeProtocol {

    /// getting the state of the item
    func getState(for item: ZPHqmeSupportingItemProtocol?) -> ZPHqmeItemState
    /// getting the state of the item by id
    func getState(forItemId itemId: String?) -> ZPHqmeItemState
    /// gets a list of items for the state
    func getItems(for state: ZPHqmeItemState) -> [ZPHqmeSupportingItemProtocol]
    /// get progress for item
    func getProgress(for item: ZPHqmeSupportingItemProtocol?) -> CGFloat
    /// download specific item
    func startProcess(for item: ZPHqmeSupportingItemProtocol?)
    /// cancel downloading specific item
    func cancelProcess(for item: ZPHqmeSupportingItemProtocol?)
    /// set the sound for the  item
    func setBackgroundCompletionSound(filename: String)
    /// get the avUrlAsset for item
    func getAvUrlAsset(forItem item: ZPHqmeSupportingItemProtocol?) -> AVURLAsset?
    /// get an indication if hqme is supported
    func isSupported() -> Bool
    /// Force offline
    func forceOfflineDueToBadConnectivity()
    /// get current hqme state
    var hqmeState: ZPHqmeState {get set}
    /// state changed handler
    var hqmeStateChanged:(() -> ())? {get set}

    /// get local item if available by item id
    func dataStoreGetLocalItemIfAvailable(withItemId itemId: String) -> ZPHqmeSupportingItemProtocol?
    /// delete locally stored item
    func dataStoreDeleteItem(_ item: ZPHqmeSupportingItemProtocol?)
    /// delete all local items
    func dataStoreDeleteAll()
    /// save a list of item ids to file
    func dataStoreSaveItemIdsToFile()
    /// load local model if available
    @discardableResult func dataStoreLoadLocalModelIfAvailable(_ model: ZPModelProtocol) -> Bool
    /// save model locally
    func dataStoreSaveModelLocally(_ model: ZPModelProtocol)
    /// checks if there is local data for model
    func dataStoreHasLocalData(for model: ZPModelProtocol) -> Bool
    /// gets image parh for image name in model
    func dataStoreImagePath(forImageName imageName:String, forModel model: ZPModelProtocol) -> String?

    /// checks if the item is legacy item
    func cacheIsLegacyItem(_ item: ZPHqmeSupportingItemProtocol?) -> Bool
    /// gets the path to item
    func cachePath(forItem item: ZPHqmeSupportingItemProtocol?) -> String

    /// gets the current local server port
    var localServerPort: UInt {get}
    /// starts local server on specified port
    func localServerStart(port: UInt)
    /// indication of hqme screen dismiss
    func hqmeScreenWillDissmised()
    /// start presenting offline mode screen
    func tryPresentOfflineMode()
    /// create download button
    func createHqmeButton(withDelegate delegate: ZPHqmeButtonDelegate, size: CGSize) -> ZPHqmeButtonProtocol?
    //Additional functions
    func getPlayerControllerParams(_ playerControllerObject: Any?, completion: ((_ isPlaying: Bool, _ isIdle: Bool, _ hqmeSupportingItem: ZPHqmeSupportingItemProtocol?) -> Void))
}

