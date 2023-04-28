//
//  FriendListView.m
//  DemoFriendList
//
//  Created by PujieLee on 2023/4/24.
//

#import "FriendListView.h"
#import "FriendListCell.h"
#import "SVPullToRefresh.h"

@interface FriendListView()<UITableViewDelegate, UITableViewDataSource>{
    NSString *filterText;
    NSArray *listData;//原始資料
    NSArray *listDataFiltered;//篩選後的資料
}
@end

@implementation FriendListView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self uiInit];
}

#pragma mark - process event
- (void)uiInit{
    
    //預設值
    listData = @[];
    listDataFiltered = @[];
    filterText = @"";
    
    //設定table
    _tbFriendList.delegate = self;
    _tbFriendList.dataSource = self;
    [_tbFriendList registerNib:[UINib nibWithNibName:@"FriendListCell" bundle:nil] forCellReuseIdentifier:@"FriendListCell"];
    _tbFriendList.estimatedRowHeight = UITableViewAutomaticDimension;
    
    //table下拉刷新
    [_tbFriendList addPullToRefreshWithActionHandler:^{//to base
        [self.delegate friendListPullToRefresh];
        [self.tbFriendList.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0.5];
    }];
}

- (void)setFriendData:(NSArray *)data{
    listData = data;
    [self prepareReloadTable];
}

- (void)setFilterWithText:(NSString *)text{
    filterText = text ? : @"";
    [self prepareReloadTable];
}

- (void)prepareReloadTable{
    //篩選資料 -> table reload
    
    if (filterText && filterText.length > 0){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@",filterText];
        listDataFiltered = [listData filteredArrayUsingPredicate:predicate];
    }else{
        listDataFiltered = listData;
    }
    
    [_tbFriendList reloadData];
}

#pragma mark - table view relate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return listDataFiltered.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *rowData = listDataFiltered[indexPath.row];
    
    FriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setCellData:rowData];
  
    return cell;
}

@end
