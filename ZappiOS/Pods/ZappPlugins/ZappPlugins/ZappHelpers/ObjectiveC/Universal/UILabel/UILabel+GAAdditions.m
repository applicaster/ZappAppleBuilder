//
//  UILabel+GAAdditions.m
//  
//
//  Created by Anton Kononenko on 19/11/2015.
//
//

#import "UILabel+GAAdditions.h"
#import <UIKit/UILabel.h>

#pragma mark - Definitions
static CGFloat const kDefaultAnimationDuration = 0.3f;

@implementation UILabel (GAAdditions)

-(void)setText:(NSString *)text animationOptions:(UIViewAnimationOptions)animationOptions duration:(CGFloat)duration completion:(void (^)(BOOL finished))completion {
    __weak typeof(self) weakSelf = self;

    [UIView transitionWithView:self
                      duration:duration
                       options:animationOptions
                    animations:^{
                        weakSelf.text = text;
                    } completion:completion];
}

-(void)setText:(NSString *)text
animationOptions:(UIViewAnimationOptions)animationOptions
    completion:(void (^)(BOOL finished))completion{
    [self setText:text animationOptions:animationOptions duration:kDefaultAnimationDuration completion:completion];

}
@end
