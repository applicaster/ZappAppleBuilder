//
//  NSObject+APAdditions.h
//  ApplicasterSDK
//
//  Created by Tom Susel on 1/4/12.
//  Copyright (c) 2012 Applicaster. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Performs ![object isNotEmpty], which allows to properly check emptiness of anything, even nil.
 @param object The object to check for emptiness.
 @return YES if the object is empty or nil, NO otherwise.
 */
extern BOOL isEmpty(NSObject *object);

/**
 Comfort methods commonly used.
 */
@interface NSObject (APAdditions)

/**
 Tests if an item is empty.
 @return YES if the empty is nil, [NSNull null], an empty string/array/dictionary/etc, etc.
 */
- (BOOL)isNotEmpty;

@end
