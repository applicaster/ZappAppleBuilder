//
//  APURLPlayableProtocol.h
//  ZappPlugins
//
//  Created by Pablo Rueda on 11/12/2019.
//

/**
 APURLPlayableProtocol represents a model containing a URL to be played.
 */
@import Foundation;
@protocol ZPPlayable;

@protocol APURLPlayableProtocol <ZPPlayable>

#pragma mark - Init

- (instancetype)initWithStreamURL:(NSString *)streamURL
                             name:(NSString *)name
                      description:(NSString *)description;

#pragma mark - Updates
- (void)updateStreamUrl:(NSString *)streamURL;

#pragma mark - Play methods

/**
 Plays this item using the new player.
 showing the the new player with animated presentation
 */
- (void)play;

/**
 Plays this item using the new player.
 showing the the new player with animated presentation
 @param startTime - NSTimeInterval in seconds for start time
 @param endTime - NSTimeInterval in seconds for end time
 */
- (void)playFromStartTime:(NSTimeInterval)startTime toEndTime:(NSTimeInterval)endTime;

/**
 Plays this item using the new player.
 showing the the new player with animated or non animated presentation
 @param animated Present the new player animated or not animated
 */
- (void)playAnimated:(BOOL)animated;

/**
 You can call this method in order to declare this playable is live or not. That results in different UI experience in the players usually (Duration, progressbar).
 Default is NO (not Live = VOD).
 */
@property (nonatomic, assign) BOOL isLive;
@property (nonatomic, assign) BOOL isPlaylist;
@property (nonatomic, assign) BOOL isFree;

/**
 This corresponds to APAtomEntry's identifier
 */
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *playerExternalIdentifier;

/**
 This corresponds to APAtomEntry's extensions
 */
@property (nonatomic, strong) NSDictionary *extensionsDictionary;

@end
