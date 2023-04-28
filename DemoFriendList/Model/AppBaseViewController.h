//
//  AppBaseViewController.h
//  DemoFriendList
//
//  Created by PujieLee on 2023/3/24.
//

#import <UIKit/UIKit.h>
#import "ComFunc.h"
#import "AppApi.h"
#import "AppProperties.h"


NS_ASSUME_NONNULL_BEGIN

@interface AppBaseViewController : UIViewController{
    //讀取遮罩 讀取訊息
    UIAlertController *vcLoadingMsg;
    
    //畫面點擊
    UITapGestureRecognizer *tap;
    
}

- (void)ldBarActive:(NSString*)str;//顯示讀取圈圈
- (void)closeLdBar; //移除讀取圈

//-(void)CreateTapGestureForDismissKeyboard;//建立手勢-點擊畫面關閉鍵盤
//-(void)RemoveTapGestureForDismissKeyboard;//移除手勢-點擊畫面關閉鍵盤
-(void)dismissKeyboard;//關閉鍵盤
   
#pragma mark - navigation
- (void)popToViewByClass:(Class)targetViewClass;



@end

NS_ASSUME_NONNULL_END
