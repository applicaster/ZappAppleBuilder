//
//  UIImage+Extensions.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 12/17/19.
//  Copyright © 2019 Applicaster LTD. All rights reserved.
//

import UIKit

extension UIImage {
    public func downsample(imageAt imageURL: URL,
                    to pointSize: CGSize,
                    scale: CGFloat) -> UIImage {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions)!
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        let downsampleOptions =
            [kCGImageSourceCreateThumbnailFromImageAlways: true,
             kCGImageSourceShouldCacheImmediately: true,
             kCGImageSourceCreateThumbnailWithTransform: true,
             kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
        let downsampledImage =
            CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions)!
        return UIImage(cgImage: downsampledImage)
    }
}
