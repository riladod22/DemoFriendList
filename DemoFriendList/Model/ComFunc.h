//
//  ComFunc.h
//  DemoFriendList
//
//  Created by rafaelLee on 2019/9/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// RGB顏色轉換（16進制->10進制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define intToStr(val) [NSString stringWithFormat:@"%d",val]

NS_ASSUME_NONNULL_BEGIN

@interface ComFunc : NSObject
+ (NSString *)desEncrypt:(NSString *)plainText DesKeyHex:(NSString *)desKeyHex;//DES加密
+ (NSString *)desDecrypt:(NSString *)enStr DesKeyHex:(NSString *)desKeyHex;//DES解密
+ (NSData *) hexToNSData: (NSString *) hexString;
+ (NSString *) nsDataToHex:(NSData *) nsData;
+ (nullable id)jsonStringToObj:(NSString *)jStr;
+ (nullable id)jsonDataToObj:(NSData *)jData;
+ (NSDictionary *)itemValueArrayToDictionary:(NSArray *)arr;
+ (BOOL)isStringContainsEmoji:(NSString *)string;
+ (BOOL)checkTextAvailable:(NSString *)str withRegix:(NSString *)reg;
+(NSDate*) convertDateFromString:(NSString*)uiDate withFormat:(NSString*)str;
+(NSString*) convertStringFromDate:(NSDate*)dt withFormat:(NSString*)str;

#pragma mark - views
+ (void)setViewMatchParent:(UIView *)vi;
+ (void)setViewAlignCenter:(UIView *)vi;
//+ (void)DisplayAlert:(nonnull NSString *)Msg title:(nullable NSString *)Title yes:(nullable NSString *)Yes no:(nullable NSString *)No andTarget:(nonnull UIViewController *)target andAction:(nullable SEL)action ;//訊息跳窗
+ (void)displayAlert:(nonnull NSString *)msg title:(nullable NSString *)title yes:(nullable NSString *)yes no:(nullable NSString *)no andTarget:(nonnull UIViewController *)target andAction:(nullable SEL)action;//訊息跳窗

#pragma mark - devices
+ (NSString*) getUDID ;
    

@end

NS_ASSUME_NONNULL_END
