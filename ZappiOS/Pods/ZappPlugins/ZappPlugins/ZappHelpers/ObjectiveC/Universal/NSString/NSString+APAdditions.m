//
//  NSString+APAdditions.m
//  ApplicasterSDK
//
//  Created by Guy Kogus on 8/01/12.
//  Copyright (c) 2012 Applicaster. All rights reserved.
//

#import <ZappPlugins/NSString+APAdditions.h>
#import <ZappPlugins/NSData+APAdditions.h>

#import <CommonCrypto/CommonCrypto.h>

/*
 Taken from Three20.
 */

@implementation NSString (APAdditions)

#define IS_NOT_NULL(val) (val && ((NSNull*)val != [NSNull null]))

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isWhitespaceAndNewlines {
	NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	for (NSInteger i = 0; i < self.length; ++i) {
		unichar c = [self characterAtIndex:i];
		if (![whitespace characterIsMember:c]) {
			return NO;
		}
	}
	return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)isEmptyOrWhitespace {
	return !self.length ||
	![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
}

- (BOOL)isNotEmptyOrWhiteSpaces
{
    return (IS_NOT_NULL(self)
            && [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// Copied and pasted from http://www.mail-archive.com/cocoa-dev@lists.apple.com/msg28175.html

- (NSDictionary*)queryDictionaryUsingEncoding:(NSStringEncoding)encoding {
    return [self queryDictionary];
}

- (NSDictionary*)queryDictionary {
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:self];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSRange position = [pairString rangeOfString:@"="];
        if (position.location != NSNotFound) {
            NSString* key = [[pairString substringToIndex:position.location] stringByRemovingPercentEncoding];
            NSString *valueWithoutEncoding = [pairString substringFromIndex:position.location + position.length];
            NSString* value = [valueWithoutEncoding stringByRemovingPercentEncoding];
            [pairs setObject:(value)?value:valueWithoutEncoding forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query {
	NSMutableArray* pairs = [NSMutableArray array];
	for (NSString* key in [query keyEnumerator]) {
		NSString* value = [query objectForKey:key];
		value = [value stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
		value = [value stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
		NSString* pair = [NSString stringWithFormat:@"%@=%@", key, value];
		[pairs addObject:pair];
	}
	
	NSString* params = [pairs componentsJoinedByString:@"&"];
	if ([self rangeOfString:@"?"].location == NSNotFound) {
		return [self stringByAppendingFormat:@"?%@", params];
	} else {
		return [self stringByAppendingFormat:@"&%@", params];
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)rtlString{
    return [NSString stringWithFormat:@"\u200F%@", self];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)md5Hash {
	return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
}

- (NSString *)encryptTextToAES128WithKey:(NSString *)key
{
	NSData *decodedData = [self dataUsingEncoding:NSUTF8StringEncoding];
	char keyPtr[kCCKeySizeAES128 + 1];
	bzero(keyPtr, sizeof(keyPtr));
	[key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
	char ivPtr[kCCBlockSizeAES128 + 1];
	bzero(ivPtr, sizeof(ivPtr));
	NSUInteger dataLength = [decodedData length];
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	size_t numBytesEncrypted = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
										  kCCAlgorithmAES128,
										  kCCOptionPKCS7Padding | kCCOptionECBMode,
										  keyPtr,
										  kCCBlockSizeAES128,
										  ivPtr,
										  [decodedData bytes],
										  dataLength,
										  buffer,
										  bufferSize,
										  &numBytesEncrypted);
	if (cryptStatus == kCCSuccess)
	{
		NSData *encodedData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
		NSString *encodedString = [encodedData base64EncodedStringWithOptions:0];
		return encodedString;
	}
	free(buffer);
	return nil;
}

- (NSString *)decryptFromAES128WithKey:(NSString *)key
{
	NSData *encodedData = [[NSData alloc] initWithBase64EncodedString:self options:0];
	char keyPtr[kCCKeySizeAES128 + 1];
	bzero(keyPtr, sizeof(keyPtr));
	[key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
	char ivPtr[kCCBlockSizeAES128 + 1];
	bzero(ivPtr, sizeof(ivPtr));
	NSUInteger dataLength = [encodedData length];
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	size_t numBytesEncrypted = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
										  kCCAlgorithmAES128,
										  kCCOptionPKCS7Padding | kCCOptionECBMode,
										  keyPtr,
										  kCCBlockSizeAES128,
										  ivPtr,
										  [encodedData bytes],
										  dataLength,
										  buffer,
										  bufferSize,
										  &numBytesEncrypted);
	if (cryptStatus == kCCSuccess)
	{
		NSData *decodedData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
		NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
		return decodedString;
	}
	free(buffer);
	return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)reversed {
	NSMutableString *reversedStr;
	NSUInteger len = [self length];
	
	// Auto released string
	reversedStr = [NSMutableString stringWithCapacity:len];
	
	do {
		[reversedStr appendString:
		 [NSString stringWithFormat:@"%C", [self characterAtIndex:--len]]];
	} while (len != 0);
	
	return [NSString stringWithFormat:@"%@", reversedStr];
}

- (NSString *)analyticsString
{
	NSString *analyticsString = [[[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    
	// Remove all accents and diacritics.
	CFMutableStringRef analyticsStringM = CFStringCreateMutableCopy(NULL, [analyticsString length], (__bridge CFStringRef)analyticsString);
	CFStringTransform(analyticsStringM, NULL, kCFStringTransformStripCombiningMarks, NO);
	analyticsString = (NSString *)CFBridgingRelease(analyticsStringM);
    
    
    
    NSMutableCharacterSet *allowedChars = [NSMutableCharacterSet alphanumericCharacterSet];
    [allowedChars addCharactersInString:@"-."];
    NSCharacterSet * notAllowedChars = [allowedChars invertedSet];
    analyticsString = [[analyticsString componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
	
	return analyticsString;
}

- (NSString *)stringByCapitalizingSentence
{
    if (self.length == 0) {
        return self;
    }
    
    NSString *result = self;
    
    NSArray *delimiters = @[@". ", @"? ", @"; ", @"! "];
    for (NSString *delimiter in delimiters) {
        NSMutableArray *capitalizedSentences = [NSMutableArray new];
        NSArray *sentences = [result componentsSeparatedByString:delimiter];
        for (NSString *sentence in sentences) {
            NSString *capitlizedSentence = sentence;
            if (sentence.length > 0) {
                capitlizedSentence = [sentence stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                                 withString:[[sentence substringToIndex:1] capitalizedString]];
            }
            [capitalizedSentences addObject:capitlizedSentence];
        }
        
        result = [capitalizedSentences componentsJoinedByString:delimiter];
    }
    
    return result;
}

- (NSString *)valueAtRangeIndex:(NSUInteger)index ofRegExPattern:(NSString *)pattern
{
	NSString *value = nil;
	
	NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern
																				options:NSRegularExpressionCaseInsensitive
																				  error:NULL];
	NSTextCheckingResult *result = [expression firstMatchInString:self
														  options:0
															range:NSMakeRange(0, [self length])];
	
	value = [self substringWithRange:[result rangeAtIndex:index]];
	
	return value;
}

- (NSString*)timeCodeWithSeconds {
    NSTimeInterval timeInterval = [self floatValue];
    return [NSString timeCodeWithSeconds:timeInterval];
}

/**
 Returns the human readable time string from time interval
 @param timeInterval - seconds
 @return time 00:00:00 or 00:00 format
 */
+ (NSString*)timeCodeWithSeconds:(NSTimeInterval) timeInterval {
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    //get base date with our time
    NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSCalendar *calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:timeZone];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:tempDate];
    //get hours from date components for temp date
    NSInteger hours = [components hour];
    
    //create new time formatter
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setTimeZone:timeZone];
    
    if (hours > 0){
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    }
    else {
        [dateFormatter setDateFormat:@"mm:ss"];
    }
    
    return [dateFormatter stringFromDate:tempDate];
}

- (BOOL)doesStringContainString:(NSString *)subString {
    if ([self rangeOfString:subString].location != NSNotFound) {
        return YES;
    }
    
    return NO;
}

- (NSString*) trim {
    return [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];

}

- (NSObject *) jsonStringToObject {
    NSError *error;
    if ([self isNotEmptyOrWhiteSpaces]) {
        NSData *objectData = [self dataUsingEncoding:NSUTF8StringEncoding];
        NSObject *json = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:&error];
        return (!json ? nil : json);
    }
    else {
        return nil;
    }
}

@end
