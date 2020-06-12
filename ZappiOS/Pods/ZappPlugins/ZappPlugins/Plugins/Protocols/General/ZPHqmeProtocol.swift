//
//  ZPHqmeProtocol.swift
//  ZappGeneralPluginsSDK
//
//  Created by Alex Zchut on 31/01/2019.
//

import UIKit

@objc public protocol ZPHqmeProtocol: ZPGeneralPluginProtocol {
    static var sharedInstance: ZPHqmeProtocol? { get }
    ///set plugin configuration json
    func setConfigurationJson(_ configurationJson: NSDictionary?)
    ///block indicating state change
    var stateChanged:(() -> ())  {get set}
    ///forcing offline
    func forceOfflineDueToBadConnectivity()
    ///getting/setting surrent state
    var state:ZPHqmeState {get set}
    ///instance of the hqme process protocol
    var processHandler: ZPHqmeProcessProtocol {get}
    ///===========
    ///optional functions for legacy provider
    ///===========

    ///getting the indication if it is supported
    @objc optional var isSupported: Bool {get}
    ///getting the indication if it is ready
    @objc optional var isReady: Bool {get}
    ///instance of the datastore protocol
    @objc optional var dataStoreHandler: ZPHqmeDataStoreProtocol {get}
    ///instance of the local server protocol
    @objc optional var serverHandler: ZPHqmeLocalServerProtocol {get}
}

@objc public protocol ZPHqmeProcessProtocol {
    func avUrlAsset(for item: ZPHqmeSupportingItemProtocol?) -> AVURLAsset?
    ///get the current offline state of the item
    func getState(for item: ZPHqmeSupportingItemProtocol?) -> ZPHqmeItemState
    ///download item
    func startProcess(for item: ZPHqmeSupportingItemProtocol?)
    ///cancel downloading item
    func cancel(for item: ZPHqmeSupportingItemProtocol?)
    ///get all items for specific state
    func items(for state: ZPHqmeItemState) -> [ZPHqmeSupportingItemProtocol]
    ///pause all downloadings
    func pauseAll()
    ///resume all downloadings
    func resumeAll()
    //set download-end sound filename
    func setBackgroundCompletionSound(filename: String)
    //create download button
    @objc optional func createHqmeButton(withDelegate delegate: ZPHqmeButtonDelegate, size: CGSize) -> ZPHqmeButtonProtocol?

    //===========
    //optional functions for legacy provider
    //===========

    //get offline state for item by item id
    @objc optional func getState(forItemId itemId: String?) -> ZPHqmeItemState
    //get downloading progress for item
    @objc optional func getProgress(for item: ZPHqmeSupportingItemProtocol?) -> CGFloat
}

@objc public protocol ZPHqmeDataStoreProtocol {

    ///delete downloaded item
    func deleteItem(_ item: ZPHqmeSupportingItemProtocol)
    ///delete all downloaded items
    func deleteAll()

    //===========
    //optional functions for legacy provider
    //===========

    ///load local model if available
    @objc optional func loadLocalModelIfAvailable(_ model: ZPModelProtocol) -> Bool
    ///get local item
    @objc optional func getLocalItemIfAvailable(itemId: String) -> ZPHqmeSupportingItemProtocol
    ///save ids to file
    @objc optional func saveItemIdsToFile()
    ///get item legacy indication
    @objc optional func isLegacyItem(_ item: ZPHqmeSupportingItemProtocol) -> Bool
    ///get cached path of the item
    @objc optional func path(forItem item: ZPHqmeSupportingItemProtocol?) -> String
    ///save model locally
    @objc optional func saveModel(_ model: ZPModelProtocol)
    ///check if has local model
    @objc optional func hasLocalData(forModel model: ZPModelProtocol) -> Bool
    ///get image path for image name
    @objc optional func imagePath(forImageName imageName:String, forModel model: ZPModelProtocol) -> String?
}

@objc public protocol ZPHqmeLocalServerProtocol {

    //===========
    //optional functions for legacy provider
    //===========

    @objc optional var port:UInt {get}
    ///start local server
    @objc optional func start(port: UInt)
}
