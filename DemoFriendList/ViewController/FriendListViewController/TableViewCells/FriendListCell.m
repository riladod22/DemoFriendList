//
//  FriendListCell.m
//  DemoFriendList
//
//  Created by PujieLee on 2023/4/24.
//

#import "FriendListCell.h"
#import "ComFunc.h"

@implementation FriendListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //調整外觀
    [self setImageViewStyle:_ivUserAvatar];
    [self setViewStyle:_btnTransfer withBorderColor:UIColorFromRGB(0xDA40FF)];
    [self setViewStyle:_lblInviteSended withBorderColor:UIColorFromRGB(0x9A9A9A)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSDictionary *)data{
    //設定cell資料
    
    _ivStar.hidden = ![data[@"isTop"] isEqualToString:@"1"];
    
    _lblUserName.text = data[@"name"];
    
    _btnTransfer.hidden = [data[@"status"] intValue] != 1;
    _btnOptions.hidden = [data[@"status"] intValue] != 1;
    _lblInviteSended.hidden = [data[@"status"] intValue] != 2;
}

- (void)setImageViewStyle:(UIImageView *)iv{
    iv.layer.cornerRadius = iv.frame.size.height/2.0;
    iv.clipsToBounds = YES;
}

- (void)setViewStyle:(UIView *)vi withBorderColor:(UIColor *)color{
    vi.layer.cornerRadius = 2.0;
    vi.layer.borderWidth = 1.0;
    vi.layer.borderColor = color.CGColor;
    vi.clipsToBounds = YES;
}

@end
