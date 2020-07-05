//
//  ZAAppDelegateConnectorChromecastProtocol.h
//  ZappAppConnector
//
//  Created by Avi Levin on 21/12/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//

/**
 * This protocol is used to connect between applicasterSDK and Zapp-iOS
 * All the Chromecast logic is located in the app level.
 */
NS_ASSUME_NONNULL_BEGIN

@protocol ZAAppDelegateConnectorChromecastProtocol

- (BOOL)isSynced;
- (BOOL)isReachableViaWiFi;
- (void)play:(nonnull NSArray *)playableItems currentPosition:(long)position;
- (void)showExtendedPlayer;
- (nonnull UIViewController *)getExtendedPlayerViewController;
- (nonnull UIViewController *)getInlinePlayerViewController;
- (nullable UIViewController *)getMiniPlayerViewController;
- (void)setNotificationsDelegate:(nonnull id)notificationsDelegate;
- (BOOL)canShowPlayerBeforeCastSync;

- (UIInterfaceOrientationMask)extendedPlayerOrientation;

/** chromecast button
 * container - the button will go inside this container view
 * topOffset - used only for template app
 * width - the size of the button
 * buttonKey - we use this key for two things: 1. events 2. retrieve the color from Zapp if UIColor won't set below
 * color - if not set we'll check for the button key color in Zapp. the default color is white.
 * useConstraints - some containers require the use of constraints while others use match parent
 */
- (nullable UIView *)addButton:(nullable UIView *)container topOffset:(NSInteger)topOffset width:(CGFloat)width buttonKey:(NSString *)buttonKey color:(nullable UIColor *)color useConstrains:(BOOL)useConstrains;

@end

NS_ASSUME_NONNULL_END
