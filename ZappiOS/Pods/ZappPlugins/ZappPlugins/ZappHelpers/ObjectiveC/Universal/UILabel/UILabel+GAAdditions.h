//
//  UILabel+GAAdditions.h
//  
//
//  Created by Anton Kononenko on 19/11/2015.
//
//

@import UIKit;

@interface UILabel (GAAdditions)

/**
 *  Change text of the label with antimation
 *
 *  @param text             new text that should be changed
 *  @param animationOptions The duration of the transition animation, measured in seconds. If you specify a negative value or 0, the transition is made without animations.
 *  @param completion       A block object to be executed when the animation sequence ends. This block has no return value and takes a single Boolean argument that indicates whether or not the animations actually finished before the completion handler was called. If the duration of the animation is 0, this block is performed at the beginning of the next run loop cycle. This parameter may be NULL.
 */
-(void)setText:(NSString *)text animationOptions:(UIViewAnimationOptions)animationOptions completion:(void (^)(BOOL finished))completion;

/**
 *  Change text of the label with antimation
 *
 *  @param text             new text that should be changed
 *  @param animationOptions The duration of the transition animation, measured in seconds. If you specify a negative value or 0, the transition is made without animations.
 *  @param duration         The duration of the transition animation, measured in seconds. If you specify a negative value or 0, the transition is made without animations.
 *  @param completion       A block object to be executed when the animation sequence ends. This block has no return value and takes a single Boolean argument that indicates whether or not the animations actually finished before the completion handler was called. If the duration of the animation is 0, this block is performed at the beginning of the next run loop cycle. This parameter may be NULL.
 */
-(void)setText:(NSString *)text animationOptions:(UIViewAnimationOptions)animationOptions duration:(CGFloat)duration completion:(void (^)(BOOL finished))completion;

@end
