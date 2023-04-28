//
//  FriendListViewController.h
//  DemoFriendList
//
//  Created by PujieLee on 2023/4/23.
//

#import "AppBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    FriendListScene_None = 0,
    FriendListScene_Friend = 1,
    FriendListScene_FriendInvite = 2
} FriendListScene;

@interface FriendListViewController : AppBaseViewController


@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserId;
@property (weak, nonatomic) IBOutlet UIImageView *IvUserAvatar;

@property (weak, nonatomic) IBOutlet UIStackView *stMainList;
@property (weak, nonatomic) IBOutlet UIView *viWhenStart;

@property (nonatomic) FriendListScene listScene;
@property (strong, nonatomic) NSDictionary *manData;

@end

NS_ASSUME_NONNULL_END
