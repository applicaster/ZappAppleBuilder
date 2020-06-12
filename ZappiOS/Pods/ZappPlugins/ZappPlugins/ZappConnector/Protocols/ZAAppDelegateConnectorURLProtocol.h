//
//  ZAAppDelegateConnectorURLProtocol.h
//  ZappAppConnector
//
//  Created by Alex Zchut on 11/07/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//


@protocol ZAAppDelegateConnectorURLProtocol

- (NSString *_Nullable)appUrlSchemePrefix;
- (nullable NSURL *)fileUrlWithName:(NSString *_Nullable)fileName extension:(NSString *_Nullable)extension;

@end
