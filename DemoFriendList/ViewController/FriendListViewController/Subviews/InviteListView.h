//
//  InviteListView.h
//  DemoFriendList
//
//  Created by PujieLee on 2023/4/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InviteListView : UIView
@property (weak, nonatomic) IBOutlet UITableView *tbInviteList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conInviteListHeight;

- (void)setInviteData:(NSArray *)data;
//- (void)setHeaderHeight:(float)height;
- (void)setViewExpanded:(BOOL)isExpanded;
@end

NS_ASSUME_NONNULL_END
