//
//  CABasicGenericViewControllerDataSource.h
//  ZappPlugins
//
//  Created by Anton Kononenko on 27/11/2016.
//  Copyright © 2016 Applicaster LTD. All rights reserved.
//

@protocol CABasicGenericViewControllerDataSource <NSObject>

/**
 Dictionary that observs specific actions
 Example:
 "observer": {
 "key": "APStoreKitPurchaseCompleteNotification",
 "action": "reload_screen"
 }
 */
-(NSDictionary *)actionObserver;
-(BOOL)shouldShowRefreshView;
-(NSString *)analyticsScreenName;
-(NSArray *)parallaxBackgroundAnimationLayerObjects;
-(NSArray *)parallaxForegroundAnimationLayerObjects;
-(NSDictionary *)loadingIndicatorDictionary;
-(NSTimeInterval)screenRefreshTime;
@end
