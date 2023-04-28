//
//  InviteListCell.m
//  DemoFriendList
//
//  Created by PujieLee on 2023/4/24.
//

#import "InviteListCell.h"
#import "ComFunc.h"

@implementation InviteListCell

- (void)awakeFromNib {
    [super awakeFromNib];

    //調整外觀
    [self setImageViewStyle:_ivUserAvatar];
    [self setButtonStyle:_btnAgree withBorderColor:UIColorFromRGB(0xDA40FF)];
    [self setButtonStyle:_btnReject withBorderColor:UIColorFromRGB(0x9A9A9A)];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSDictionary *)data{
    //設定cell資料
    _ivStar.hidden = ![data[@"isTop"] isEqualToString:@"1"];
    
    _lblUserName.text = data[@"name"];
}

- (void)setImageViewStyle:(UIImageView *)iv{
    iv.layer.cornerRadius = iv.frame.size.height/2.0;
    iv.clipsToBounds = YES;
}

- (void)setButtonStyle:(UIButton *)btn withBorderColor:(UIColor *)color{
    btn.layer.cornerRadius = btn.frame.size.height/2.0;
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = color.CGColor;
    btn.clipsToBounds = YES;
}
@end
