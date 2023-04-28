//
//  AppApi.m
//  DemoFriendList
//
//  Created by PujieLee on 2023/3/22.
//

#import "AppApi.h"
#import "ComFunc.h"
#import "AppProperties.h"


@interface AppApi(){

}
@end

@implementation AppApi
#pragma mark - process
+(instancetype) sharedManager{
    static AppApi* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance==nil) {
            instance = [[AppApi alloc] init];
        }
    });
    
    return instance;
}

- (void)getManWithCompletion:(RequestCompletion)completion {
    /*
     api get man 取得使用者資料
     */
    
    [[WebHelp sharedManager] getHttpRequest:@{} method:@"man.json" withCompletion:^(id data ,NSError *error){
        completion(data, error);
        
    }];
}

- (void)getFriend1WithCompletion:(RequestCompletion)completion {
    /*
     api get friend1 取得聯絡人資料_1
     */
    
    [[WebHelp sharedManager] getHttpRequest:@{} method:@"friend1.json" withCompletion:^(id data ,NSError *error){
        completion(data, error);
        
    }];
}

- (void)getFriend2WithCompletion:(RequestCompletion)completion {
    /*
     api get friend2 取得聯絡人資料_2
     */
    
    [[WebHelp sharedManager] getHttpRequest:@{} method:@"friend2.json" withCompletion:^(id data ,NSError *error){
        completion(data, error);
        
    }];
}

- (void)getFriend3WithCompletion:(RequestCompletion)completion {
    /*
     api get friend3 取得聯絡人資料_3
     */
    
    [[WebHelp sharedManager] getHttpRequest:@{} method:@"friend3.json" withCompletion:^(id data ,NSError *error){
        completion(data, error);
        
    }];
}

- (void)getFriend4WithCompletion:(RequestCompletion)completion {
    /*
     api get friend4 取得聯絡人資料_4
     */
    
    [[WebHelp sharedManager] getHttpRequest:@{} method:@"friend4.json" withCompletion:^(id data ,NSError *error){
        completion(data, error);
        
    }];
}

@end
