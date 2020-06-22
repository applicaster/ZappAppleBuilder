//
//  NSArray+APAdditions.m
//  ApplicasterSDK
//
//  Created by Guy Kogus on 31/10/12.
//  Copyright (c) 2012 Applicaster. All rights reserved.
//

#import <ZappPlugins/NSArray+APAdditions.h>

@implementation NSArray (APAdditions)

- (id)objectOrNilAtIndex:(NSUInteger)index
{
	id object = nil;
	if (index < [self count])
		object = [self objectAtIndex:index];
	return object;
}

@end
