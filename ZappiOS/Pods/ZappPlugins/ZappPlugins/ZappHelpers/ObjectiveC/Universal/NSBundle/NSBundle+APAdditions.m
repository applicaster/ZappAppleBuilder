//
//  NSBundle+APAdditions.m
//  ApplicasterSDK
//
//  Created by Tom Susel on 2/7/12.
//  Copyright (c) 2012 Applicaster. All rights reserved.
//

#import <ZappPlugins/NSBundle+APAdditions.h>

@implementation NSBundle (APAdditions)

- (NSArray *)urlSchemes {
	NSMutableArray *urlSchemesM = [NSMutableArray array];
	
	for (NSDictionary *urlType in [[self infoDictionary] objectForKey:@"CFBundleURLTypes"]) {
		NSArray *urlSchemes = [urlType objectForKey:@"CFBundleURLSchemes"];
		[urlSchemesM addObjectsFromArray:urlSchemes];
	}
	
	return [NSArray arrayWithArray:urlSchemesM];
}

@end
