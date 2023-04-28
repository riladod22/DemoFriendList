//
//  FriendListView.h
//  DemoFriendList
//
//  Created by PujieLee on 2023/4/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FriendListViewDelegate <NSObject>
- (void)friendListPullToRefresh;
@optional
@end

@interface FriendListView : UIView

@property (weak, nonatomic) IBOutlet UITableView *tbFriendList;

@property (weak, nonatomic) id<FriendListViewDelegate> delegate;

- (void)setFriendData:(NSArray *)data;
- (void)setFilterWithText:(NSString *)text;
    
@end

NS_ASSUME_NONNULL_END
