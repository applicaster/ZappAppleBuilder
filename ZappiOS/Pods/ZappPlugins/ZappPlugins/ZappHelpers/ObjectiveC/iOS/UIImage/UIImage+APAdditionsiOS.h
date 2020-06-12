//
//  UIImage+APAdditionsiOS.h
//  ZappPlugins
//
//  Created by Anton Kononenko on 11/13/18.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

/**
 Helper category currently used for getting images from the APCore bundle.
 */
@interface UIImage (APAdditionsiOS)

/**
 Creates and returns a new image object with the specified edge insets.
 
 This helper method was designed to deal with backwards compatibility of the deprecated method stretchableImageWithLeftCapWidth:topCapHeight:
 
 @param edgeInsets The values to use for the edge insets.
 @return A new image object with the specified edge insets.
 */
- (UIImage *)stretchableImageWithEdgeInsets:(UIEdgeInsets)edgeInsets;

@end

