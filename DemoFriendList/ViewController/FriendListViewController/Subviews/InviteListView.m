//
//  InviteListView.m
//  DemoFriendList
//
//  Created by PujieLee on 2023/4/24.
//

#import "InviteListView.h"
#import "InviteListCell.h"

@interface InviteListView()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *listData;
    float headerHeight;//要對應InviteListHeaderView高度,固定40
}
@end

@implementation InviteListView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self uiInit];
}

#pragma mark - process event
- (void)uiInit{
    
    //預設值
    headerHeight = 40.0;
    listData = @[];
    
    //設定table
    _tbInviteList.delegate = self;
    _tbInviteList.dataSource = self;
    [_tbInviteList registerNib:[UINib nibWithNibName:@"InviteListCell" bundle:nil] forCellReuseIdentifier:@"InviteListCell"];
    _tbInviteList.estimatedRowHeight = UITableViewAutomaticDimension;
    
    //畫面調整
    [self setViewExpanded:NO];
}

- (void)setInviteData:(NSArray *)data{
    listData = data;
    [_tbInviteList reloadData];
}

//- (void)setHeaderHeight:(float)height{
//    headerHeight = height;
//}

- (void)setViewExpanded:(BOOL)isExpanded{
    //設定是否展開
    
    if(isExpanded){
        //展開
        
        UIView *superview = self.superview;
        float expHeight = (superview ? superview.frame.size.height : 0) - headerHeight;
        
        //調整高度
        self.conInviteListHeight.constant = expHeight;
        
        _tbInviteList.userInteractionEnabled = YES;
    }else{
        //收合
        
        //調整高度
        self.conInviteListHeight.constant = 60;
        
        _tbInviteList.userInteractionEnabled = NO;
        [_tbInviteList setContentOffset:CGPointZero animated:YES];
    }
}

#pragma mark - table view relate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *rowData = listData[indexPath.row];
    
    InviteListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InviteListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setCellData:rowData];
  
    return cell;
}

@end
