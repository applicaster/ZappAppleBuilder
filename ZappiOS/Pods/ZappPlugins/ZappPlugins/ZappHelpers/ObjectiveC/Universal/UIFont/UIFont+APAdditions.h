//
//  UIFont+APAdditions.h
//  testAttributes
//
//  Created by Anton Kononenko on 11/19/14.
//  Copyright (c) 2014 Anton Kononenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (FontType)

/**
@return YES if the UIFont is BOLD, NO otherwise.
*/
- (BOOL)isBold;

/**
@return YES if the UIFont is Italic, NO otherwise.
*/
- (BOOL)isItalic;

/**
@return YES if the UIFont is Normal, NO otherwise.
*/
- (BOOL)isNormal;

@end
