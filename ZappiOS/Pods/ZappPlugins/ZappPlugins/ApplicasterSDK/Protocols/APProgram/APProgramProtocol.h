//
//  APProgramProtocol.h
//  ApplicasterSDK
//
//  Created by Anton Kononenko on 06/06/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZPCategoryProtocol;

@protocol APProgramProtocol <NSObject>
@property (nonatomic, weak) NSString *localNotificationSound;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *programDescription;
@property (nonatomic, strong, readonly) NSString *liveImageURL;
@property (nonatomic, strong, readonly) NSString *thumbURL;
@property (nonatomic, strong, readonly) NSString *imageURL;
@property (nonatomic, strong, readonly) NSString *mediumURL;
@property (nonatomic, strong, readonly) NSString *originalURL;
@property (nonatomic, strong, readonly) NSString *sequenceId;
@property (nonatomic, strong, readonly) NSString *channelId;
@property (nonatomic, strong, readonly) NSString *vodItemId;
@property (nonatomic, strong, readonly) NSString *identifier;


@property (nonatomic, strong, readonly) NSObject<ZPCategoryProtocol> *showCategory;

@property (nonatomic, strong, readonly) NSDate *startsAt;
@property (nonatomic, strong, readonly) NSDate *endsAt;
@property (nonatomic, readonly) BOOL isLive;

@property (nonatomic, strong, readonly) NSString *color;

/**
 Checks if the program has a reminder scheduled.
 */
@property (nonatomic, readonly, getter = isLocalNotificationScheduled) BOOL localNotificationScheduled;


/**
 This method checks if the program's start date is before now and the end date is after now.
 @return YES if the program is currently playing.
 */
- (BOOL)isPlaying;

/**
 This method checks if the program's end date is after now.
 @return YES if the program is already ended.
 */
- (BOOL)didEnd;

/**
 This method adds a local notification to the program which should take place in the future.
 In order use localization in the alert fields (alert body and the action button) use the following keys:
 APProgramLocalNotificationAlertBody - localization for the alert body.
 APProgramLocalNotificationAlertAction - localization for the action button.
 */
- (void)addLocalNotification;

/**
 This method removes the local notification from the program, if the program has a scheduled reminder.
 */
- (void)removeLocalNotification;


@end
