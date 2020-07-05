//
//  UIColor+ZPAdditions.h
//  ZappPlugins
//
//  Created by Alex Zchut on 03/07/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 UIColor helper category.
 */
@interface UIColor (ZPAdditions)

/**
 Turns a string of 8 hex characters representing a color in RGBA into a UIColor object. E.g. FFFFFFFF is white with alpha of 1.0, and 000000FF is black with an alpha of 1.0.
 @param hexString The string representing the new color.
 @return The new color.
 */
+ (UIColor *)colorWithRGBAHexString:(NSString *)hexString;

/**
 Same as above just change between the red and the alpha due to server replacement and had option for make the color darker
 @param darkerPercentage - the percentage of the darker color for instance: 0.3 means 30 %, 0.07 means 7%
 */
+ (UIColor *)colorWithRGBAHexStringForFeed2:(NSString *)hexString makeDarker:(float)darkerPercentage;

/**
 Turns a string of 8 hex characters representing a color in ARGB into a UIColor object. E.g. FFFFFFFF is white with alpha of 1.0, and FF000000 is black with an alpha of 1.0.
 @param hexString The string representing the new color.
 @return The new color.
 */
+ (UIColor *)colorWithARGBHexString:(NSString *)hexString;

/**
 Same as above just change between the red and the alpha due to server replacement and had option for make the color brighter
 @param brighterPercentage - the percentage of the brighter color for instance: 0.3 means 30 %, 0.07 means 7%
 */
+ (UIColor *)colorWithRGBAHexStringForFeed2:(NSString *)hexString makeBrighter:(float)brighterPercentage;

+ (UIColor *)colorMakeBrighter:(UIColor *)colorOriginal; //i think this is depracated becasue no class use it.

// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorWithRGBHexString:(NSString *)hexString;
/**
 @return YES if the color's alpha is 0, No otherwise
 */
- (BOOL)isClearColor;

/**
 @return YES if the color is considered light - https://gist.github.com/kaishin/8934076
 */
- (BOOL)isLight;



@end
