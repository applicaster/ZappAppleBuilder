//
//  UIImage+ImageWithColor.h
//  ZappPlugins
//
//  Created by Alex Zchut on 03/07/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageWithColor)

+ (UIImage *)imageFromColor:(UIColor *)color;
+ (UIImage *)imageFromColor:(UIColor *)color andSize:(CGSize)imageSize;

+ (UIImage *)clearImage;

@end
