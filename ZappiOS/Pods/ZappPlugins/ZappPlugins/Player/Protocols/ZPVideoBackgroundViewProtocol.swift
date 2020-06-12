//
//  ZPVideoBackgroundViewProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 09/08/2018.
//

import Foundation

@objc public protocol ZPVideoBackgroundViewProtocol: NSObjectProtocol {

    /**
     Set video url
     */
    func setVideoUrl(videoUrl: URL)
}
