//
//  UIScrollView+APAdditions.m
//  ApplicasterSDK
//
//  Created by Guy Kogus on 31/10/12.
//  Copyright (c) 2012 Applicaster. All rights reserved.
//

#import <ZappPlugins/UIScrollView+APAdditions.h>

@implementation UIScrollView (APAdditions)

- (void)scrollToRightAnimated:(BOOL)animated
{
	CGFloat xOffset = self.contentSize.width - self.frame.size.width;
	if (xOffset != self.contentOffset.x)
		[self setContentOffset:CGPointMake(xOffset, self.contentOffset.y)
					  animated:animated];
}

@end
