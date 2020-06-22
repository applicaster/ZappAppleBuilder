//
//  APContainerProtocol.h
//  ApplicasterSDK
//
//  Created by Anton Kononenko on 12/03/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//

@import Foundation;

@protocol APContainerProtocol <NSObject>

@required

@property (readonly, strong) NSString *containerType;
@property (readonly, strong) NSArray *children;
@property (readonly, assign) BOOL isLoaded;

- (void)loadModelWithCompletion:(void (^)(BOOL success, id<APContainerProtocol> loadedModel))completion;
- (void)loadModel:(BOOL)shouldInvalidateCache completion:(void (^)(BOOL success, id<APContainerProtocol> loadedModel))completion;


@end

