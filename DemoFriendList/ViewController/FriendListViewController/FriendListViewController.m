//
//  FriendListViewController.m
//  DemoFriendList
//
//  Created by PujieLee on 2023/4/23.
//

#import "FriendListViewController.h"
#import "InviteListHeaderView.h"
#import "InviteListView.h"
#import "FriendListHeaderView.h"
#import "FriendListView.h"

@interface FriendListViewController ()<InviteListHeaderViewDelegate, FriendListHeaderViewDelegate, FriendListViewDelegate>{
    
    NSMutableArray *listData;//列表資料(status=0~2)
    BOOL isInviteListExpand;//是否展開邀請列 YES=是 NO=否
    
    InviteListHeaderView *inviteListHeaderView;//邀請header
    InviteListView *inviteListView;//邀請列表
    FriendListHeaderView *friendListHeaderView;//好友header
    FriendListView *friendListView;//好友列表
}

@end

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self uiInit];
}

#pragma mark - process event
- (void)uiInit{
    
    //預設值
    listData = [[NSMutableArray alloc] init];
    isInviteListExpand = NO;
    
    //設定user
    if (_manData){
        _lblUserName.text = _manData[@"name"];
        _lblUserId.text = _manData[@"kokoid"];
    }
    _IvUserAvatar.layer.cornerRadius = _IvUserAvatar.frame.size.height/2.0;
    _IvUserAvatar.clipsToBounds = YES;
    
    //點擊關鍵盤
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    //取得資料
    [self getDataWithScene:_listScene];
}

- (void)getDataWithScene:(FriendListScene)scene{
    //取得資料
    
    //清空
    listData = [[NSMutableArray alloc] init];
    
    switch (scene) {
        case FriendListScene_Friend:{
            [self getSceneFriendData];
            break;
        }
        case FriendListScene_FriendInvite:{
            [self getSceneFriendInviteData];
            break;
        }
        default:{
            //FriendListScene_None
            [self getSceneNoneData];
            break;
        }
    }
}

- (void)setListData:(NSArray *)data{
    //把資料加入listData
    
    for (NSDictionary *dt in data) {
        
        BOOL isUserExist = NO;
        for(int i=0; i<listData.count; i++){
            NSDictionary *listDt = listData[i];
            
            //比對相同fid
            if([listDt[@"fid"] isEqualToString:dt[@"fid"]]){
                listData[i] = [self compareUserDataReturnBigDate:listDt and:dt];
                isUserExist = YES;
                break;
            }
        }
        
        if(!isUserExist){
            [listData addObject:dt];
        }
    }
    
}

-(NSDictionary *)compareUserDataReturnBigDate:(NSDictionary *)a and:(NSDictionary *)b{
    //比較兩筆user資料回傳日期比較大的
    //外加修正日期資料格式
    
    int aDate = [[(a[@"updateDate"] ? : @"") stringByReplacingOccurrencesOfString:@"/" withString:@""] intValue];
    int bDate = [[(b[@"updateDate"] ? : @"") stringByReplacingOccurrencesOfString:@"/" withString:@""] intValue];
    
    if (aDate > bDate){
        return a;
    }else{
        return b;
    }
}

- (void)uiReload{
    //列表重新整理

    //好友資料, 邀請資料
    NSMutableArray *friendListData = [[NSMutableArray alloc] init];
    NSMutableArray *inviteListData = [[NSMutableArray alloc] init];
    
    for (NSDictionary *listDt in listData) {
        if([listDt[@"status"] intValue] == 0){
            [inviteListData addObject:listDt];//0
        }else{
            [friendListData addObject:listDt];//1,2
        }
    }
    
    if(friendListData.count > 0 || inviteListData.count > 0){
        
        //清空 stack view
        NSArray *views = _stMainList.subviews;
        for (UIView *v in views) {
            [v removeFromSuperview];
        }
        
        //建立view
        //建立邀請header
        if (!inviteListHeaderView){
            inviteListHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"InviteListHeaderView" owner:self options:nil] objectAtIndex:0];
            inviteListHeaderView.delegate = self;
        }
        
        //建立邀請list
        if (!inviteListView){
            inviteListView = [[[NSBundle mainBundle] loadNibNamed:@"InviteListView" owner:self options:nil] objectAtIndex:0];
        }
        
        //建立好友header
        if (!friendListHeaderView){
            friendListHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"FriendListHeaderView" owner:self options:nil] objectAtIndex:0];
            friendListHeaderView.delegate = self;
        }
        
        //建立好友list
        if (!friendListView){
            friendListView = [[[NSBundle mainBundle] loadNibNamed:@"FriendListView" owner:self options:nil] objectAtIndex:0];
            friendListView.delegate = self;
        }
        
        //建好的view 加入畫面
        if(_listScene == FriendListScene_FriendInvite){//註：因為資料面的問題所以判斷進入路徑來讓邀請列表強制不顯示
            
            if(inviteListData.count > 0){
                //邀請header
                [_stMainList addArrangedSubview:inviteListHeaderView];
                [inviteListHeaderView setStatusArrow:isInviteListExpand];
                
                //邀請List
                [_stMainList addArrangedSubview:inviteListView];
                [inviteListView setInviteData:inviteListData];
                [inviteListView setViewExpanded:isInviteListExpand];
            }
        }
        
        if(!isInviteListExpand){
            //好友header
            [_stMainList addArrangedSubview:friendListHeaderView];
            [friendListHeaderView setFriendListTitleWithCount:(int)friendListData.count];
            
            //好友List
            [_stMainList addArrangedSubview:friendListView];
            [friendListView setFriendData:friendListData];
        }
        
    }
}

#pragma mark - api
- (void)getSceneFriendData{
    //取好友資料1 & 2
    
    dispatch_group_t group = dispatch_group_create();
    
    [self ldBarActive:@"讀取中..."];
    
    //friend 1
    dispatch_group_enter(group);
    [[AppApi sharedManager] getFriend1WithCompletion:^(id  _Nullable data, NSError * _Nullable error) {
        
        if(!error){
            NSArray *respData = [ComFunc jsonDataToObj:data][@"response"];
            if(respData){
                //success
                [self setListData:respData];
                
            }else{
                [ComFunc displayAlert:@"連線錯誤" title:@"請注意" yes:nil no:@"確定" andTarget:self andAction:nil];
            }
        }else{
            [ComFunc displayAlert:@"連線錯誤" title:@"請注意" yes:nil no:@"確定" andTarget:self andAction:nil];
        }
        
        dispatch_group_leave(group);
    }];
    
    //friend 2
    dispatch_group_enter(group);
    [[AppApi sharedManager] getFriend2WithCompletion:^(id  _Nullable data, NSError * _Nullable error) {
        
        if(!error){
            NSArray *respData = [ComFunc jsonDataToObj:data][@"response"];
            if(respData){
                //success
                [self setListData:respData];
                
            }else{
                [ComFunc displayAlert:@"連線錯誤" title:@"請注意" yes:nil no:@"確定" andTarget:self andAction:nil];
            }
        }else{
            [ComFunc displayAlert:@"連線錯誤" title:@"請注意" yes:nil no:@"確定" andTarget:self andAction:nil];
        }
        
        dispatch_group_leave(group);
    }];
    
    //1+2 完成
//    dispatch_queue_attr_t qos = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_DEFAULT, -1);
//    dispatch_queue_t groupNotifyQueue = dispatch_queue_create("groupNotifyQueue", qos);
//
//    dispatch_group_notify(group, groupNotifyQueue, ^{
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self closeLdBar];
        [self uiReload];
    });
}

- (void)getSceneFriendInviteData{
    //取好友+邀請資料
    
    [self ldBarActive:@"讀取中..."];
    
    [[AppApi sharedManager] getFriend3WithCompletion:^(id  _Nullable data, NSError * _Nullable error) {
        
        [self closeLdBar];
        
        if(!error){
            NSArray *respData = [ComFunc jsonDataToObj:data][@"response"];
            if(respData){
                //success
                [self setListData:respData];
                
                dispatch_sync(dispatch_get_main_queue(),^{
                    [self uiReload];
                });
            }else{
                [ComFunc displayAlert:@"連線錯誤" title:@"請注意" yes:nil no:@"確定" andTarget:self andAction:nil];
            }
        }else{
            [ComFunc displayAlert:@"連線錯誤" title:@"請注意" yes:nil no:@"確定" andTarget:self andAction:nil];
        }
    }];
}

- (void)getSceneNoneData{
    //取無好友資料
    
    [self ldBarActive:@"讀取中..."];
    
    [[AppApi sharedManager] getFriend4WithCompletion:^(id  _Nullable data, NSError * _Nullable error) {
        
        [self closeLdBar];
        
        if(!error){
            NSArray *respData = [ComFunc jsonDataToObj:data][@"response"];
            if(respData){
                //success
                [self setListData:respData];
                
                dispatch_sync(dispatch_get_main_queue(),^{
                    [self uiReload];
                });
            }else{
                [ComFunc displayAlert:@"連線錯誤" title:@"請注意" yes:nil no:@"確定" andTarget:self andAction:nil];
            }
        }else{
            [ComFunc displayAlert:@"連線錯誤" title:@"請注意" yes:nil no:@"確定" andTarget:self andAction:nil];
        }
    }];
}

#pragma mark - view delegate
- (void)inviteListHeaderDidClicked{
    //invite 展開/收合
    isInviteListExpand = !isInviteListExpand;
    [self uiReload];
}

- (void)searchBarChangedWithText:(NSString *)txt{
    //search bar 文字改變
    [friendListView setFilterWithText:txt];
}

- (void)friendListPullToRefresh{
    //friend list 下拉刷新
    [self getDataWithScene:_listScene];
}

@end
