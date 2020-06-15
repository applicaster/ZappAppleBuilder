//
//  APAtomMediaGroup.h
//  applicaster
//
//  Created by Philip Kramarov on 11/22/14.
//  Copyright (c) 2014 Applicaster Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, APAtomMediaGroupType) {
    APAtomMediaGroupTypeAudio = 1,
    APAtomMediaGroupTypeImage = 2,
    APAtomMediaGroupTypeVideo = 3
};

@interface APAtomMediaGroup : NSObject <NSCoding>

@property (nonatomic, assign, readonly) APAtomMediaGroupType type;
@property (nonatomic, strong, readonly) NSMutableDictionary *mediaItems;


/**
 init the media group with it's type (image/video)
 and with an empty list of media items
 */
- (instancetype)initWithType:(APAtomMediaGroupType)type;

- (void)addMediaItemStringURL:(NSString *)stringURL
                          key:(NSString *)key;

- (NSString *)mediaItemStringURLForType:(APAtomMediaGroupType)type
                                  scale:(NSString *)scale;

+ (NSString *)stringURLFromMediaItems:(NSArray *)mediaGroups
                                  key:(NSString *)key;

- (NSString *)mediaItemStringURLForKey:(NSString *)key;
@end
