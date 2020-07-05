//
//  UIView+APAdditions.m
//  ApplicasterSDK
//
//  Created by Guy Kogus on 9/01/12.
//  Copyright (c) 2012 Applicaster. All rights reserved.
//

#import <ZappPlugins/UIView+APAdditions.h>
#import <ZappPlugins/UIImage+APAdditions.h>
#import <ZappPlugins/NSObject+APAdditions.h>

@implementation UIView (APAdditions)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
	return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
	return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
	return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
	CGRect frame = self.frame;
	frame.origin.x = right - frame.size.width;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
	return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
	CGRect frame = self.frame;
	frame.origin.y = bottom - frame.size.height;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
	return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
	self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
	return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
	self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
	return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
	return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
	return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
	CGRect frame = self.frame;
	frame.origin = origin;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
	return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
	CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}

- (void)setInsetsFromParent:(UIEdgeInsets)insets{
    if (self.superview) {
        if(self.translatesAutoresizingMaskIntoConstraints){
            self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            CGRect frame = self.superview.bounds;
            float fixedWidth = self.superview.bounds.size.width - insets.left - insets.right;
            float fixedHeight = self.superview.bounds.size.height - insets.top - insets.bottom;
            
            if (fixedWidth > 0 && fixedHeight > 0) {
                frame = CGRectMake(insets.left,
                                   insets.top,
                                   fixedWidth,
                                   fixedHeight);
            }
            
            self.frame = frame;
        } else {
            [self clearAllConstraintOfAlignment];
            [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.superview
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1.0
                                                                        constant:insets.top]];
            
            [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                       attribute:NSLayoutAttributeLeading
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.superview
                                                                       attribute:NSLayoutAttributeLeading
                                                                      multiplier:1.0
                                                                        constant:insets.left]];
            
            [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.superview
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:insets.bottom]];
            
            [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.superview
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1.0
                                                                        constant:insets.right]];
        }
    }
}

- (void)matchParent {
    if (self.superview) {
        UIEdgeInsets insets = UIEdgeInsetsZero;
        [self setInsetsFromParent:insets];
    }
}

- (void)centerInParentWithConsraints {
    if (self.superview) {
        self.translatesAutoresizingMaskIntoConstraints = NO;

        NSLayoutConstraint *horizontalConsraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
        NSLayoutConstraint *verticalConsraint =[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];

        [NSLayoutConstraint activateConstraints:@[
         horizontalConsraint,
         verticalConsraint
        ]];
    }
}

- (void)clearAllConstraintOfAlignment {
    NSMutableArray *myConstraints = [NSMutableArray new];
    for (NSLayoutConstraint *constraint in self.superview.constraints) {
        if(constraint.firstItem == self || constraint.secondItem == self){
            [myConstraints addObject:constraint];
        }
    }
    [NSLayoutConstraint deactivateConstraints:myConstraints];
    
    NSMutableArray *widthAndHeightConstraints = [NSMutableArray new];
    for (NSLayoutConstraint *constraint in self.constraints) {
        if(constraint.firstItem == self){
            [widthAndHeightConstraints addObject:constraint];
        }
    }
    [NSLayoutConstraint deactivateConstraints:widthAndHeightConstraints];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAllSubviews {
	while (self.subviews.count) {
		UIView* child = self.subviews.lastObject;
		[child removeFromSuperview];
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)centerInSuperview
{
	[self centerHorizontally];
	[self centerVertically];
}

- (void)centerVertically
{
	if (self.superview != nil)
	{
		self.top = (self.superview.bounds.size.height - self.height) / 2.0;
	}
}

- (void)centerHorizontally
{
	if (self.superview != nil)
	{
		self.left = (self.superview.bounds.size.width - self.width) / 2.0;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)enumerateDescendantViewsUsingBlock:(void(^)(UIView *view))block
{
	NSParameterAssert(block != nil);
	
	// Perform on self as well.
	block(self);
	
	for (UIView *subview in self.subviews) {
		[subview enumerateDescendantViewsUsingBlock:^(UIView *view) {
			block(view);
		}];
	}
}

- (void)printView:(UIView *)view level:(NSInteger)level
{
	NSInteger padding = level * 4;
	NSMutableString *spaces = [NSMutableString stringWithCapacity:padding];
	for (NSInteger i = 0; i < padding - 1; ++i)
	{
		[spaces appendString:@"-"];
	}
	[spaces appendString:@"> "];
	
	// Print specially by class.
	if ([view isKindOfClass:[UILabel class]])
	{
		NSLog(@"%@%@ %@", spaces, view, [(UILabel *)view font]);
	}
	else
	{
		NSLog(@"%@%@", spaces, view);
	}
	
	++level;
	for (UIView *subview in view.subviews)
	{
		[self printView:subview level:level];
	}
}

- (void)printRecursively
{
	[self printView:self level:0];
}

+ (id)viewFromXIBFromBundle:(NSBundle *)bundle
{
    NSString *bundleName = NSStringFromClass(self);
    NSString *type = @"nib";
    NSString *pathForResource = [bundle pathForResource: bundleName ofType:type];
    if (!pathForResource) {
        NSString *closedAppBundleIdentifier = @"com.applicaster.ZappSDK";
        NSBundle *zappAppbundle = [NSBundle bundleWithIdentifier:closedAppBundleIdentifier];
        pathForResource = [zappAppbundle pathForResource: bundleName ofType:type];
        if (pathForResource) {
            bundle = zappAppbundle;
        }
    }
    return [self searchXib:bundleName inBundle:bundle];
}

+ (id)viewFromXIB:(NSString *)xibName
{
    return [self searchXib:xibName inBundle:[NSBundle mainBundle]];
}

+ (id)searchXib:(NSString *)xibName inBundle:(NSBundle *)bundle {
    id retVal = nil;
    if (xibName && [bundle pathForResource:xibName ofType:@"nib"]) {
        retVal = [[bundle loadNibNamed:xibName
                                 owner:nil
                               options:nil] firstObject];
    }
    return retVal;
}

+ (id)viewFromXIBOfPlist:(NSString *)plistName withAPOriginalName:originalName andCustomBundle:(NSBundle *)bundle
{
    NSDictionary *settingsPlist = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"]];
    
    NSString *retVal = [settingsPlist objectForKey:originalName];
    if ([retVal isNotEmpty] == NO)
    {
        retVal = originalName;
    }
    
    return [[bundle loadNibNamed:retVal
										  owner:nil
										options:nil] lastObject];
}

- (UIImage *)screenShot {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(self.bounds.size);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)snapshotImage{
    // Create the image context
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, self.window.screen.scale);
    
    // There he is! The new API method
    //[self snapshotViewAfterScreenUpdates:YES];
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    
    // Get the snapshot
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Be nice and clean your mess up
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

- (UIImage *)blurredSnapshot
{
    UIImage *snapshotImage = [self snapshotImage];
    
    // Now apply the blur effect using Apple's UIImageEffect category
    UIImage *blurredSnapshotImage = [snapshotImage applyTintEffectWithColor:[UIColor blackColor]];
    
    // Or apply any other effects available in "UIImage+ImageEffects.h"
    // UIImage *blurredSnapshotImage = [snapshotImage applyDarkEffect];
    // UIImage *blurredSnapshotImage = [snapshotImage applyExtraLightEffect];
    
    return blurredSnapshotImage;
}

- (UIImage *)blurredSnapshotWithColor:(UIColor *)backgroundColor alpha:(CGFloat)alpha radius:(CGFloat)radius deltaFactor:(CGFloat)deltaFactor
{
    UIImage *snapshotImage = [self snapshotImage];
    
    // Now apply the blur effect using Apple's UIImageEffect category
    UIImage *blurredSnapshotImage = [snapshotImage applyTintEffectWithColor:backgroundColor alpha:alpha radius:radius saturationDeltaFactor:deltaFactor];
    
    return blurredSnapshotImage;
}

-(UIViewController *)parentViewController {
    
    //Go up in responder hierarchy until we reach a ViewController or return nil
    //if we don't find one
    id object = [self nextResponder];
    
    while (![object isKindOfClass:[UIViewController class]] &&
           object != nil) {
        object = [object nextResponder];
    }
    
    return object;
}


@end
