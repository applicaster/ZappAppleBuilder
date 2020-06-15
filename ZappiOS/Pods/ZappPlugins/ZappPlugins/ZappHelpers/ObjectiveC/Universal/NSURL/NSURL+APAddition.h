//
//  NSURL+APAddition.h
//  ApplicasterSDK
//
//  Created by Anton Kononenko on 9/11/15.
//  Copyright (c) 2015 Applicaster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (APAddition)


/**
 *  Return Array of parameters values from url matching the prefix of the parameter

 @param parameterName Paremeter name that should be removed.
 *  @return Arrays of values of the given parameter prefixea or nil if not found.
 */
- (NSArray *)valuesWithSamePrefixForParameterName:(NSString *)parameterName;

/**
 *  Return parameter value from url matching the given name
 *
 *  @param parameterName Paremeter name that should be removed.
 *  @return the value of the given parameter or nil if not found.
 */
- (NSString *)valueForParameterName:(NSString *)parameterName;

/**
 * Be careful when looking for parameters better use (valueForParameter:) method, it looks for them case insensitive unlike reaching
 * them directly from the dictionary.
 
 * A new dictionary of params for current url
 */
- (NSDictionary *)queryDictionary;

/**
 *  Return url with urlEncoded Query String params
 *
 *  @param urlString urlString.
 *  @return the url.
 */
+ (NSURL*) urlEncodedQueryStringParameters:(NSString *)urlString;

/**
 *  Return json dictionary from url query string parameters
 *
 *  @param url as url.
 *  @return the dictionary.
 */
+ (NSDictionary *)getJsonDictionaryWithUrl:(NSURL *)url;
@end
