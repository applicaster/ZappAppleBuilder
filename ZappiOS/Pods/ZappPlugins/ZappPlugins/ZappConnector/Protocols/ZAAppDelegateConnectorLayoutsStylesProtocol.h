//
//  ZAAppDelegatelConnectorLayoutsStylesProtocol.h
//  ZappAppConnector
//
//  Created by Alex Zchut on 02/07/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//

@import UIKit;

static NSString *const kZappLayoutStylesFontKey = @"kZappLayoutStylesFontKey";
static NSString *const kZappLayoutStylesBackgroundColorKey = @"kZappLayoutStylesBackgroundColorKey";
static NSString *const kZappLayoutStylesBackgroundImageKey = @"kZappLayoutStylesBackgroundImageKey";
static NSString *const kZappLayoutStylesLocalizationKey = @"kZappLayoutStylesLocalizationKey";

@protocol ZAAppDelegateConnectorLayoutsStylesProtocol

- (NSBundle *)stylesBundle;
- (NSBundle *)zappLayoutsStylesBundle;
- (NSDictionary *)zappLayoutsStylesMappingDict;
- (BOOL)isZappLayoutsEnabled;
- (Class)zappLayoutViewController;

/**
 Retrieve status bar from features customization plist
 
 @return Expected default status bar style for application
 */
- (UIStatusBarStyle)defaultStatusBarStyle;


@optional
/**
 Retrieve style parameters by style name
 
 @return dictionary of color, font
 */
- (NSDictionary*) styleParamsByStyleName:(NSString*)styleName;

- (void)setViewStyle:(UIView *)view withKeys:(NSDictionary *)keys;
- (void)setLabelStyle:(UILabel *)label withKeys:(NSDictionary *)keys;
- (void)setButtonStyle:(UIButton *)button withKeys:(NSDictionary *)keys;

/**
 Returns the UIInterfaceOrientationMask for the initial orientation as defined in the GAFeatureCustomization
 */
- (UIInterfaceOrientationMask)initialOrientation;

/**
 Return color for key
*/
- (CGFloat) styleDimensionForKey:(NSString *)key;
- (UIColor *) styleColorForKey:(NSString *)key;
@end

