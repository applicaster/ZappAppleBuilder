//
//  SKProduct+APAdditions.m
//  ApplicasterSDK
//
//  Created by Guy Kogus on 27/02/13.
//  Copyright (c) 2013 Applicaster. All rights reserved.
//

#import "SKProduct+APAdditions.h"

@implementation SKProduct (APAdditions)

- (NSString *)localizedPrice
{
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[numberFormatter setLocale:self.priceLocale];
	return [numberFormatter stringFromNumber:self.price];
}

@end
