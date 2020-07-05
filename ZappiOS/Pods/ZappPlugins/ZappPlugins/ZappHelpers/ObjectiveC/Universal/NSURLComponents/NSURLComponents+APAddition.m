//
//  NSURLComponents+APAddition.m
//  ApplicasterSDK
//
//  Created by reuven levitsky on 7/19/15.
//  Copyright (c) 2015 Applicaster. All rights reserved.
//

#import <ZappPlugins/NSURLComponents+APAddition.h>
#import <ZappPlugins/NSDictionary+APAdditions.h>
#import <ZappPlugins/NSObject+APAdditions.h>

@implementation NSURLComponents (APAddition)

- (void)setQueryDictionary:(nonnull NSDictionary<NSString *,NSString *> *)queryDictionary {
    NSMutableArray *queryItems = [NSMutableArray arrayWithCapacity:queryDictionary.allKeys.count];
    [queryDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSString *value, BOOL *stop) {
        NSURLQueryItem *queryItem = [[NSURLQueryItem alloc] initWithName:name
                                                                   value:value];
        [queryItems addObject:queryItem];
    }];
    self.queryItems = queryItems;
}

- (nullable NSArray *)arrayValuesWithSamePrefixForParameterName:(nullable NSString *)parameterName {
    return [self.queryDictionary objectsArrayForKeysWithSamePrefix:parameterName];
}

- (nonnull NSDictionary<NSString *,NSString *> *)queryDictionary {
    NSMutableDictionary *queryDictionary = [NSMutableDictionary new];
    
    for (NSURLQueryItem *queryItem in self.queryItems) {
        if([queryItem.name isNotEmpty]){
            [queryDictionary setValue:queryItem.value
                               forKey:queryItem.name];
        }
    }
    
    return queryDictionary;
}

- (nullable NSString *)valueForParameterName:(nullable NSString *)parameterName {
    return [self.queryDictionary objectForKeyCaseInsensitive:parameterName];
}

- (BOOL)removeParameter:(nullable NSString *)parameterName {
    BOOL retVal = NO;
    NSMutableDictionary *queryDictionary = [self.queryDictionary mutableCopy];
    [queryDictionary removeObjectForKey:parameterName];
    if (self.queryDictionary.count > queryDictionary.count) {
        retVal = YES;
    }
    self.queryDictionary = [queryDictionary copy];
    return retVal;
}

@end
