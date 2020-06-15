//
//  NSFileManager+APAdditions.m
//  ApplicasterSDK
//
//  Created by Liviu Romascanu on 2/8/12.
//  Copyright (c) 2012 Applicaster. All rights reserved.
//

#import <ZappPlugins/NSFileManager+APAdditions.h>


@implementation NSFileManager (APAdditions)

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

@end
