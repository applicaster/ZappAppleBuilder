//
//  ZPPlayableModel.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 12/1/18.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

class ZPPlayableModel: NSObject, ZPPlayable {
    struct ZPPlayableModelKeys {
        static let contentURL = "content_url"
        static let extensionsDictionary = "extensions"
        static let identifier = "id"
        static let title = "title"

    }
    var object:[String:Any]?
    var identifier: NSString?
    var extensionsDictionary: NSDictionary?
    var contentURLString:String?
    var title:String?
    
    init(urlString:String) {
        super.init()
        contentURLString = urlString
    }
    
    init?(dict:[String:Any]) {
        super.init()
        object = dict
        identifier = dict[ZPPlayableModelKeys.identifier] as? NSString
        extensionsDictionary = dict[ZPPlayableModelKeys.extensionsDictionary] as? NSDictionary
        title = dict[ZPPlayableModelKeys.title] as? String
        contentURLString = dict[ZPPlayableModelKeys.contentURL] as? String
        if contentURLString == nil {
            return nil
        }
    }
    
    func playableName() -> String? {
        return title
    }
    
    func playableDescription() -> String? {
        return nil
    }
    
    func contentVideoURLPath() -> String? {
        return contentURLString
    }

    func assetUrl() -> AVURLAsset? {
        guard let urlString = self.contentVideoURLPath(),
            let url = URL(string: urlString) else {
            return nil
        }
        return AVURLAsset(url: url, options: nil)
    }
    
    func overlayURLPath() -> String? {
        return nil
    }
    
    func isLive() -> Bool {
        return false
    }
    
    func isFree() -> Bool {
        return true
    }
    
    func publicPageURLPath() -> String? {
        return nil
    }
    
    func analyticsParams() -> [AnyHashable : Any]? {
        return nil
    }
    
 
}
