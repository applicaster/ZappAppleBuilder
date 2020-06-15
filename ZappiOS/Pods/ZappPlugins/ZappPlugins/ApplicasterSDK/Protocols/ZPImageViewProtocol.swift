//
//  ZPImageViewProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 07/08/2018.
//

import Foundation
import UIKit

@objc public protocol ZPImageViewProtocol {

    /**
     Loads the image from url without placeholder while loading.
     */
    @objc func setImage(url: URL?)
    
    /**
     Loads the image from url with placeholder while loading.
     */
    @objc func setImage(url: URL?, placeholderImage: UIImage?)

    /**
     Loads the image from url with placeholder while loading.
     @param serverResizable Defines if the server should resize the image to the object image size.
     */
    @objc func setImage(url: URL?, placeholderImage: UIImage?, serverResizable: Bool)

    /**
     Loads the image from url with placeholder while loading.
     @param url url
     @param fallbackImage The Image that will be used when if the original image will failed load (can be used for example for cached local image in offline mode).
     If nil the placeholder will be used. The assumption is that this image is the same type as the original (if gif - gig if png png).
     @param placeholderImage placeholderImage
     @param serverResizable Defines if the server should resize the image to the object image size.
     */
    @objc func setImage(url: URL?, fallbackImage: UIImage?, placeholderImage: UIImage?, serverResizable: Bool)

    /**
     Loads the image from url with placeholder while loading.
     @param serverResizable Defines if the server should resize the image to the object image size.
     @param maskImage Mask Image that will be used to crop the image
     @note Image and Mask Image should be the same size. Mask image should have black and white colors.
     @note White color should be used to hide part of base image
     @note Black color should be used to leave part of base image visible
     */
    @objc func setImage(url: URL?, maskImage: UIImage?, placeholderImage: UIImage?, serverResizable: Bool)

    /**
     Loads the image from url with placeholder while loading.
     @param serverResizable Defines if the server should resize the image to the object image size.
     @param maskImage Mask Image that will be used to crop the image
     @param fallbackImage The Image that will be used when if the original image will failed load (can be used for example for cached local image in offline mode).
     If nil the placeholder will be used. The assumption is that this image is the same type as the original (if gif - gig if png png).
     @note Image and Mask Image should be the same size. Mask image should have black and white colors.
     @note White color should be used to hide part of base image
     @note Black color should be used to leave part of base image visible
     */
    @objc func setImage(url: URL?, maskImage: UIImage?, fallbackImage: UIImage?, placeholderImage: UIImage?, serverResizable: Bool)

}
