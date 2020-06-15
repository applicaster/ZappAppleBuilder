//
//  NSObject+APAdditions.m
//  ApplicasterSDK
//
//  Created by Tom Susel on 1/4/12.
//  Copyright (c) 2012 Applicaster. All rights reserved.
//

#import <ZappPlugins/NSDictionary+APAdditions.h>

@implementation NSDictionary (APAdditions)

- (id)objectForKeyCaseInsensitive:(id)aKey {
    __block NSObject *returnObject = nil;

    if([aKey isKindOfClass:[NSString class]]){
        [self enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop){
            if([key isKindOfClass:[NSString class]] && [(NSString *)aKey caseInsensitiveCompare:key] == NSOrderedSame){
                returnObject = self[key];
                 *stop = YES;
            }
        }];
    }
    
    return returnObject;
}

- (NSArray *)objectsArrayForKeysWithSamePrefix:(id)aKey {
    NSMutableArray *valuesArray = [NSMutableArray new];

    if([aKey isKindOfClass:[NSString class]]){
        [self enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop){
            if([key isKindOfClass:[NSString class]] && [[key lowercaseString] hasPrefix:aKey]) {
                [valuesArray addObject:self[key]];
            }
        }];
    }
    
    return valuesArray.count > 0 ? valuesArray : nil;
}

+ (NSDictionary *)dictionaryByMerging:(NSDictionary *)src with:(NSDictionary *)otherDict
{
    NSMutableDictionary *result = [src mutableCopy];
    [otherDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSDictionary class]]
            && [src[key] isKindOfClass:[NSDictionary class]]) {
            
            result[key] = [src[key] dictionaryByMergingWith:obj];
        } else {
            result[key] = obj;
        }
    }];
    return [NSDictionary dictionaryWithDictionary:result];
}

- (NSDictionary *)dictionaryByMergingWith:(NSDictionary *)dict {
    return [[self class] dictionaryByMerging:self with:dict];
}

- (NSUInteger)hash {
    NSUInteger prime = 31;
    NSUInteger result = 1;
    
    NSArray *sortedKeys = [self.allKeys sortedArrayUsingSelector: @selector(compare:)];
    for (NSObject *key in sortedKeys) {
        result = prime * result + key.hash;
        id value = self[key];
        if ([value conformsToProtocol: @protocol(NSObject)] == YES) {
            result = prime * result + [value hash];
        }
    }
    
    return result;
}

@end
