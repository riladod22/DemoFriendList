//
//  AppBaseViewController.m
//  DemoFriendList
//
//  Created by PujieLee on 2023/3/24.
//

#import "AppBaseViewController.h"

@interface AppBaseViewController ()

@end

@implementation AppBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)ldBarActive:(NSString*)str {
    //顯示讀取遮罩+訊息
    if ([NSThread isMainThread]) {
        [self runLdBarActive:str];
    } else {
        dispatch_sync(dispatch_get_main_queue(),^{
            [self runLdBarActive:str];
        });
    }
}

- (void)runLdBarActive:(NSString*)str{
    //顯示讀取遮罩+訊息 (ver2)
    
    if (!vcLoadingMsg){
        vcLoadingMsg = [[UIAlertController alloc] init];
        
        UIActivityIndicatorView *aiIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
        aiIndicator.center = CGPointMake(130.5, 65.5);
        aiIndicator.color = [UIColor blackColor];
        [aiIndicator startAnimating];
        
        //iOS8以上使用 UIAlertController
        vcLoadingMsg = [UIAlertController alertControllerWithTitle:@"請稍候..." message:@"\n\n" preferredStyle:UIAlertControllerStyleAlert];
        [vcLoadingMsg.view addSubview:aiIndicator];
        
        [self presentViewController:vcLoadingMsg animated:NO completion:nil];
    }
    
    vcLoadingMsg.title = str;
     
}

- (void)closeLdBar{
    //移除讀取遮罩+訊息 (ver2)
    
    if ([NSThread isMainThread]){
        [vcLoadingMsg dismissViewControllerAnimated:NO completion:nil];
        vcLoadingMsg = nil;
    }else{
        dispatch_sync(dispatch_get_main_queue(),^{
            [vcLoadingMsg dismissViewControllerAnimated:NO completion:nil];
            vcLoadingMsg = nil;
        });
    }
}

/*
 OLD Backup
- (void)runLdBarActive:(NSString*)str{
    //顯示讀取遮罩+訊息
    
    if (!viLoadingMask){
        [self initViLoadingMask];
    }
    if (!lblLoadingMsg){
        [self initLblLoadingMsg];
    }
    
    if(!viLoadingMask.superview){
        [self.view addSubview:viLoadingMask];
        [ComFunc setViewMatchParent:viLoadingMask];
        
        [viLoadingMask addSubview:lblLoadingMsg];
        [ComFunc setViewAlignCenter:lblLoadingMsg];
    }
    
    lblLoadingMsg.text = str;
}

- (void)closeLdBar{
    //移除讀取遮罩+訊息
    
    if ([NSThread isMainThread]){
        [viLoadingMask removeFromSuperview];
    }else{
        dispatch_sync(dispatch_get_main_queue(),^{
            [viLoadingMask removeFromSuperview];
        });
    }
}
*/

-(void)dismissKeyboard {
    //關閉鍵盤
    [self.view endEditing:YES];
}

#pragma mark - navigation
- (void)popToViewByClass:(Class)targetViewClass{
    //退回到指定View
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:targetViewClass]){
            [self.navigationController popToViewController:vc animated:NO];
        }
    }
}


@end
