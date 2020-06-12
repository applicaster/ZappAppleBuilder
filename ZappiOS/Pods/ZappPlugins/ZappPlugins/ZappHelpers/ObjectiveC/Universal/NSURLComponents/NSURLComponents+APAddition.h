//
//  NSURLComponents+APAddition.h
//  ApplicasterSDK
//
//  Created by reuven levitsky on 7/19/15.
//  Copyright (c) 2015 Applicaster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLComponents (APAddition)

/**
 * Be careful when looking for parameters better use (valueForParameterName:) method, it looks for them case insensitive unlike reaching
 * them directly from the dictionary.
 *
 * This property is used for getting and setting the query items from a NSURLComponents object.
 * The key and the values are NSString.
 *
 * When set is called (stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]) is called both 
 * on the key and value of each entry of the dictionary.
 * When get is called the key and value are retrieved without escapes.
 */
@property (nonnull, nonatomic, strong) NSDictionary<NSString *,NSString *> *queryDictionary;


/**
  Return array of parameter values from url matching the same prefix

 *  @param parameterName Paremeter name that should be removed.
 *  @return the Array of the values the given parameter prefix or nil if not found.
 */
- (nullable NSArray *)arrayValuesWithSamePrefixForParameterName:(nullable NSString *)parameterName;

/**
 *  Return parameter value from url matching the given name
 *
 *  @param parameterName Paremeter name that should be removed.
 *  @return the value of the given parameter or nil if not found.
 */
- (nullable NSString *)valueForParameterName:(nullable NSString *)parameterName;

/**
 *  Remove parameter from url
 *
 *  @param parameterName Paremeter name that should be removed
 *  @return BOOL value if parameter was removed return YES other case NO 
 */
- (BOOL)removeParameter:(nullable NSString *)parameterName;

@end
