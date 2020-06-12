//
//  NSURL+APAddition.m
//  ApplicasterSDK
//
//  Created by Anton Kononenko on 9/11/15.
//  Copyright (c) 2015 Applicaster. All rights reserved.
//

#import <ZappPlugins/NSURL+APAddition.h>
#import <ZappPlugins/NSURLComponents+APAddition.h>

@implementation NSURL (APAddition)

- (NSArray *)valuesWithSamePrefixForParameterName:(NSString *)parameterName {
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:self.absoluteString];
    return [components arrayValuesWithSamePrefixForParameterName:parameterName];
}

- (NSString *)valueForParameterName:(NSString *)parameterName {
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:self.absoluteString];
    return [components valueForParameterName:parameterName];
}

- (NSDictionary *)queryDictionary {
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:self.absoluteString];
    return components.queryDictionary;
}

+ (NSURL*) urlEncodedQueryStringParameters:(NSString *)urlString {
    NSCharacterSet *allowedCharacters = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *urlEncodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:urlEncodedString];
    if (components.queryItems.count) {
        return [NSURL URLWithString:urlEncodedString];
    }
    else {
        //return original urldecoded url
        NSString *urlDecodedString = [urlString stringByRemovingPercentEncoding];
        return [NSURL URLWithString:urlDecodedString];
    }
}

+ (NSDictionary *)getJsonDictionaryWithUrl:(NSURL *)url
{
    NSDictionary *parameters = url.queryDictionary;

    NSMutableDictionary *fixedParams = [NSMutableDictionary new];
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL * __unused stop) {
        NSString *fixedKey = [[[key stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingOccurrencesOfString:@"%5B" withString:@"["] stringByReplacingOccurrencesOfString:@"%5D" withString:@"]"];
        NSString *fixedValue = [[[value stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingOccurrencesOfString:@"%5B" withString:@"["] stringByReplacingOccurrencesOfString:@"%5D" withString:@"]"];

        [fixedParams setValue:fixedValue
                       forKey:fixedKey];
    }];

    NSMutableDictionary *parameterArrays = [NSMutableDictionary dictionary];
    NSMutableArray *keyToRemove = [NSMutableArray new];

    NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionaryWithDictionary:fixedParams];
    [fixedParams enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL * __unused stop) {
        NSRange rangeOfOpenBracket = [key rangeOfString:@"["];
        NSRange rangeOfCloseBracket = [key rangeOfString:@"]"];

        if (rangeOfOpenBracket.location != NSNotFound && rangeOfCloseBracket.location != NSNotFound) {
            NSRange parameterRange;
            parameterRange.location = rangeOfOpenBracket.location + 1;
            parameterRange.length = rangeOfCloseBracket.location - rangeOfOpenBracket.location - 1;

            NSString *parameterName = [key substringWithRange:parameterRange];

            NSString *arrayName = [key substringToIndex:(parameterRange.location - 1)];

            if (![[parameterArrays allKeys] containsObject:arrayName])
            {
                NSMutableDictionary *localArray = [NSMutableDictionary dictionary];
                [parameterArrays setObject:localArray forKey:arrayName];
            }

            NSMutableDictionary *array = [parameterArrays objectForKey:arrayName];
            [array setObject:value forKey:parameterName];

            [keyToRemove addObject:key];
        }
    }];

    [resultDictionary removeObjectsForKeys:keyToRemove];

    for (NSString *parameterName in parameterArrays) {

        NSDictionary *parameterArray = [parameterArrays objectForKey:parameterName];

        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameterArray options:0 error:&error];

        if (!jsonData) {
            return nil;
        } else {
            NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [resultDictionary setValue:json forKey:parameterName];
        }

    }
    return resultDictionary;
}

@end
