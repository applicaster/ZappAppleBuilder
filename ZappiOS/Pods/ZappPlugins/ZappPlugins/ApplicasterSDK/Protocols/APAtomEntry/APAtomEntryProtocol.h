//
//  APAtomEntryProtocol.h
//  ApplicasterSDK
//
//  Created by Anton Kononenko on 02/04/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APAtomMediaGroup.h"

/*
 Type of entry
 */
typedef NS_ENUM(NSUInteger, APEntryType) {
    APEntryTypeUnknown,
    APEntryTypeArticle,
    APEntryTypeVideo,
    APEntryTypeImage,
    APEntryTypeImageGallery,
    APEntryTypeAudio,
    APEntryTypeLink,
    APEntryTypePlaylist,
    APEntryTypeFeed,
    APEntryTypeProgram,
    APEntryTypeChannel,
    APEntryTypeApplicasterFeed,
    APEntryTypeApplicasterCrossmates,
    APEntryTypeApplicasterLiveDrawer,
    APEntryTypeChromecast,
    APEntryTypeHeader
};

@class ZPContent;
@protocol  APAtomEntryProtocol <NSObject>

@required
/**
 Object - Raw object of Pipes Parser
 */
@property (nonatomic, strong) NSDictionary *pipesObject;

/**
 EntryType - item type.
 */
@property (nonatomic, assign) APEntryType entryType;

///**
// ParentFeed - parent object that stores this entry
// */
@property (nonatomic, weak) id <APAtomEntryProtocol>parentFeed;

/**
 Screen Type
 */
@property (nonatomic, strong) NSString *screenType;

/**
 Category Name
 */
@property (nonatomic, strong) NSString *category;

/**
Atom Extensions
 */
@property (nonatomic, strong) NSDictionary *extensions;

/**
 Title - item title.
 */
@property (nonatomic, strong) NSString *title;

/**
 SubTitle - item subTitle.
 */
@property (nonatomic, strong) NSString *subTitle;

/**
 Summary - description of item.
 */
@property (nonatomic, strong) NSString *summary;

/**
 Author - author that posted
 */
@property (nonatomic, strong) NSString *author;

/**
 Link - link of the entry
 */
@property (nonatomic, strong) NSString *link;

/**
 Identifier - item identifier.
 */
@property (nonatomic, strong) NSString *identifier;

/**
 PublishDate - date the item was published.
 */
@property (nonatomic, strong) NSString *publishDate;

/**
 UpdateDate - date the item was updated if available.
 */
@property (nonatomic, strong) NSString *updateDate;

/**
 Content - more detailed content (if available).
 */
@property (nonatomic, strong) ZPContent *content;

/**
 Content - MediaGroup - element groups media assets from the same type.
 */
@property (nonatomic, strong) NSMutableArray *mediaGroups;

/**
 Content - MediaGroup - element groups media assets from the same type.
 */
@property (nonatomic, strong) NSMutableDictionary *advertisements;

@optional
/**
 Returns a string URL of the first media group with small scale.
 @param name of the image from the image dictionary. (Name is ignored at the moment)
 @return image string URL
 */
- (NSString *)imageNamed:(NSString*)name;

/**
 Returns a string URL of the first media group with expected scale.
 @param name imageTag
 @param scale scale
 @return image string URL
 */
- (NSString *)imageNamed:(NSString*)name
                   scale:(NSString *)scale;
@end

