//
//  NSObject+Swizzle.h
//  ZappPlugins
//
//  Created by Alex Zchut on 23/01/2018.
//  Copyright © 2018 Applicaster Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(Swizzle)

+ (BOOL)swizzleClassMethods:(Class)class dstSel:(SEL)dstSel srcSel:(SEL)srcSel;
+ (BOOL)swizzleInstanceMethods:(Class)class dstSel:(SEL)dstSel srcSel:(SEL)srcSel;

@end
