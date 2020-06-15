//
//  NSBundle+APAdditions.h
//  ApplicasterSDK
//
//  Created by Tom Susel on 2/7/12.
//  Copyright (c) 2012 Applicaster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (APAdditions)

/**
 Retrieve the the bundle's info.plist the URL schemes used by the application.
 @return An array with all of the URL schemes used for opening this application remotely.
 */
- (NSArray *)urlSchemes;

@end
