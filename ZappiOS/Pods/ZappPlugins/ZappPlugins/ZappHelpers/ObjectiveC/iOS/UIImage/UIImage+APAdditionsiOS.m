//
//  UIImage+APAdditionsiOS.m
//  ZappPlugins
//
//  Created by Anton Kononenko on 11/13/18.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

#import "UIImage+APAdditionsiOS.h"

@implementation UIImage (APAdditionsiOS)

- (UIImage *)stretchableImageWithEdgeInsets:(UIEdgeInsets)edgeInsets {
    if ([self respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
        return [self resizableImageWithCapInsets:edgeInsets];
    } else {
        return [self stretchableImageWithLeftCapWidth:(NSInteger)edgeInsets.left
                                         topCapHeight:(NSInteger)edgeInsets.top];
    }
}

@end
