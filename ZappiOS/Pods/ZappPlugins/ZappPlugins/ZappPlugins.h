//
//  ZappPlugins.h
//  ZappPlugins
//
//  Created by Anton Kononenko on 08/06/16.
//  Copyright © 2016 Applicaster. All rights reserved.
//

@import UIKit;
@import ZappCore;

//! Project version number for ZappPlugins.
FOUNDATION_EXPORT double ZappPluginsVersionNumber;

//! Project version string for ZappPlugins.
FOUNDATION_EXPORT const unsigned char ZappPluginsVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <ZappPlugins/PublicHeader.h>

//ApplicasterSDK
#import "APContainerProtocol.h"
#import "APAtomContainerProtocol.h"
#import "APAtomEntryProtocol.h"
#import "APURLPlayableProtocol.h"


//Zapp AppConnector
#import "ZAAppDelegateConnectorFacebookAccountKitProtocol.h"
#import "ZAAppDelegateConnectorFirebaseRemoteConfigurationProtocol.h"
#import "ZAAppDelegateConnectorLocalizationProtocol.h"
#import "ZAAppDelegateConnectorLayoutsStylesProtocol.h"
#import "ZAAppDelegateConnectorTimeProtocol.h"
#import "ZAAppDelegateConnectorAnimationProtocol.h"
#import "ZAAppDelegateConnectorURLProtocol.h"
#import "ZAAppDelegateConnectorChromecastProtocol.h"
#import "CAComponentDelegate.h"
#import "CABasicGenericViewControllerDataSource.h"
#import "CAGenericViewControllerProtocol.h"
#import "CACellViewControllerBase.h"


//Zapp Helpers
#import "APKeychain.h"
#import "NSObject+Swizzle.h"
#import "NSData+APAdditions.h"
#import "NSDictionary+APAdditions.h"
#import "NSFileManager+APAdditions.h"
#import "NSObject+APAdditions.h"
#import "NSString+InflectionSupport.h"
#import "NSBundle+APAdditions.h"
#import "SKProduct+APAdditions.h"
#import "UIImage+APAdditions.h"
#import "UIView+APAnimation.h"
#import "UIScrollView+APAdditions.h"
#import "UIViewController+APAdditions.h"
#import "UIFont+APAdditions.h"
#import "NSString+APAdditions.h"
#import "UIFont+APAdditions.h"
#import "NSURL+APAddition.h"
#import "AVPlayerItem+APAdditions.h"
#import "NSArray+APAdditions.h"
#import "NSURLComponents+APAddition.h"
#import "UIImage+ImageWithColor.h"
#import "UIColor+ZPAdditions.h"
#import "UIDevice+APAdditions.h"
#import "UINavigationController+APAdditions.h"
#import "UIView+APAdditions.h"
#import "APProgramProtocol.h"
#import "APContainerProtocol.h"
#import "APAtomMediaGroup.h"
#import "APAtomEntryProtocol.h"
#import "UIImage+APAdditionsiOS.h"
#import "UILabel+GAAdditions.h"
#import "ZPAnalyticsConstants.h"

@import ZappCore;
