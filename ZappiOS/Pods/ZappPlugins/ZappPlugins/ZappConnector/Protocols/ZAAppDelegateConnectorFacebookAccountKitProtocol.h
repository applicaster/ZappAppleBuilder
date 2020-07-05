//
//  ZAAppDelegateConnectorFacebookAccountKitProtocol.h
//  ZappAppConnector
//
//  Created by sborkin on 26/12/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//

#import <Foundation/NSObject.h>

@class ZAAccountKitUser;

typedef NS_ENUM(NSUInteger, ZAAccountKitLoginType) {
    ZAAccountKitLoginTypeEmail,
    ZAAccountKitLoginTypePhone
};

typedef NS_ENUM(NSUInteger, ZAAccountKitStatus) {
    ZAAccountKitStatusCanceled,
    ZAAccountKitStatusFailed,
    ZAAccountKitStatusCompleted
};

typedef void(^AccountKitLoginCompletionBlock)(ZAAccountKitStatus, ZAAccountKitUser *_Nullable);

@protocol ZAAppDelegateConnectorFacebookAccountKitProtocol

- (void)authorizeFacebook:(BOOL)forced readPermissions:(nullable NSArray *)readPermissions completion:(void (^ _Nullable)(BOOL logedIn, NSError * _Nullable error))completion;

- (BOOL)isFacebookSessionValid;

- (void) clientRequestWithGraphPath:(NSString *_Nullable)graphPath
                         withParams:(NSMutableDictionary *_Nullable)params
                     withHTTPMethod:(NSString *_Nonnull)httpMethod
              withCompletionHandler:(void (^_Nullable)(id _Nullable connection, id _Nullable result, NSError * _Nullable error))handler;

#pragma mark - AccountKit
- (BOOL)isAuthenticated;
- (void)performLoginWithType:(ZAAccountKitLoginType)type completion:(AccountKitLoginCompletionBlock _Nullable )completion;

@end
