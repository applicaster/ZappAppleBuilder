//
//  SKProduct+APAdditions.h
//  ApplicasterSDK
//
//  Created by Guy Kogus on 27/02/13.
//  Copyright (c) 2013 Applicaster. All rights reserved.
//

@import StoreKit;

@interface SKProduct (APAdditions)

@property(nonatomic, readonly) NSString *localizedPrice;

@end
