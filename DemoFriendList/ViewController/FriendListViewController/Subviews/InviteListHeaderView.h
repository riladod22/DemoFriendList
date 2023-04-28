//
//  InviteListHeaderView.h
//  DemoFriendList
//
//  Created by PujieLee on 2023/4/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol InviteListHeaderViewDelegate <NSObject>
- (void)inviteListHeaderDidClicked;
@optional
@end

@interface InviteListHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *ivStatusArrow;
@property (weak, nonatomic) IBOutlet UIButton *btnInviteHeader;

@property (weak, nonatomic) id<InviteListHeaderViewDelegate> delegate;

- (void)setStatusArrow:(BOOL)isExpanded;
@end

NS_ASSUME_NONNULL_END
