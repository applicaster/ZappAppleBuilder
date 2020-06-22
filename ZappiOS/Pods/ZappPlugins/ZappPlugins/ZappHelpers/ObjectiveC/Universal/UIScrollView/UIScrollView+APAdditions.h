//
//  UIScrollView+APAdditions.h
//  ApplicasterSDK
//
//  Created by Guy Kogus on 31/10/12.
//  Copyright (c) 2012 Applicaster. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Helper methods for UIScrollView.
 */
@interface UIScrollView (APAdditions)

/**
 The y offset stays the same, while the x offset becomes the difference between the content width and the frame width.
 @param animated This value is passed on to the <setContentOffset:animated:> method.
 */
- (void)scrollToRightAnimated:(BOOL)animated;

@end
