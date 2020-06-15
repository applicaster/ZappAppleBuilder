//
//  ZAAppDelegateConnectorRemoteConfigurationProtocol.h
//  ZappAppConnector
//
//  Created by Alex Zchut on 11/07/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//

#import <Foundation/NSObject.h>

@protocol ZAAppDelegateConnectorFirebaseRemoteConfigurationProtocol

- (NSString *) stringForKey:(NSString *)key;
- (NSNumber *) numberForKey:(NSString *)key;
- (BOOL) boolForKey:(NSString *)key;
- (NSSet<NSString *> *) keysWithPrefix:(NSString *)prefix;
@end
