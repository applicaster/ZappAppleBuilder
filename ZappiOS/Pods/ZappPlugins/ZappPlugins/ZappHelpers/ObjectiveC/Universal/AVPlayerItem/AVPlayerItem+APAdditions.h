//
//  AVPlayerItem+APAdditions.h
//  ApplicasterSDK
//
//  Created by Tom Susel on 1/22/12.
//  Copyright (c) 2012 Applicaster. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVPlayerItem (APAdditions)

/**
 Checks for video tracks.
 @returns YES when the item has video tracks in it's tracks array, NO otherwise.
 */
- (BOOL)hasVideoTracks;

@end
