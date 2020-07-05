//
//  UIView+APAnimation.m
//  ApplicasterSDK
//
//  Created by Philip Kramarov on 3/30/14.
//  Copyright (c) 2014 Applicaster. All rights reserved.
//

#import <ZappPlugins/UIView+APAnimation.h>
#import <QuartzCore/QuartzCore.h>

@implementation APAnimation

@end

@implementation UIView (APAnimation)

- (void)startAnimation:(APAnimation *)animation
        completionBlock:(void (^)(void))block {
    if (animation.type != APAnimationTypeNone) {
        [self addAnimation:animation];
        [self commitAnimationWithCompletionBlock:block];
    } else {
        block();
    }
}

- (void)addAnimation:(APAnimation *)animation {
    
    if (animation.type == APAnimationTypeNone || animation.type > APAnimationTypeSuckEffect) return;
    if (animation.timingFunction > APAnimationTimingFunctionDefault) animation.timingFunction = APAnimationTimingFunctionPredefined;
    if (animation.from > APAnimationFromBottom) animation.from = APAnimationFromPredefined;
        
    CATransition *transition = [CATransition animation];
    transition.type = self.animationTypes[animation.type];

    switch (animation.type) {
        case APAnimationTypeFade: {
            if (animation.duration < 0.001) animation.duration = 0.4;
            break;
        }
        case APAnimationTypeCube: {
            if (animation.timingFunction == APAnimationTimingFunctionPredefined) animation.timingFunction = APAnimationTimingFunctionEaseInEaseOut;
            break;
        }
        default: {
            break;
        }
    }
    
    if (animation.timingFunction == APAnimationTimingFunctionPredefined) animation.timingFunction = APAnimationTimingFunctionLinear;
    transition.timingFunction = self.timeFunctionTypes[animation.timingFunction];
    
    if (animation.from == APAnimationFromPredefined) animation.from = APAnimationFromRight;
    transition.subtype = self.animationSubtypes[animation.from];
    
    if (animation.duration < 0.001) animation.duration = 0.8;
    transition.duration = animation.duration;
    
    [self.layer addAnimation:transition forKey:nil];
}

- (void)commitAnimationWithCompletionBlock:(void (^)(void))block {
    [CATransaction setCompletionBlock:block];
    [CATransaction commit];
}

- (void)removeAllAnimations {
    [self.layer removeAllAnimations];
}

#pragma mark - Private

- (NSArray *)animationTypes {
    return @[
             @"none",
             kCATransitionFade,
             kCATransitionMoveIn,
             kCATransitionPush,
             kCATransitionReveal,
             @"cameraIris",
             @"cameraIrisHollowOpen",
             @"cameraIrisHollowClose",
             @"cube",
             @"alignedCube",
             @"flip",
             @"alignedFlip",
             @"oglFlip",
             @"rotate",
             @"pageCurl",
             @"pageUnCurl",
             @"rippleEffect",
             @"suckEffect"];
}

- (NSArray *)animationSubtypes {
    return @[
             @"predefined",
             kCATransitionFromRight,
             kCATransitionFromLeft,
             kCATransitionFromTop,
             kCATransitionFromBottom];
}

- (NSArray *)timeFunctionTypes {
    return @[
             @"predefined",
             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
}

@end
