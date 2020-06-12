//
//  ZAAppDelegateConnectorImageProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 09/08/2018.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public protocol ZAAppDelegateConnectorImageProtocol {

    @objc func setImage(to imageView:UIImageView, url: URL?, maskImage: UIImage?, fallbackImage: UIImage?, placeholderImage: UIImage?, serverResizable: Bool)
    @objc func setImage(to imageView:UIImageView, url: URL?, placeholderImage: UIImage?)
    @objc func setImage(with url: URL?, placeholderImage: UIImage?, completion: ((UIImage?, Error?) -> ())?)

    ///Animation button
    @objc func setAnimatedImage(forButton: UIButton, url: URL, controlState: UIControl.State)
}
