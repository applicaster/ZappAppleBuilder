//
//  CAGenericViewControllerProtocol.h
//  ZappPlugins
//
//  Created by Anton Kononenko on 27/11/2016.
//  Copyright © 2016 Applicaster LTD. All rights reserved.
//

@import Foundation;
@class ZLScreenModel;
@class ZPPluginModel;

@protocol CAGenericViewControllerProtocol <NSObject>

@required
@property (nonatomic, assign) BOOL isContainerViewController;

/**
 return an initialize instance of genericViewController or nil
 @param screenName - the name of the screen for searching the screen definition.
 @return genericViewController with screen definition or nil if screen name don't match any screen definitions
 */
+ (instancetype)genericWithScreenName:(NSString *)screenName;

/**
 return an initialize instance of genericViewController or nil
 @param screenName - the name of the screen for searching the screen definition.
 @return genericViewController with screen definition or nil if screen name don't match any screen definitions
 */
+ (instancetype)genericWithScreenName:(NSString *)screenName
                               bundle:(NSBundle *)bundle;

@optional

/**
 Return an initialize instance of genericViewController or nil


 @param screenName - the name of the screen for searching the screen definition.
 @param dataSourceModel - data sorce of the screen
 @return genericViewController with screen definition or nil if screen name don't match any screen definitions
 */
+ (instancetype)genericWithScreenName:(NSString *)screenName
                      dataSourceModel:(NSObject *)dataSourceModel;

/**
 return an initialize instance of genericViewController or nil


 return an initialize instance of genericViewController or nil
 @param screenName - the name of the screen for searching the screen definition.
 @param urlScheme - the url scheme that screen was created.
 @return genericViewController with screen definition or nil if screen name don't match any screen definitions
 */
+ (instancetype)genericWithScreenName:(NSString *)screenName
                 createdFromURLSCheme:(NSURL *)urlScheme;

/**

 */
+ (NSString *)genericClassNameForScreenName:(NSString *)screenName;

-(void)reloadScreen;
-(void)loadScreenComponents;
-(void)screenCustomization;
-(void)customizeNavigationBar;
-(void)attemptToPurchaseOverrideModel;
@end
