//
//  FriendListHeaderView.m
//  DemoFriendList
//
//  Created by PujieLee on 2023/4/24.
//

#import "FriendListHeaderView.h"

@interface FriendListHeaderView()<UITextFieldDelegate>{
    
}
@end

@implementation FriendListHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self uiInit];
}

#pragma mark - process event
- (void)uiInit{
    //設定外觀
    _viSearchBarBg.layer.cornerRadius = 6.0;
    _viSearchBarBg.clipsToBounds = YES;
    
    //設定text field
    _tfSearchBar.delegate = self;
}

- (void)setFriendListTitleWithCount:(int)friendCount{
    //設定標題好友數
    _lblFriendListTitle.text = [NSString stringWithFormat:@"好友列表  %d",friendCount];
}

#pragma mark - ui delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *returnText = textField.text ? : @"";
    [self.delegate searchBarChangedWithText:returnText];
}

@end
