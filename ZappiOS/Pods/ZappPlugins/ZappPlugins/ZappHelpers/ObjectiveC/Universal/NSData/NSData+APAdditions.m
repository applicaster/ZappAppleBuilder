//
//  NSData+APAdditions.m
//  ApplicasterSDK
//
//  Created by Guy Kogus on 8/01/12.
//  Copyright (c) 2012 Applicaster. All rights reserved.
//

#import <ZappPlugins/NSData+APAdditions.h>
#import <CommonCrypto/CommonDigest.h>
@import Foundation;

@implementation NSData (APAdditions)

/*
 Taken from Three20.
 */
- (nonnull NSString *)md5Hash {
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5([self bytes], (unsigned int)[self length], result);
	
	return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
			];
}

// Taken from https://stackoverflow.com/questions/3709204/sha256-in-objective-c-for-iphone
- (nullable NSString *)sha256Hash
{
	unsigned char hash[CC_SHA256_DIGEST_LENGTH];
	if (CC_SHA256([self bytes], (CC_LONG)[self length], hash))
	{
		NSData *sha2 = [NSData dataWithBytes:hash length:CC_SHA256_DIGEST_LENGTH];

		// description converts to hex but puts <> around it and spaces every 4 bytes
		NSString *hash = [sha2 description];
		hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
		hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
		hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];

		return hash;
	}
	return nil;
}

@end
