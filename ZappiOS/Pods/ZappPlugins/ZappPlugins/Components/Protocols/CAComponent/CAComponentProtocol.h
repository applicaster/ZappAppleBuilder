//
//  CAComponentProtocol.h
//  ZappPlugins
//
//  Created by Alex Zchut on 21/06/2018.
//

@protocol CAComponentDelegate;
@protocol CAComponentModelProtocol;

extern NSString * const kCACellTappedShareButtonNotification;
extern NSString * const kCACellTappedCleanButtonNotification;
extern NSString * const kCACellTappedBackButtonNotification;
extern NSString * const kCACellSetupSearchBarNotification;

static NSNotificationName const CAComponentLoaded = @"CAComponentLoaded";

typedef NS_ENUM(NSInteger, CAComponentState) {
    CAComponentStateNormal,
    CAComponentStateSelected,
    CAComponentStateHighlighted,
    CAComponentStateDisabled
};

typedef NS_ENUM(NSInteger, CAComponentEndDisplayingReason)
{
    CAComponentEndDisplayingReasonUndefined = 0,
    CAComponentEndDisplayingReasonCellQueued = 1,
    CAComponentEndDisplayingReasonParent = 2
};

@protocol CAComponentProtocol <NSObject>

@required

- (void)setComponentModel:(NSObject <CAComponentModelProtocol> *)componentModel;
- (void)setComponentDataSourceModel:(NSObject *)dataSource;

@optional

@property (nonatomic, strong) NSObject *selectedModel;
@property (nonatomic, strong) NSObject *componentDataSourceModel;
@property (nonatomic, strong) NSObject <CAComponentModelProtocol> *componentModel;
@property (nonatomic, weak) id <CAComponentDelegate> delegate;

- (void)setDataSource:(id)dataSource;
- (void)setComponentDataSource:(id)componentDataSource;

- (void)setupCustomizationDictionary;

- (void)setupAppDefaultDefinitions;
- (void)setupComponentDefinitions;

- (void)prepareComponentForReuse;
- (void)loadComponent;
- (void)reloadComponent;
- (void)reloadComponentWithNotification:(NSNotification *)notification;
- (void)rebuildComponent;
- (void)needUpdateLayout;
- (void)didEndDisplayingWithReason:(CAComponentEndDisplayingReason)reason;
- (void)didStartDisplaying;
@end

