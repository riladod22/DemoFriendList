//
//  FriendListHeaderView.h
//  DemoFriendList
//
//  Created by PujieLee on 2023/4/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FriendListHeaderViewDelegate <NSObject>
- (void)searchBarChangedWithText:(NSString *)txt;
@optional
@end

@interface FriendListHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblFriendListTitle;
@property (weak, nonatomic) IBOutlet UIView *viSearchBarBg;
@property (weak, nonatomic) IBOutlet UITextField *tfSearchBar;

@property (weak, nonatomic) id<FriendListHeaderViewDelegate> delegate;

//註：高96
- (void)setFriendListTitleWithCount:(int)friendCount;

@end

NS_ASSUME_NONNULL_END
