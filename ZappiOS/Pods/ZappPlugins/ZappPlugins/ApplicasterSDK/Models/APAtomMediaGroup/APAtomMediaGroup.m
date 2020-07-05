//
//  APAtomMediaGroup.m
//  applicaster
//
//  Created by Philip Kramarov on 11/22/14.
//  Copyright (c) 2014 Applicaster Ltd. All rights reserved.
//

#import "APAtomMediaGroup.h"

@implementation APAtomMediaGroup

- (NSString *)description {
    return [self.mediaItems description];
}

#pragma mark - Public

- (id)copy {
    NSData *archivedSelf = [NSKeyedArchiver archivedDataWithRootObject:self];
    id newCopy = [NSKeyedUnarchiver unarchiveObjectWithData:archivedSelf];
    return newCopy;
}

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        _mediaItems = [decoder decodeObjectForKey:@"mediaItems"];
        _type       = [[decoder decodeObjectForKey:@"type"] integerValue];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.mediaItems forKey:@"mediaItems"];
    [encoder encodeObject:@(self.type)    forKey:@"type"];
}

- (instancetype)initWithType:(APAtomMediaGroupType)type {
    self = [self init];

    if (self) {
        _type = type;
        _mediaItems = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)addMediaItemStringURL:(NSString *)stringURL
                          key:(NSString *)key {
    //key is <type-scale> in old method, <image_tag> if new method
    self.mediaItems[key] = stringURL;
}

+ (NSString *)stringURLFromMediaItems:(NSArray *)mediaGroups
                                  key:(NSString *)key {
    NSString *retVal = nil;
    for (APAtomMediaGroup *mediaGroup in mediaGroups) {
        NSString *stringURL = [mediaGroup mediaItemStringURLForKey:key];
        if (stringURL) {
            retVal = stringURL;
            break;
        }
    }
    
    return retVal;
}

- (NSString *)mediaItemStringURLForType:(APAtomMediaGroupType)type
                                  scale:(NSString *)scale {
    //key is <media-type> according to the APAtomMediaGroupType. f.e: "audio"

    NSString *typeString = nil;
    switch (type) {
        case APAtomMediaGroupTypeAudio:
            typeString = @"audio";
            break;
        case APAtomMediaGroupTypeImage:
            typeString = @"image";
            break;
        case APAtomMediaGroupTypeVideo:
            typeString = @"video";
            break;
    }
    return [self mediaItemStringURLForKey:typeString];
}

- (NSString *)mediaItemStringURLForKey:(NSString *)key {
    NSString *retVal = nil;

    if (key) {
        NSString *stringURL = self.mediaItems[key];
        if ([stringURL isKindOfClass:[NSString class]]) {
            retVal = stringURL;
        }
    }
    
    return retVal;
}

@end
