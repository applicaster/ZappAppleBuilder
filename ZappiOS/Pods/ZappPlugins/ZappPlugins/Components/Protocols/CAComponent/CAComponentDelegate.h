//
//  CAComponentDelegate.h
//  ZappPlugins
//
//  Created by Alex Zchut on 21/06/2018.
//
#import "CAComponentProtocol.h"

@class ZLScreenModel;
@class APModel;
@protocol CAComponentModelProtocol;

@protocol CAComponentDelegate <NSObject>

@optional

- (BOOL)shouldLoadDataSourceForModel:(NSObject *)model
                      componentModel:(NSObject <CAComponentModelProtocol> *)componentModel
                     completionBlock:(void (^)(NSArray *dataSource))completion;

// Other

- (NSObject *)topParentForComponentModel:(NSObject <CAComponentModelProtocol> *)componentModel
                     withDataSourceModel:(NSObject *)model;

- (void)handleCloseScreen;

- (NSURLRequestCachePolicy)cachePolicyForDataSourceModel:(NSObject *)model
                                          componentModel:(NSObject <CAComponentModelProtocol> *)componentModel;

- (void)componentViewController:(UIViewController <CAComponentProtocol>*)componentViewController
                 didSelectModel:(NSObject *)model
                 componentModel:(NSObject <CAComponentModelProtocol> *)componentModel
                    atIndexPath:(NSIndexPath *)indexPath
                     completion:(void (^)(UIViewController *targetViewController))completion;

- (void)loadingFinishedWithNotification:(NSNotification *)notification;


- (void)componentViewController:(UIViewController <CAComponentProtocol>*)componentViewController
        didChangedContentOffset:(CGPoint)contentOffset;

- (void)addRefreshTaskAfterDelay:(NSTimeInterval)delay;
- (APModel *)currenlySelectedModel;

/**
 Remove item displayed in the component delegate by model and component model
 */
- (void)removeComponentForModel:(NSObject *)model
              andComponentModel:(NSObject <CAComponentModelProtocol> *)componentModel;

- (ZLScreenModel *)retrieveScreenModelOfComponent;
@end
