//
//  WebHelp.h
//  DemoFriendList
//
//  Created by rafaelLee on 2019/10/1.
//

#import <Foundation/Foundation.h>
#import "ComFunc.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^RequestCompletion)(id _Nullable data, NSError * _Nullable error);
//typedef void (^RequestCompletion)(id _Nullable data, NSString * _Nullable error);

@interface WebHelp : NSObject
@property (strong, nonatomic) NSString *urlApi;

+(instancetype) sharedManager;

//query by GET
- (void)getHttpRequest:(NSDictionary*)dic method:(NSString*)method withCompletion:(RequestCompletion)completion;

@end

NS_ASSUME_NONNULL_END
