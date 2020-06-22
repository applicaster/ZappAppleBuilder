//
//  UIFont+APAdditions.m
//  testAttributes
//
//  Created by Anton Kononenko on 11/19/14.
//  Copyright (c) 2014 Anton Kononenko. All rights reserved.
//

#import "UIFont+APAdditions.h"
#import <CoreText/CoreText.h>

@implementation UIFont (FontType)

- (BOOL)isBold
{
    CTFontRef fontRef = (__bridge CTFontRef)self;
    CTFontSymbolicTraits symbolicTraits = CTFontGetSymbolicTraits(fontRef);
    return (symbolicTraits & kCTFontBoldTrait);
}

- (BOOL)isItalic
{
    CTFontRef fontRef = (__bridge CTFontRef)self;
    CTFontSymbolicTraits symbolicTraits = CTFontGetSymbolicTraits(fontRef);
    return (symbolicTraits & kCTFontItalicTrait);
}

- (BOOL)isNormal {
    return [self isBold] == NO && [self isItalic] == NO;
}

@end
