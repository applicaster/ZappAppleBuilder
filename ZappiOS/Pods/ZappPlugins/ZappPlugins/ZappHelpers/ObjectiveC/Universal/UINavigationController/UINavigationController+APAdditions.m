//
//  UINavigationController+APAdditions.m
//  ApplicasterSDK
//
//  Created by Guy Kogus on 7/02/12.
//  Copyright (c) 2012 Applicaster. All rights reserved.
//

#import <ZappPlugins/UINavigationController+APAdditions.h>

@implementation UINavigationController (APAdditions)

- (UIViewController *)rootViewController {
	UIViewController *rootViewController = nil;
	
	if ([self.viewControllers count] > 0) {
		rootViewController = [self.viewControllers objectAtIndex:0];
	}
	
	return rootViewController;
}

@end
