//
//  NSFileManager+APAdditions.h
//  ApplicasterSDK
//
//  Created by Liviu Romascanu on 2/8/12.
//  Copyright (c) 2012 Applicaster. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/xattr.h>

@interface NSFileManager (APAdditions)

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

@end
