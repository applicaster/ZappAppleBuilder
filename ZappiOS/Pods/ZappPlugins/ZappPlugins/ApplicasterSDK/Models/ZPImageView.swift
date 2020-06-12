//
//  ZPImageView.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 08/08/2018.
//

import UIKit

@objc open class ZPImageView: UIImageView, ZPImageViewProtocol {

    open func setImage(url: URL?) {
        self.setImage(url: url, placeholderImage: nil)
    }

    open func setImage(url: URL?, placeholderImage: UIImage?) {
        self.setImage(url: url,
                      placeholderImage: placeholderImage,
                      serverResizable: false)
    }

    open func setImage(url: URL?, placeholderImage: UIImage?, serverResizable: Bool) {
        self.setImage(url: url,
                      fallbackImage: nil,
                      placeholderImage: placeholderImage,
                      serverResizable: serverResizable)
    }

    open func setImage(url: URL?, fallbackImage: UIImage?, placeholderImage: UIImage?, serverResizable: Bool) {
        self.setImage(url: url, maskImage: nil,
                      fallbackImage: fallbackImage,
                      placeholderImage: placeholderImage,
                      serverResizable: serverResizable)
    }

    open func setImage(url: URL?, maskImage: UIImage?, placeholderImage: UIImage?, serverResizable: Bool) {
        self.setImage(url: url, maskImage: maskImage,
                      fallbackImage: nil,
                      placeholderImage: placeholderImage,
                      serverResizable: serverResizable)
    }

    open func setImage(url: URL?, maskImage: UIImage?, fallbackImage: UIImage?, placeholderImage: UIImage?, serverResizable: Bool) {

        ZAAppConnector.sharedInstance().imageDelegate.setImage(to: self,
                                                               url: url,
                                                               maskImage: maskImage,
                                                               fallbackImage: fallbackImage,
                                                               placeholderImage: placeholderImage,
                                                               serverResizable: serverResizable)
    }
}
