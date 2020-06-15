//
//  APAtomContainerProtocol.h
//  ApplicasterSDK
//
//  Created by Anton Kononenko on 02/04/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APAtomEntryProtocol.h"

@protocol APAtomContainerProtocol <NSObject, APAtomEntryProtocol>

/**
 Children items of the atom feed
 */
@property (nonatomic, strong) NSArray *entries;

@end
