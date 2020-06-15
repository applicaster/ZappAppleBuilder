//
//  UIColor+ZPAdditions.m
//  ZappPlugins
//
//  Created by Alex Zchut on 03/07/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//

#import "UIColor+ZPAdditions.h"

@implementation UIColor (ZPAdditions)

+ (UIColor *)colorMakeBrighter:(UIColor *)colorOriginal
{
    UIColor *color = nil;
	
    CGFloat redF;
    CGFloat greenF;
    CGFloat blueF;
    CGFloat alphaF;
    
    [colorOriginal getRed:&redF green:&greenF blue:&blueF alpha:&alphaF];
    
    float brighter = 0;
    
    brighter = 0.20;
    
    color = [UIColor colorWithRed:redF / 255.0 + brighter
                            green:greenF / 255.0 + brighter
                             blue:blueF / 255.0 + brighter
                            alpha:alphaF / 255.0];
    
    return color;
}

+ (UIColor *)colorWithARGBHexString:(NSString *)hexString {
    return [self colorWithRGBAHexStringForFeed2:hexString makeBrighter:0];
}

+ (UIColor *)colorWithRGBAHexStringForFeed2:(NSString *)hexString makeBrighter:(float)brighterPercentage
{
    UIColor *color = nil;
    
    if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString substringFromIndex:1];
    }
	
	if ([hexString length] == 8) {
		NSString *alpha	= [@"0x" stringByAppendingString:[hexString substringWithRange:NSMakeRange(0, 2)]];
		NSString *red = [@"0x" stringByAppendingString:[hexString substringWithRange:NSMakeRange(2, 2)]];
		NSString *green	= [@"0x" stringByAppendingString:[hexString substringWithRange:NSMakeRange(4, 2)]];
		NSString *blue	= [@"0x" stringByAppendingString:[hexString substringWithRange:NSMakeRange(6, 2)]];
		
		// For scanning the hex values
		NSScanner *scanner;
		float redF;
		float greenF;
		float blueF;
		float alphaF;
		
		scanner = [NSScanner scannerWithString:red];
		[scanner scanHexFloat:&redF];
		scanner = [NSScanner scannerWithString:green];
		[scanner scanHexFloat:&greenF];
		scanner = [NSScanner scannerWithString:blue];
		[scanner scanHexFloat:&blueF];
		scanner = [NSScanner scannerWithString:alpha];
		[scanner scanHexFloat:&alphaF];
		
        float brighter = 0;
        if (brighterPercentage > 0)
        {
            brighter = brighterPercentage;
        }
		color = [UIColor colorWithRed:redF / 255.0 + brighter
								green:greenF / 255.0 + brighter
								 blue:blueF / 255.0 + brighter
								alpha:alphaF / 255.0];
	}
	
	return color;
}

+ (UIColor *)colorWithRGBAHexStringForFeed2:(NSString *)hexString makeDarker:(float)darkerPercentage
{
    UIColor *color = nil;
	
	if ([hexString length] == 8) {
		NSString *alpha	= [@"0x" stringByAppendingString:[hexString substringWithRange:NSMakeRange(0, 2)]];
		NSString *red = [@"0x" stringByAppendingString:[hexString substringWithRange:NSMakeRange(2, 2)]];
		NSString *green	= [@"0x" stringByAppendingString:[hexString substringWithRange:NSMakeRange(4, 2)]];
		NSString *blue	= [@"0x" stringByAppendingString:[hexString substringWithRange:NSMakeRange(6, 2)]];
		
		// For scanning the hex values
		NSScanner *scanner;
		float redF;
		float greenF;
		float blueF;
		float alphaF;
		
		scanner = [NSScanner scannerWithString:red];
		[scanner scanHexFloat:&redF];
		scanner = [NSScanner scannerWithString:green];
		[scanner scanHexFloat:&greenF];
		scanner = [NSScanner scannerWithString:blue];
		[scanner scanHexFloat:&blueF];
		scanner = [NSScanner scannerWithString:alpha];
		[scanner scanHexFloat:&alphaF];
		
        float darker = 0;
        if (darkerPercentage > 0)
        {
            darker = darkerPercentage;
        }
		color = [UIColor colorWithRed:redF / 255.0 - darker
								green:greenF / 255.0 - darker
								 blue:blueF / 255.0 - darker
								alpha:alphaF / 255.0];
	}
	
	return color;
}

+ (UIColor *)colorWithRGBAHexString:(NSString *)hexString {
	UIColor *color = nil;
	
	if ([hexString length] == 8) {
		NSString *red	= [@"0x" stringByAppendingString:[hexString substringWithRange:NSMakeRange(0, 2)]];
		NSString *green = [@"0x" stringByAppendingString:[hexString substringWithRange:NSMakeRange(2, 2)]];
		NSString *blue	= [@"0x" stringByAppendingString:[hexString substringWithRange:NSMakeRange(4, 2)]];
		NSString *alpha	= [@"0x" stringByAppendingString:[hexString substringWithRange:NSMakeRange(6, 2)]];
		
		// For scanning the hex values
		NSScanner *scanner;
		float redF;
		float greenF;
		float blueF;
		float alphaF;
		
		scanner = [NSScanner scannerWithString:red];
		[scanner scanHexFloat:&redF];
		scanner = [NSScanner scannerWithString:green];
		[scanner scanHexFloat:&greenF];
		scanner = [NSScanner scannerWithString:blue];
		[scanner scanHexFloat:&blueF];
		scanner = [NSScanner scannerWithString:alpha];
		[scanner scanHexFloat:&alphaF];
		
		color = [UIColor colorWithRed:redF / 255.0
								green:greenF / 255.0
								 blue:blueF / 255.0
								alpha:alphaF / 255.0];
	}
	
	return color;
}

- (BOOL)isClearColor {
    CGFloat alpha;
    BOOL retVal = NO;
    
    [self getRed:NULL green:NULL blue:NULL alpha:&alpha];
    if (alpha == 0) {
        retVal = YES;
    }
    return retVal;
}

// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorWithRGBHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (BOOL)isLight
{
    return [self perceivedLightnessW3C] >= .5;
}

//returns the value of luminance of the color
//taken from: https://gist.github.com/kaishin/8934076
- (CGFloat)perceivedLightnessW3C
{
    CGFloat red, green, blue, alpha;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    CGFloat lightness = 0.299 * red + 0.587 * green + 0.114 * blue;
    
    return lightness;
}

@end
