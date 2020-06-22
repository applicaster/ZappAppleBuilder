//
//  NSObject+APAdditions.m
//  ApplicasterSDK
//
//  Created by Tom Susel on 1/4/12.
//  Copyright (c) 2012 Applicaster. All rights reserved.
//

#import <ZappPlugins/NSObject+APAdditions.h>

BOOL isEmpty(NSObject *object) {
	return ![object isNotEmpty];
}

@implementation NSObject (APAdditions)

- (BOOL)isNotEmpty
{
    return !([self isKindOfClass:[NSNull class]]
             || ([self respondsToSelector:@selector(length)]
                 && [(NSString *)self length] == 0)
             || ([self respondsToSelector:@selector(count)]
                 && [(NSArray *)self count] == 0));  
}

@end
