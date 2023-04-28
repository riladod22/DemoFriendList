//
//  WebHelp.m
//  DemoFriendList
//
//  Created by rafaelLee on 2019/10/1.
//

#import "WebHelp.h"
#import "AppProperties.h"

@interface WebHelp ()
@end

@implementation WebHelp
+(instancetype) sharedManager{
    static WebHelp* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance==nil) {
            instance = [[WebHelp alloc] init];
            
            instance.urlApi = kAppUrlApi;
        }
    });

    return instance;
}


//query by GET
- (void)getHttpRequest:(NSDictionary*)dic method:(NSString*)method withCompletion:(RequestCompletion)completion{

    NSString *command = [NSString stringWithFormat:@"%@/%@", self.urlApi, method];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[command stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
    
    //Set-Post
    [request setHTTPMethod:@"GET"];
    //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    //
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    //[config setTLSMinimumSupportedProtocol:kTLSProtocol12];
    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    config.URLCache = nil;
    
    //Set-sessionDataTask
    NSURLSession *session=[NSURLSession sessionWithConfiguration:config  delegate:nil delegateQueue:[[NSOperationQueue alloc] init]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //Set-Has Response Data
        
        completion(data, error);
        
        
        // end
    }];
    
    [dataTask resume];
    
}
 
/*
//query by POST
-(void)postHttpRequest:(NSString *)strParameter method:(NSString*)method withCompletion:(RequestCompletion)completion{

    NSString *command = [NSString stringWithFormat:@"%@/%@", self.urlApi, method];
    NSData *dtBody = [NSData dataWithBytes:[strParameter UTF8String] length:[strParameter length]];//str to data
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[command stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
    
    //Set-Post
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:dtBody];
    
    //
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    [config setTLSMinimumSupportedProtocol:kTLSProtocol12];
    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    config.URLCache = nil;
    
    //Set-sessionDataTask
    NSURLSession *session=[NSURLSession sessionWithConfiguration:config  delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //Set-Has Response Data
        
        //typedef void (^RequestCompletion)(id _Nullable data, NSURLSessionTask *task ,NSError * _Nullable error);
        completion(data, error);
        
        
        // end
    }];
    
    [dataTask resume];
    

    NSLog(@"🔥🔥 POST = %@",command);

}
*/

@end
