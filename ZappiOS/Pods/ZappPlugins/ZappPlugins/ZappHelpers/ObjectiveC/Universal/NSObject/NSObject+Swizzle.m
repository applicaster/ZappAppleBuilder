//
//  NSObject+Swizzle.m
//  ZappPlugins
//
//  Created by Alex Zchut on 23/01/2018.
//  Copyright © 2018 Applicaster Ltd. All rights reserved.
//

#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

@implementation NSObject(Swizzle)

+ (BOOL)swizzleInstanceMethods:(Class)srcClass dstSel:(SEL)dstSel srcSel:(SEL)srcSel {
    Method dstMethod = class_getInstanceMethod(srcClass, dstSel);
    Method srcMethod = class_getInstanceMethod(srcClass, srcSel);
    if (!srcMethod) {
        @throw [NSException exceptionWithName:@"InvalidParameter"
                                       reason:[NSString stringWithFormat:@"Missing source method implementation for swizzling!  Class %@, Source: %@, Destination: %@", NSStringFromClass(srcClass), NSStringFromSelector(srcSel), NSStringFromSelector(dstSel)]
                                     userInfo:nil];
    }
    IMP srcIMP = method_getImplementation(srcMethod);
    if (class_addMethod(srcClass, dstSel, srcIMP, method_getTypeEncoding(srcMethod))) {
        class_replaceMethod(srcClass, dstSel, method_getImplementation(dstMethod), method_getTypeEncoding(dstMethod));
    }
    else {
        method_exchangeImplementations(dstMethod, srcMethod);
    }
    return (method_getImplementation(srcMethod) == method_getImplementation(class_getInstanceMethod(srcClass, dstSel)));
}

+ (BOOL)swizzleClassMethods:(Class)srcClass dstSel:(SEL)dstSel srcSel:(SEL)srcSel {
    Class metaClass = object_getClass(srcClass);
    if (!metaClass || metaClass == srcClass) { // the metaClass being the same as class shows that class was already a MetaClass
        @throw [NSException exceptionWithName:@"InvalidParameter"
                                       reason:[NSString stringWithFormat:@"%@ does not have a meta class to swizzle methods on!", NSStringFromClass(srcClass)]
                                     userInfo:nil];
    }
    return [self swizzleInstanceMethods:metaClass dstSel:dstSel srcSel:srcSel];
}

@end
