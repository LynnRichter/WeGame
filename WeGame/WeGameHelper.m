//
//  WeGameHelper.m
//  WeGame
//
//  Created by Lynnrichter on 14/12/23.
//  Copyright (c) 2014年 tencent. All rights reserved.
//

#import "WeGameHelper.h"

@implementation WeGameHelper

//+(NSDictionary *)GetData:(NSString *)URLStr Parameter:(NSDictionary *)para
//{
//    __block NSDictionary * dict = [[NSDictionary alloc] init];
//    
//    @try {
//        
//      
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        //  根据自己的服务器来设定 text/plain或其它
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//        // GET请求
//        [manager GET: [URLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters: para success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            //  请求成功时的操作
//            NSString *html = operation.responseString;
//            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
//            dict=(NSDictionary*)[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
//            NSLog(@"info = %@",[dict objectForKey:@"info"]);
//            NSLog(@"%@",dict);
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//            NSLog(@"请求失败:%@",error);
//        }];
//        
//        
//    }
//    @catch (NSException *exception) {
//        NSLog(@"发生异常问题:%@",[exception description]);
//    }
//    @finally {
//        return dict;
//    }
//   
//}
//+(NSDictionary *)PostData:(NSString *)URLStr Parameter:(NSDictionary *)para
//{
//    __block NSDictionary * dict = [[NSDictionary alloc] init];
//    
//    @try {
//        
//        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        //  根据自己的服务器来设定 text/plain或其它
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//        // GET请求
//        [manager POST: [URLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters: para success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            //  请求成功时的操作
//            NSString *html = operation.responseString;
//            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
//            dict=(NSDictionary*)[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
//            NSLog(@"info = %@",[dict objectForKey:@"info"]);
//            NSLog(@"%@",dict);
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//            NSLog(@"请求失败:%@",error);
//        }];
//        
//        
//    }
//    @catch (NSException *exception) {
//        NSLog(@"发生异常问题:%@",[exception description]);
//    }
//    @finally {
//        return dict;
//    }
//    
//}
//
//

//+ (NSString *) hmacSha1: (NSString*)decode
//{
//    const char *cKey  = [KEY cStringUsingEncoding:NSUTF8StringEncoding];
//    const char *cData = [decode cStringUsingEncoding:NSUTF8StringEncoding];
//    
//    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
//    
//    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
//    
//    //NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
//    NSString *hash;
//    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
//    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
//        [output appendFormat:@"%02x", cHMAC[i]];
//    hash = output;
//    
//    return hash;
//}
+ (NSString *)hmac_sha1:(NSString *)decode{
    
    const char *cKey  = [KEY cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [decode cStringUsingEncoding:NSUTF8StringEncoding];
    
    char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    NSString *hash = [HMAC base64Encoding];//base64Encoding函数在NSData+Base64中定义（NSData+Base64网上有很多资源）
    return hash;
}


+ (void)saveString:(NSString *)value key:(NSString *)keyValue
{
    NSUserDefaults *manager=[NSUserDefaults standardUserDefaults];
    [manager setValue:value forKey:keyValue ];
    [manager synchronize];
}
+ (NSString *)getString:(NSString *)key
{
    NSUserDefaults *manager=[NSUserDefaults standardUserDefaults];
    
    NSString *ret  = [NSString stringWithFormat:@"%@",[manager objectForKey:key]];
    return ret;
}
+ (BOOL)getLogin
{
    NSUserDefaults *manager=[NSUserDefaults standardUserDefaults];
    BOOL ret  = [manager boolForKey:@"login"];
    return ret;
}
+ (void)setLogin:(BOOL)value
{
    NSUserDefaults *manager=[NSUserDefaults standardUserDefaults];
    [manager setBool:value forKey:@"login"];
    [manager synchronize];
}
+(int)intervalSinceNow: (NSDate *) theDate
{
    
   
    
    NSTimeInterval late=[theDate timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    

    timeString = [NSString stringWithFormat:@"%f", cha/86400];
    timeString = [timeString substringToIndex:timeString.length-7];
    NSLog(@"日期差别:%@",timeString);
    return [timeString intValue] ;

}

@end

