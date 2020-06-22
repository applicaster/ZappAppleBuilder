//
//  NSString+InflectionSupport.h
//  ZappPlugins
//
//  Created by Alex Zchut on 03/07/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A helper class for playing with NSString objects.
 */
@interface NSString (InflectionSupport)

/**
 * Return the dashed form af this camelCase string:
 *
 *   [@"camelCase" dasherize] //> @"camel-case"
 */
- (NSString *)dasherize;

/**
 * Return the underscored form af this camelCase string:
 *
 *   [@"camelCase" underscore] //> @"camel_case"
 */
- (NSString *)underscore;

/**
 * Return the camelCase form af this dashed/underscored string:
 *
 *   [@"camel-case_string" camelize] //> @"camelCaseString"
 */
- (NSString *)camelize;

/**
 * Return a copy of the string suitable for displaying in a title. Each word is downcased, with the first letter upcased.
 */
- (NSString *)titleize;

/**
 * Return a copy of the string with the first letter capitalized.
 */
- (NSString *)toClassName;

@end
