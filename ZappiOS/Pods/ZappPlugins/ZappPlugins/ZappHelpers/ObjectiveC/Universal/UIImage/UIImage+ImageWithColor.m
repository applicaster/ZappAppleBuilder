//
//  UIImage+ImageWithColor.m
//  ZappPlugins
//
//  Created by Alex Zchut on 03/07/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//

#import "UIImage+ImageWithColor.h"

@implementation UIImage (ImageWithColor)

+ (UIImage *)imageFromColor:(UIColor *)color
{
    /* Create image 1x1 pixel with orange color */
    return [self imageFromColor:color andSize:CGSizeMake(1, 1)];
}

+ (UIImage *)imageFromColor:(UIColor *)color andSize:(CGSize)imageSize
{
    if (!imageSize.width || !imageSize.height) {
        return nil;
    }
    
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)clearImage
{
    return [self imageFromColor:[UIColor clearColor]];
}

@end
