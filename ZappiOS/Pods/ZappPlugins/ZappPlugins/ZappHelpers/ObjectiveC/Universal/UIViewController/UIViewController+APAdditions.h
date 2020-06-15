//
//  UIViewController+APAddition.h
//  ApplicasterSDK
//
//  Created by Tom Susel on 1/22/12.
//  Copyright (c) 2012 Applicaster. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 These helper methods are currently used for safe modal presentation/dismissal.
 */
@interface UIViewController (APAdditions)

/**
 Finds the modal presenter.
 @returns The view controller who presents the receiver modally or nil if there is none.
 */
- (UIViewController*)modalPresenter;

/**
 Finds the child presenter.
 @returns The view controller who presents the receiver as child view or nil if there is none.
 */
- (UIViewController *)childPresenter;

/**
 A safe dismiss for both iOS 5 and below. This method is designed to safely check that the current view controller is being displayed modally.
 @param animated If YES, this method animates the view as it’s dismissed; otherwise, it does not. If the device own iOS 5 a completion method will be activated.
 */
- (void)dismissModalViewControllerFromParentAnimated:(BOOL)animated completionHandler:(void (^)(void))completion;

/**
 A safe dismiss for both iOS 5 and below. This method is designed to safely check that the current view controller is being displayed modally.
 @param animated If YES, this method animates the view as it’s dismissed; otherwise, it does not.
 */
- (void)dismissModalViewControllerFromParentAnimated:(BOOL)animated;

/**
 Traverses the modal view controllers to find the view controller highest in the modal hierarchy.
 @return The top-most view controller presented modally over the current view controller.
 */
- (UIViewController *)topmostModalViewController;

/*
 Returns the top view controller of the navigation controller of the view controller,
 if the view controller has a navigation controller else returns nil.
 @return The top view controller of the navigation controller.
 */
- (UIViewController *)navigationTopViewController;

/**
 Performs all the steps required for adding a child view controller and it's view.
 @param childController The view controller that is being added to the receiver.
 @param view The new container view of the child view controller's view.
 */
- (void)addChildViewController:(UIViewController *)childController toView:(UIView *)view NS_AVAILABLE_IOS(5_0);

/**
 Performs all the steps required in removing a view controller from its parent view controller.
 */
- (void)removeViewFromParentViewController NS_AVAILABLE_IOS(5_0);

@end
