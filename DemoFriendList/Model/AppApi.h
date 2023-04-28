//
//  AppApi.h
//  DemoFriendList
//
//  Created by PujieLee on 2023/3/22.
//

#import <Foundation/Foundation.h>
#import "WebHelp.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppApi : NSObject

#pragma mark - process
+(instancetype) sharedManager;

#pragma mark - api
- (void)getManWithCompletion:(RequestCompletion)completion;
- (void)getFriend1WithCompletion:(RequestCompletion)completion;
- (void)getFriend2WithCompletion:(RequestCompletion)completion;
- (void)getFriend3WithCompletion:(RequestCompletion)completion;
- (void)getFriend4WithCompletion:(RequestCompletion)completion;

@end



NS_ASSUME_NONNULL_END
