//
//  CACellViewControllerBase.h
//  ZappPlugins
//
//  Created by Alex Zchut on 21/06/2018.
//

@import UIKit;
@import WebKit;
#import "CAComponentProtocol.h"

@interface CACellViewControllerBase : UIViewController <CAComponentProtocol>

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *reminderButton;
@property (weak, nonatomic) IBOutlet UIButton *favoritesButton;

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *expandButton;
@property (weak, nonatomic) IBOutlet UILabel *ItemTypeLabel;
@property (weak, nonatomic) IBOutlet UIView *ItemTypeView;
@property (weak, nonatomic) IBOutlet UILabel *atomArticleDetails;

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UIImageView *scrollDownImageView;
@property (weak, nonatomic) IBOutlet UIImageView *featureImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemShowNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *itemBroadcastTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemAuthorLabel;

@property (weak, nonatomic) IBOutlet UIImageView *itemBookmarkBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *itemBookmarkImageView;
@property (weak, nonatomic) IBOutlet UIView *bookmarkContainerView;
@property (weak, nonatomic) IBOutlet UIView *hqmeButtonContainerView;


@property (nonatomic, weak) id <CAComponentDelegate> delegate;

/**
 ProgressBar for showing the progress of current running APProgram. Currently implemented only for cell with APProgram
 where @code[programItem isPlaying] = true@endcode
 Example for usage you can find in template 24.
 */
@property (nonatomic, weak) IBOutlet UIView *broadcastTimeProgressBarContainerView;

/**
 This label is currently used only for programs, but it's behaviour might be extended to other models.
 Connect your label to this IBOutlet in order to:

 For Programs:
 Present a "now", or "next" promotion texts for this label according to the program's broadcast time.
 If the program is playing now - will present the text from Zapp under the key: GAGenericCellPromotionNow.
 If the program is a future program - will present the text from Zapp under the key: GAGenericCellPromotionFuture.
 If the program is a past program - will present the text from Zapp under the key: GAGenericCellPromotionPast.
 */
@property (weak, nonatomic) IBOutlet UILabel *itemPromotionLabel;

@property (weak, nonatomic) IBOutlet UILabel *itemDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextView *itemDescriptionTextView;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *itemLockedImageView;

@property (weak, nonatomic) IBOutlet UILabel *itemTopLevelCategoryNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shadowImageView;
@property (weak, nonatomic) IBOutlet UIView *borderView;
@property (weak, nonatomic) IBOutlet UIImageView *inAppRibbonImageView;

@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UIView *hintView;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewCollection;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViewCollection;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonsViewCollection;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray<UILabel *> *labelsCollection;

// HQME

@property (nonatomic, weak) IBOutlet UIButton *hqmeButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelHqmeProcessButton;
@property (nonatomic, weak) IBOutlet UIButton *deleteHqmeButton;
@property (nonatomic, weak) IBOutlet UIView *hqmeProgressBarContainerView;

/**
 The video container view is used for Inline video playback using the Applicaster / Plugin player
 */
@property (weak, nonatomic) IBOutlet UIView *videoContainerView;

/**
 The promo video container view is used for short looping video player.
 This will use a simple
 */
@property (weak, nonatomic) IBOutlet UIView *promoVideoContainerView;


/**
 The Webview container is used for displaying HTML tickers (for things like live match scores)
 */
@property (weak, nonatomic) IBOutlet WKWebView *tickerWebView;

/**
 Method which indicates the cell style - call-to-action or default.
 @return method returns YES, if cell is call-to-action type, otherwise it returns NO.
 */
- (BOOL)isCallToActionItem;

/**
 This method is adjusting the UI according to content type.
 By default the method shows Play button.
 You can override this method and add necessary logic.
 */
- (void)showPlayButton;

/**
 This method is adjusting the UI according to content type.
 By default the method shows Reminder button.
 You can override this method and add necessary logic.
 */
- (void)showReminderButton;

/**
 This method is adjusting the UI according to content type.
 By default the method shows Info button.
 You can override this method and add necessary logic.
 */
- (void)showInfoButton;

/**
 This method is adjusting the UI according to content type.
 By default method hides Play,favorites,expand and Reminder buttons.
 You can override this method and add necessary logic.
 */
- (void)hideAllButtons;

/**
 Connect this IBAction to tapping the expandButton in your xib.
 If you override this method in your subclass, you must call the superclass implementation.
 */
- (IBAction)onExpandButtonTapped:(UIButton *)sender;
- (IBAction)onPlayButtonTapped:(UIButton *)sender;

/**
 Adjust cell "direction" by checking if Layout and app are not both using the same directions
 This method can be overriden or extended by inherited cells to fix / ignore certain behaviors
 */
- (void)adjustCellSemanticContentAttributes;

- (void)updateUI;

- (void)resetCellState;

/**
 Displays an atom entry according to the entry given to it.
 Subclass of CACellViewController will override this method in order to populate the cell with extra parameters
 from a datasource extension plugin
 */
- (void)displayAtomEntry:(NSObject *)atomEntry;

/**
 Displays an atom feed according to the feed given to it.
 Subclass of CACellViewController will override this method in order to populate the cell with extra parameters
 from a datasource extension plugin
 */
- (void)displayAtomFeed:(NSObject *)atomFeed;

@end
