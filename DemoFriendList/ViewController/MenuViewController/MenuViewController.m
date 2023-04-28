//
//  MenuViewController.m
//  DemoFriendList
//
//  Created by PujieLee on 2023/4/23.
//

#import "MenuViewController.h"
#import "ComFunc.h"
#import "AppApi.h"
#import "FriendListViewController.h"

@interface MenuViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *listData;
    NSDictionary *manData;
}
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self uiInit];
    [self getMan];
}

#pragma mark - process event
- (void)uiInit{
    listData = @[@{@"desc":@"0_無好友", @"scene":intToStr(FriendListScene_None)},
                 @{@"desc":@"1_好友列表無邀請", @"scene":intToStr(FriendListScene_Friend)},
                 @{@"desc":@"2_好友列表含邀請好友", @"scene":intToStr(FriendListScene_FriendInvite)}];
    
    _tbMenu.delegate = self;
    _tbMenu.dataSource = self;
    
}

- (void)pushToFriendList:(int)scene manData:(NSDictionary *)manData{
    
    FriendListViewController *vc = [[FriendListViewController alloc] init];
    vc.listScene = scene;
    vc.manData = manData;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getMan{
    //取得使用者資料
    
    [self ldBarActive:@"讀取中..."];
    
    [[AppApi sharedManager] getManWithCompletion:^(id  _Nullable data, NSError * _Nullable error) {
        
        [self closeLdBar];
        
        if(!error){
            NSArray *respData = [ComFunc jsonDataToObj:data][@"response"];
            if(respData){
                //success
                if(respData.count>0){
                    self->manData = respData[0];
                }
            }else{
                [ComFunc displayAlert:@"連線錯誤" title:@"請注意" yes:nil no:@"確定" andTarget:self andAction:nil];
            }
        }else{
            [ComFunc displayAlert:@"連線錯誤" title:@"請注意" yes:nil no:@"確定" andTarget:self andAction:nil];
        }
    
    }];
}

#pragma mark - table relate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    cell.textLabel.text = listData[indexPath.row][@"desc"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    int func = [listData[indexPath.row][@"scene"] intValue];
    
    [self pushToFriendList:func manData:manData];
}


@end
