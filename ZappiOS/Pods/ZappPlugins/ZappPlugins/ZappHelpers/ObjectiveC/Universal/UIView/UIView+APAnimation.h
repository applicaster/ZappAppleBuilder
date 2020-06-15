//
//  UIView+APAnimation.h
//  ApplicasterSDK
//
//  Created by Philip Kramarov on 3/30/14.
//  Copyright (c) 2014 Applicaster. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSUInteger, APAnimationType) {
    APAnimationTypeNone = 0,
    APAnimationTypeFade,
    APAnimationTypeMove,
    APAnimationTypePush,
    APAnimationTypeReveal,
    APAnimationTypeCameraIris,
    APAnimationTypeCameraIrisHollowOpen,
    APAnimationTypeCameraIrisHollowClose,
    APAnimationTypeCube,
    APAnimationTypeAlignedCube,
    APAnimationTypeFlip,
    APAnimationTypeAlignedFlip,
    APAnimationTypeOglFlip,
    APAnimationTypeRotate,
    APAnimationTypePageCurl,
    APAnimationTypePageUnCurl,
    APAnimationTypeRippleEffect,
    APAnimationTypeSuckEffect
};

typedef NS_ENUM(NSUInteger, APAnimationFrom) {
    APAnimationFromPredefined = 0, // Predefined defualt animation transition start from for the selected animation.
    APAnimationFromRight,
    APAnimationFromLeft,
    APAnimationFromTop,
    APAnimationFromBottom
};

typedef NS_ENUM(NSUInteger, APAnimationTimingFunction) {
    APAnimationTimingFunctionPredefined = 0, // Predefined defualt animation timing function for the selected animation.
    APAnimationTimingFunctionLinear,
    APAnimationTimingFunctionEaseIn,
    APAnimationTimingFunctionEaseOut,
    APAnimationTimingFunctionEaseInEaseOut,
    APAnimationTimingFunctionDefault
};

@interface APAnimation : NSObject

@property (nonatomic, assign) APAnimationType type;
@property (nonatomic, assign) APAnimationFrom from; // defualt value is APAnimationFromRight or predefined by the animations types.
@property (nonatomic, assign) APAnimationTimingFunction timingFunction; // defualt value is APAnimationTimingFunctionLinear or predefined by the animations types.
@property (nonatomic, assign) CGFloat duration; // defualt value is 0.8 or predefined by the animations types.

@end

@interface UIView (APAnimation)

/**
 Starts core animation with animation type, animation from and completion block when the animation is finished.
 @param animation Type of animation @see APAnimationType
 @param block Called after animation is finished.
 */
- (void)startAnimation:(APAnimation *)animation
       completionBlock:(void (^)(void))block;

/**
 Adds core animation to the view's layer. Its possible to add multiple animations.
 @param animation Type of animation. @see APAnimationType
*/
- (void)addAnimation:(APAnimation *)animation;

/**
 Commits(starts) added animation to view's layer with completion block.
 @param block Called after animation is finished.
*/
- (void)commitAnimationWithCompletionBlock:(void (^)(void))block;


/**
 Remove all animations attached.
 */
- (void)removeAllAnimations;

@end
