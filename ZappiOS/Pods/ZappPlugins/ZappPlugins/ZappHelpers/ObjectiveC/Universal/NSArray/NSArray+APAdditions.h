//
//  NSArray+APAdditions.h
//  ApplicasterSDK
//
//  Created by Guy Kogus on 31/10/12.
//  Copyright (c) 2012 Applicaster. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Helper methods for NSArray.
 */
@interface NSArray (APAdditions)

/**
 Returns the object located at index.
 @param index An index within the bounds of the array, or nil if the index is beyond the bounds.
 @discussion If index is beyond the end of the array (that is, if <index> is greater than or equal to the value returned by <count>), nil is returned.
 */
- (id)objectOrNilAtIndex:(NSUInteger)index;

@end
