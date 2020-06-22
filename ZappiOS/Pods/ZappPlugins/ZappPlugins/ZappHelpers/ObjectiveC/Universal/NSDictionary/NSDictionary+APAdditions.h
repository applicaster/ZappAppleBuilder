//
//  NSObject+APAdditions.h
//  ApplicasterSDK
//
//  Created by Tom Susel on 1/4/12.
//  Copyright (c) 2012 Applicaster. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Comfort methods commonly used.
 */
@interface NSDictionary (APAdditions)

/**
 @param aKey - the key that you are looking for it's value. If the key is NSString it looks for the key case insensitive. If you have same key with different case so it will return the first one matching.
 @return the first object found for the given key.
 */
- (id)objectForKeyCaseInsensitive:(id)aKey;


/**
 Retrive from Dictionary Array with same prefixes

 @param aKey - the key that you are looking for it's value. 
 @return Array of items with same prefix in the key
 */
- (NSArray *)objectsArrayForKeysWithSamePrefix:(id)aKey;
- (NSDictionary *)dictionaryByMergingWith:(NSDictionary *)dict;
+ (NSDictionary *)dictionaryByMerging:(NSDictionary *)src with:(NSDictionary *)otherDict;
- (NSUInteger)hash;
@end
