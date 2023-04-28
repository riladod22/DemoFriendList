//
//  InviteListHeaderView.m
//  DemoFriendList
//
//  Created by PujieLee on 2023/4/24.
//

#import "InviteListHeaderView.h"

@implementation InviteListHeaderView

- (void)setStatusArrow:(BOOL)isExpanded{
    
    NSString *imgName = isExpanded ? @"comm_ic_arrow_black_up.png" : @"comm_ic_arrow_black_down.png";
    self.ivStatusArrow.image = [UIImage imageNamed:imgName];
}

- (IBAction)btnInviteHeaderClicked:(id)sender {
    [self.delegate inviteListHeaderDidClicked];
}

@end
