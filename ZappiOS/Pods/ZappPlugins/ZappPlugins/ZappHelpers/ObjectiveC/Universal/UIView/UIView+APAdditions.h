//
//  UIView+APAdditions.h
//  ApplicasterSDK
//
//  Created by Guy Kogus on 9/01/12.
//  Copyright (c) 2012 Applicaster. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 UIView additions taken from Three20
 */
@interface UIView (APAdditions)

/**
 Load the view from a XIB named after itself. This method will throw an exception if no XIB file can be found using the same name as the view's class.
 @param plistName name of the plist settings
 @param originalName of the origial view (if view is not custom)
 @param bundle - if the bundle is custom like Feed2 or CM
 @return A new view loaded from the XIB file.
 */

+ (id)viewFromXIBOfPlist:(NSString *)plistName withAPOriginalName:originalName andCustomBundle:(NSBundle *)bundle;

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

/**
 * Removes all subviews.
 */
- (void)removeAllSubviews;

/**
 * Centers the view in its superview.
 */
- (void)centerInSuperview;

/**
 * Centers the view using auto layout.
 */
- (void)centerInParentWithConsraints;

/**
 * Centers the view vertically within its superview.
 */
- (void)centerVertically;

/**
 Makes the view match his parent's bounds (the AutoLayout way).
 */
- (void)matchParent;

/**
 Makes the view match his parent's bounds minus the given insets.
 */
- (void)setInsetsFromParent:(UIEdgeInsets)insets;

/**
 * Centers the view horizontally within its superview.
 */
- (void)centerHorizontally;

/**
 Performs the block on self and all subviews of self.
 @discussion <block> is performed on the receiver as well as its descendants to be consistent with the UIView method <isDescendantOfView:>, which returns <code>YES</code> for the receiver as well as its descendants.
 @param block The block to be performed on each view, where the view is passed as the parameter.
 */
- (void)enumerateDescendantViewsUsingBlock:(void(^)(UIView *view))block;

/**
 Prints out the view and its subviews in an easy-to-read fashion.
 Note that this uses NSLog, not APLogger.
 */
- (void)printRecursively;

/**
 Load the view from a XIB named after itself. This method will throw an exception if no XIB file can be found using the same name as the view's class.
 @param bundle - if the xib found in a specific bundle like cm or feed
 @return A new view loaded from the XIB file.
 */

+ (id)viewFromXIBFromBundle:(NSBundle *)bundle;

/**
 + Load the view from a XIB.
 + This method will throw an exception if no XIB file can be found using the same name as the XIB's name.
 + @param xibName - the XIB's name
 + @return A new view loaded from the XIB file.
 + */
+ (id)viewFromXIB:(NSString *)xibName;

/**
 + Load the view from a XIB.
 + This method will throw an exception if no XIB file can be found using the same name as the XIB's name.
 + @param xibName - the XIB's name
 + @param bundle - if the xib found in a specific bundle like cm or feed
 + @return A new view loaded from the XIB file.
 + */
+ (id)searchXib:(NSString *)xibName inBundle:(NSBundle *)bundle;

/**
 *  Takes a screenshot of the view. Support new screenshot method for iOS 7
 *  @return screenshot image of the current view.
 */
- (UIImage *)screenShot __attribute__ ((deprecated));

/**
 @return Snapshot image of this view.
 */
- (UIImage *)snapshotImage;

/**
 This method takes blur snapshot
 */
-(UIImage *)blurredSnapshot;

/**
 This method takes blur snapshot with parameters
 */
- (UIImage *)blurredSnapshotWithColor:(UIColor *)backgroundColor alpha:(CGFloat)alpha radius:(CGFloat)radius deltaFactor:(CGFloat)deltaFactor;

-(UIViewController *)parentViewController;


@end
