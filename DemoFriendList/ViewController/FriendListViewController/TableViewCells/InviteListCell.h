//
//  InviteListCell.h
//  DemoFriendList
//
//  Created by PujieLee on 2023/4/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InviteListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ivStar;
@property (weak, nonatomic) IBOutlet UIImageView *ivUserAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnAgree;
@property (weak, nonatomic) IBOutlet UIButton *btnReject;

//註：高度=60
- (void)setCellData:(NSDictionary *)data;
@end

NS_ASSUME_NONNULL_END
