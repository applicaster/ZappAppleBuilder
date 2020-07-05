//
//  NSData+APAdditions.h
//  ApplicasterSDK
//
//  Created by Guy Kogus on 8/01/12.
//  Copyright (c) 2012 Applicaster. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Additions taken from Three20.
 */
@interface NSData (APAdditions)

/**
 * Calculate the md5 hash of this data using CC_MD5.
 *
 * @return md5 hash of this data
 */
- (nonnull NSString *)md5Hash;

/**
 * Calculate the sha256 hash of this data using CC_SHA256.
 *
 * @return sha256 hash of this data
 */
- (nullable NSString *)sha256Hash;

@end
