//
//  AVPlayerItem+APAdditions.m
//  ApplicasterSDK
//
//  Created by Tom Susel on 1/22/12.
//  Copyright (c) 2012 Applicaster. All rights reserved.
//

#import "AVPlayerItem+APAdditions.h"

@implementation AVPlayerItem (APAdditions)

- (BOOL)hasVideoTracks{
    //Default answer is NO
    BOOL hasVideoTracks = NO;
    
    //Go over the tracks
    for (AVPlayerItemTrack* track in [self tracks]){
        
        //Look for video media tipe
        if ([track.assetTrack.mediaType isEqual:AVMediaTypeVideo]){
            hasVideoTracks = YES;
            
            //Video track found, no need to continue enumeration
            break;
        }
    }
    
    return hasVideoTracks;
}

@end
