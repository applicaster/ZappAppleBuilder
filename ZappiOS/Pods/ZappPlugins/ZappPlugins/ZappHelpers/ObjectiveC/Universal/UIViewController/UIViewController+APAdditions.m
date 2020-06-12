//
//  UIViewController+APAddition.m
//  ApplicasterSDK
//
//  Created by Tom Susel on 1/22/12.
//  Copyright (c) 2012 Applicaster. All rights reserved.
//

#import <ZappPlugins/UIView+APAdditions.h>
#import <ZappPlugins/UIViewController+APAdditions.h>

@implementation UIViewController (APAdditions)

- (UIViewController*)modalPresenter{
    UIViewController *parentVC = nil;
    
    if ([self respondsToSelector:@selector(presentingViewController)] == YES){
        parentVC = self.presentingViewController;
    }
    else{
        parentVC = self.parentViewController;
    }

    if (parentVC.presentedViewController != self){
        parentVC = nil;
    }

    return parentVC;
}

- (UIViewController *)childPresenter {
    UIViewController *parentVC = [self parentViewController];

    if ([parentVC presentedViewController] != self) {
        parentVC = nil;
    }

    return parentVC;

}

- (void)dismissModalViewControllerFromParentAnimated:(BOOL)animated completionHandler:(void(^)(void))completion{
	UIViewController *modalPresenter = [self modalPresenter];
    [modalPresenter dismissViewControllerAnimated:animated completion:completion];
}

- (void)dismissModalViewControllerFromParentAnimated:(BOOL)animated{
    [self dismissModalViewControllerFromParentAnimated:animated completionHandler:^{}];
}

- (UIViewController *)topmostModalViewController {
	UIViewController *topViewController = self;
	
	while (topViewController.presentedViewController != nil) {
		topViewController = topViewController.presentedViewController;
	}
	
	return topViewController;
}

- (UIViewController *)navigationTopViewController {
    UIViewController *retVal = nil;
    if ([self respondsToSelector:@selector(navigationController)]) {
        retVal = self.navigationController.topViewController;
    }

    return retVal;
}

- (void)addChildViewController:(UIViewController *)childController toView:(UIView *)view
{
	[self addChildViewController:childController];
	[view addSubview:childController.view];
	[childController.view matchParent];
	[childController didMoveToParentViewController:self];
}

- (void)removeViewFromParentViewController
{
	[self willMoveToParentViewController:nil];
	[self.view removeFromSuperview];
	[self removeFromParentViewController];
}

@end
