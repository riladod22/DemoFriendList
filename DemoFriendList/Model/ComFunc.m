//
//  ComFunc.m
//  DemoFriendList
//
//  Created by rafaelLee on 2019/9/4.
//

#import "ComFunc.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
//#import "UserMstr.h"
//#import "EncryptAndDecrypt.h"
//#import "DXAlertView.h"
//#import "zlib.h"

@implementation ComFunc

UIAlertController *statusAlert;
bool isAlerting;

//DES加密
+ (NSString *)desEncrypt:(NSString *)plainText DesKeyHex:(NSString *)desKeyHex {
    
    //plainText 空值的情況不跑加密流程
    if (!plainText || [plainText isEqualToString:@""] ) {
        return @"";
    }
    
    @try {
        
        CCCryptorStatus ccStatus = kCCSuccess;
        
        // Symmetric crypto reference.
        CCCryptorRef thisEncipher = NULL;
        
        // Cipher Text container.
        NSData * cipherOrPlainText = nil;
        
        // Pointer to output buffer.
        uint8_t * bufferPtr = NULL;
        
        // Total size of the buffer.
        size_t bufferPtrSize = 0;
        
        // Remaining bytes to be performed on.
        size_t remainingBytes = 0;
        
        // Number of bytes moved to buffer.
        size_t movedBytes = 0;
        
        // Length of plainText buffer.
        size_t plainTextBufferSize = 0;
        
        // Placeholder for total written.
        size_t totalBytesWritten = 0;
        
        // A friendly helper pointer.
        uint8_t * ptr;
        
        // Initialization vector; dummy in this case 0's.
        uint8_t iv[kCCBlockSizeAES128];
        
        memset((void *) iv, 0x0, (size_t) sizeof(iv));
        
        NSData *plainTextData = [plainText dataUsingEncoding: NSUTF8StringEncoding];
        plainTextBufferSize = [plainTextData length];
        
        NSData *desKeyData = [self hexToNSData:desKeyHex];
        
        // Create and Initialize the crypto reference.
        ccStatus = CCCryptorCreate(kCCEncrypt,
                                   kCCAlgorithmAES128,
                                   kCCOptionPKCS7Padding,
                                   (const void *) [desKeyData bytes],
                                   [desKeyData length],
                                   (const void *)iv, &thisEncipher);
        if (ccStatus==kCCSuccess) {
            //NSLog(@"Encrypt-CCCryptorCreate success!!");
        } else {
            
            NSException *exception = [NSException exceptionWithName: @"CCCryptoCreate" reason:  [NSString stringWithFormat:@"Err=%d", ccStatus] userInfo: nil];
            @throw exception;
        }
        
        // Calculate byte block alignment for all calls through to and including final.
        bufferPtrSize = CCCryptorGetOutputLength(thisEncipher, plainTextBufferSize, true);
        
        // Allocate buffer.
        bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t) );
        
        //1061023-null check
        if(bufferPtr== nil){
            return NULL;
        }
        // Zero out buffer.
        memset((void *)bufferPtr, 0x0, bufferPtrSize);
        
        // Initialize some necessary book keeping.
        ptr = bufferPtr;
        
        // Set up initial size.
        remainingBytes = bufferPtrSize;
        
        // Actually perform the encryption or decryption.
        ccStatus = CCCryptorUpdate( thisEncipher,(const void *) [plainTextData bytes], plainTextBufferSize,ptr,remainingBytes,&movedBytes);
        
        if (ccStatus==kCCSuccess) {
            //NSLog(@"Encrypt-CCCryptorUpdate success!!");
        } else {
            
            NSException *exception = [NSException exceptionWithName: @"CCCryptorUpdate" reason:  [NSString stringWithFormat:@"Err=%d", ccStatus] userInfo: nil];
            @throw exception;
        }
        
        // Handle book keeping.
        ptr += movedBytes;
        
        remainingBytes -= movedBytes;
        totalBytesWritten += movedBytes;
        
        // Finalize everything to the output buffer.
        ccStatus = CCCryptorFinal(thisEncipher,ptr,
                                  remainingBytes,&movedBytes);
        totalBytesWritten += movedBytes;
        
        if (thisEncipher) {
            (void) CCCryptorRelease(thisEncipher);
            thisEncipher = NULL;
        }
        
        if (ccStatus==kCCSuccess) {
            //NSLog(@"Encrypt-CCCryptorFinal Success!!");
        } else {
            
            NSException *exception = [NSException exceptionWithName: @"CCCryptorFinal" reason:  [NSString stringWithFormat:@"Err=%d", ccStatus] userInfo: nil];
            @throw exception;
            
        }
        
        //Set-Encrypted NSData
        cipherOrPlainText = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)totalBytesWritten];
        
        if (bufferPtr) {
            free(bufferPtr);
        }
        
        return [self nsDataToHex:cipherOrPlainText];
        
    } @catch (NSException *exception) {
        NSLog(@"desEncrypt error : %@", exception);
        return nil;
    } @finally {
        //Do nothing
    }
}

//DES解密
+ (NSString *)desDecrypt:(NSString *)enStr DesKeyHex:(NSString *)desKeyHex {
    
    //plainText 空值的情況不跑解密流程
    if (!enStr || [enStr isEqualToString:@""] ) {
        return @"";
    }
    
    @try {
        
        CCCryptorStatus ccStatus = kCCSuccess;
        
        // Symmetric crypto reference.
        CCCryptorRef thisEncipher = NULL;
        
        // Cipher Text container.
        NSData * cipherOrPlainText = nil;
        
        // Pointer to output buffer.
        uint8_t * bufferPtr = NULL;
        
        // Total size of the buffer.
        size_t bufferPtrSize = 0;
        
        // Remaining bytes to be performed on.
        size_t remainingBytes = 0;
        
        // Number of bytes moved to buffer.
        size_t movedBytes = 0;
        
        // Length of plainText buffer.
        size_t plainTextBufferSize = 0;
        
        // Placeholder for total written.
        size_t totalBytesWritten = 0;
        
        // A friendly helper pointer.
        uint8_t * ptr;
        
        // Initialization vector; dummy in this case 0's.
        uint8_t iv[kCCBlockSizeAES128];
        
        memset((void *) iv, 0x0, (size_t) sizeof(iv));
        
        NSData *encryptedData = [self hexToNSData:enStr];
        plainTextBufferSize = [encryptedData length];
        
        NSData *desKeyData = [self hexToNSData:desKeyHex];
        
        // Create and Initialize the crypto reference.
        ccStatus = CCCryptorCreate(kCCDecrypt,
                                   kCCAlgorithmAES128,
                                   kCCOptionPKCS7Padding,
                                   (const void *)[desKeyData bytes],
                                   [desKeyData length],
                                   (const void *)iv, &thisEncipher);
        if (ccStatus==kCCSuccess) {
            //NSLog(@"Decrypt-CCCryptorCreate success!!");
        } else {
            
            NSException *exception = [NSException exceptionWithName: @"CCCryptorCreate" reason:  [NSString stringWithFormat:@"Err=%d", ccStatus] userInfo: nil];
            @throw exception;
        }
        
        // Calculate byte block alignment for all calls through to and including final.
        bufferPtrSize = CCCryptorGetOutputLength(thisEncipher,
                                                 plainTextBufferSize,
                                                 true);
        
        // Allocate buffer.
        bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t) );
        
        //1061023-null check
        if(bufferPtr == nil){
            return NULL;
        }
        
        // Zero out buffer.
        memset((void *)bufferPtr, 0x0, bufferPtrSize);
        
        // Initialize some necessary book keeping.
        ptr = bufferPtr;
        
        // Set up initial size.
        remainingBytes = bufferPtrSize;
        
        // Actually perform the encryption or decryption.
        ccStatus = CCCryptorUpdate(thisEncipher,
                                   (const void *) [encryptedData bytes],
                                   plainTextBufferSize,
                                   ptr,
                                   remainingBytes,
                                   &movedBytes);
        
        if (ccStatus==kCCSuccess) {
            //NSLog(@"Decrypt-CCCryptorUpdate success!!");
        } else {
            
            NSException *exception = [NSException exceptionWithName: @"CCCryptorUpdate" reason:  [NSString stringWithFormat:@"Err=%d", ccStatus] userInfo: nil];
            @throw exception;
        }
        
        // Handle book keeping.
        ptr += movedBytes;
        
        remainingBytes -= movedBytes;
        totalBytesWritten += movedBytes;
        
        // Finalize everything to the output buffer.
        ccStatus = CCCryptorFinal(thisEncipher,ptr,
                                  remainingBytes,&movedBytes);
        totalBytesWritten += movedBytes;
        
        if (thisEncipher) {
            (void) CCCryptorRelease(thisEncipher);
            thisEncipher = NULL;
        }
        
        if (ccStatus==kCCSuccess) {
            //NSLog(@"Decrypt-CCCryptorFinal Success!!");
        } else {
            
            NSException *exception = [NSException exceptionWithName: @"CCCryptorFinal" reason:  [NSString stringWithFormat:@"Err=%d", ccStatus] userInfo: nil];
            @throw exception;
        }
        
        //Set-Decrypt Data
        cipherOrPlainText = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)totalBytesWritten];
        
        if (bufferPtr) {
            free(bufferPtr);
        }
        
        return [[NSString alloc] initWithData:cipherOrPlainText encoding:NSUTF8StringEncoding];;
    } @catch (NSException *exception) {
        NSLog(@"desDecrypt error : %@", exception);
        return nil;
    } @finally {
        //Do nothing
    }
}

+(NSData *) hexToNSData: (NSString *) hexString {
    
    @try {
        if (!hexString || !hexString.length) {
            return NULL;
        }
        
        // Get the c string
        const char *scanner=[hexString cStringUsingEncoding:NSUTF8StringEncoding];
        char twoChars[3]={0,0,0};
        long bytesBlockSize = hexString.length/2;
        long counter = bytesBlockSize;
        Byte *bytesBlock = malloc(bytesBlockSize);
        
        if (!bytesBlock) {
            return NULL;
        }
        
        Byte *writer = bytesBlock;
        while (counter--) {
            twoChars[0]=*scanner++;
            twoChars[1]=*scanner++;
            *writer++ = strtol(twoChars, NULL, 16);
        }
        return[NSData dataWithBytesNoCopy:bytesBlock length:bytesBlockSize freeWhenDone:YES];
    } @catch (NSException *exception) {
        NSLog(@"hexToNSData error : %@", exception);
        return NULL;
    } @finally {
        //..
    }
}

+ (NSString *) nsDataToHex:(NSData *) nsData {
    
    @try {
        const unsigned char *dbytes = [nsData bytes];
        
        NSMutableString *hexStr =
        [NSMutableString stringWithCapacity:[nsData length]*2];
        
        int i;
        for (i = 0; i < [nsData length]; i++) {
            [hexStr appendFormat:@"%02X", dbytes[i]];
        }
        
        return [NSString stringWithString: hexStr];
    } @catch (NSException *exception) {
        NSLog(@"nsDataToHex error : %@", exception);
        return nil;
    } @finally {
    }
}

+ (nullable id)jsonStringToObj:(NSString *)jStr {
    //Json String 轉 NSDictionary or NSArray
    
    id result;
    
    if (jStr) {
        result = [self jsonDataToObj:[jStr dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    return result;
}

+ (nullable id)jsonDataToObj:(NSData *)jData {
    //Json Data 轉 NSDictionary or NSArray
    
    id result;
    
    if (jData) {
        /*
         註這個option不適用 捨棄
        result = [NSJSONSerialization JSONObjectWithData:jData options:NSJSONReadingMutableContainers error:nil];
         */
        result = [NSJSONSerialization JSONObjectWithData:jData options:kNilOptions error:nil];
    }
    
    return result;
}

+ (NSDictionary *)itemValueArrayToDictionary:(NSArray *)arr {
    /*
     下行電文資料為@[@{@"Item":Item1, @"Value",Value1},@{@"Item":Item2, @"Value",Value2}, ... ]
     格式的場合，把它轉為@{@"Item1": Value1, @"Item2": Value2 ...}
     
     註1：有key重複的情況則保留第1筆
     註2：原資料key值非 @"Item" @"Value" 則不適用
     */
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *dic in arr) {
        NSString *key = dic[@"Item"] ? : @"";
        if(!result[key]){
            [result setObject:dic[@"Value"] ? : @"" forKey:key];
        }
    }
    
    return result;
}

//
+ (BOOL)isStringContainsEmoji:(NSString *)string {
    // 檢查所有表情符號。returnValue为NO表示不含有表情，YES表示含有表情
    
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        
        
        const unichar hs = [substring characterAtIndex:0];
        
        // surrogate pair
        
        if (0xd800 <= hs && hs <= 0xdbff) {
            
            if (substring.length > 1) {
                
                const unichar ls = [substring characterAtIndex:1];
                
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    
                    returnValue = YES;
                    
                }
                
            }
            
        } else if (substring.length > 1) {
            
            const unichar ls = [substring characterAtIndex:1];
            
            if (ls == 0x20e3) {
                
                returnValue = YES;
                
            }
            
        } else {
            
            // non surrogate
            
            if (0x2100 <= hs && hs <= 0x27ff) {
                
                returnValue = YES;
                
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                
                returnValue = YES;
                
            } else if (0x2934 <= hs && hs <= 0x2935) {
                
                returnValue = YES;
                
            } else if (0x3297 <= hs && hs <= 0x3299) {
                
                returnValue = YES;
                
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                
                returnValue = YES;
                
            }
            
        }
        
    }];
    
    return returnValue;
    
}

+ (BOOL)checkTextAvailable:(NSString *)str withRegix:(NSString *)reg{
    //檢查str是否符合reg的格式
    //NSString *IDNoRegex3 = @"[0-9]{8}[a-zA-Z][a-zA-Z]";
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
    return [regex evaluateWithObject:str];
}

+(NSDate*) convertDateFromString:(NSString*)uiDate withFormat:(NSString*)str
{
    /*字串轉日期 + 使用自訂格式*/
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:str];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

+(NSString*) convertStringFromDate:(NSDate*)dt withFormat:(NSString*)str
{
    /*日期轉字串 + 使用自訂格式*/
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:str];
    NSString *result = [formatter stringFromDate:dt];
    return result;
}

#pragma mark - views
+ (void)setViewMatchParent:(UIView *)vi {
    //subview 外圍對齊 superview
    
    if (vi && vi.superview){
        vi.translatesAutoresizingMaskIntoConstraints = NO;
        
        [vi.superview addConstraint:[NSLayoutConstraint
                                     constraintWithItem:vi
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:vi.superview
                                     attribute:NSLayoutAttributeLeading
                                     multiplier:1.0
                                     constant:0]];
        
        [vi.superview addConstraint:[NSLayoutConstraint
                                     constraintWithItem:vi
                                     attribute:NSLayoutAttributeTrailing
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:vi.superview
                                     attribute:NSLayoutAttributeTrailing
                                     multiplier:1.0
                                     constant:0]];
        
        [vi.superview addConstraint:[NSLayoutConstraint
                                     constraintWithItem:vi
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:vi.superview
                                     attribute:NSLayoutAttributeTop
                                     multiplier:1.0
                                     constant:0]];
        
        [vi.superview addConstraint:[NSLayoutConstraint
                                     constraintWithItem:vi
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:vi.superview
                                     attribute:NSLayoutAttributeBottom
                                     multiplier:1.0
                                     constant:0]];
    }
}

+ (void)setViewAlignCenter:(UIView *)vi {
    //subview 垂直置中
    
    if (vi && vi.superview){
        vi.translatesAutoresizingMaskIntoConstraints = NO;
        
        [vi.superview addConstraint:[NSLayoutConstraint
                                     constraintWithItem:vi
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:vi.superview
                                     attribute:NSLayoutAttributeCenterX
                                     multiplier:1.0
                                     constant:0]];
        
        [vi.superview addConstraint:[NSLayoutConstraint
                                     constraintWithItem:vi
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:vi.superview
                                     attribute:NSLayoutAttributeCenterY
                                     multiplier:1.0
                                     constant:0]];
    }
}

+ (void)displayAlert:(nonnull NSString *)msg title:(nullable NSString *)title yes:(nullable NSString *)yes no:(nullable NSString *)no andTarget:(nonnull UIViewController *)target andAction:(nullable SEL)action {
    //顯示讀取遮罩+訊息
    if ([NSThread isMainThread]) {
        [self runDisplayAlert:msg title:title yes:yes no:no andTarget:target andAction:action];
    } else {
        dispatch_sync(dispatch_get_main_queue(),^{
            [self runDisplayAlert:msg title:title yes:yes no:no andTarget:target andAction:action];
        });
    }
}

+ (void)runDisplayAlert:(nonnull NSString *)msg title:(nullable NSString *)title yes:(nullable NSString *)yes no:(nullable NSString *)no andTarget:(nonnull UIViewController *)target andAction:(nullable SEL)action {
    //訊息跳窗
    
    __block SEL selAction = action;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    //[self useLightUIStyle:alert];
    
    
    if (yes) {
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:yes style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            if (action) {
                
                [target performSelector:selAction withObject:nil];
            }
#pragma clang diagnostic pop
        }];
        [alert addAction:okAction];
    }
    
    if (no) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:no style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancelAction];
    }
    
    [target presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - devices
+ (NSString*) getUDID {
    NSUUID *uuid = [UIDevice currentDevice].identifierForVendor;
    NSString *suuid = [uuid UUIDString];
    
    return suuid;
}




@end
