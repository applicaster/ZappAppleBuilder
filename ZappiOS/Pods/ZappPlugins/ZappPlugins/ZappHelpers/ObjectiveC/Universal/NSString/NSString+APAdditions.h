//
//  NSString+APAdditions.h
//  ApplicasterSDK
//
//  Created by Guy Kogus on 8/01/12.
//  Copyright (c) 2012 Applicaster. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Additions taken from Three20.
 */
@interface NSString (APAdditions)

/**
 * Determines if the string contains only whitespace and newlines.
 */
- (BOOL)isWhitespaceAndNewlines;

/**
 * Determines if the string is empty or contains only whitespace.
 *
 * @deprecated - Use isNotEmptyOrWhiteSpaces instead.
 */
- (BOOL)isEmptyOrWhitespace __attribute__((deprecated));

/**
 * Determines if the string contains characters other than whitespaces.
 */
- (BOOL)isNotEmptyOrWhiteSpaces;

/**
 * Parses a URL query string into a dictionary.
 * @param encoding The required string encoding.
 * @return The query dictionary.
 * @deprecated - Use queryDictionaryWithEncoding instead.
 */
- (NSDictionary*)queryDictionaryUsingEncoding:(NSStringEncoding)encoding __attribute__((deprecated));

/**
 * Parses a URL query string into a dictionary.
 * @return The query dictionary.
 */
- (NSDictionary*)queryDictionary;

/**
 * Parses a string, adds query parameters to its query, and re-encodes it as a new string.
 * @param query The query dictionary.
 * @return The new string with the queries appended.
 */
- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query;

/**
 * Appends the Right to Left Mark character to the begining of the text. It makes the text be RTL even if the original text started with English letters.
 * @return The new string with the Right to Left Mark character appended to the begining of the text.
 */
- (NSString*)rtlString;

/**
 * Calculate the md5 hash of this string using CC_MD5.
 *
 * @return md5 hash of this string
 */
- (NSString*)md5Hash;

/**
 Encrypt the receiver using AES128 ECB PKCS7 and encode in Base64.
 @param key The key used for the encrytion.
 @return The encrypted form of the receiving string.
 */
- (NSString *)encryptTextToAES128WithKey:(NSString *)key;

/**
 Decode the receiver from base 64 and decrypt using AES128 ECB PKCS7.
 @param key The key used for the encrytion.
 @return The decrypted form of the receiving base 64 string.
 */
- (NSString *)decryptFromAES128WithKey:(NSString *)key;

/**
 Return a reversed version of the string.
 @return The string in reverse.
 */
- (NSString *)reversed;

/**
 Returns a string that is used for analytics.
 @return string after all ' ' were changed to '-', no accents and special characters. 
 */
- (NSString *)analyticsString;

/**
 Capitlize first letters in each sentence.
 @return capitlized sentence
 */
- (NSString *)stringByCapitalizingSentence;

/**
 This method uses a regular expression pattern to find a value within the receiver.
 the value is found using case Insensitive Comparison
 @param index The index of the capture range in the given pattern.
 @param pattern The regular expression pattern to search in the string.
 @return The value of the captured range.
 */
- (NSString *)valueAtRangeIndex:(NSUInteger)index ofRegExPattern:(NSString *)pattern;

/**
 Returns the human readable time string from time interval using self as seconds string
 @return time 00:00:00 or 00:00 format
 */
- (NSString*)timeCodeWithSeconds;

/**
 Returns the human readable time string from time interval
 @param timeInterval - seconds
 @return time 00:00:00 or 00:00 format
 */
+ (NSString*)timeCodeWithSeconds:(NSTimeInterval) timeInterval;

/**
 Return YES if current string contains subString
 @param subString - string for test
 @return YES if current string contains subString
 */
- (BOOL)doesStringContainString:(NSString *)subString;

/**
 Return Trimmed string
 @return trimmed string
 */
- (NSString*) trim;

/**
 Returns object from string
 */
- (NSObject *) jsonStringToObject;

@end
