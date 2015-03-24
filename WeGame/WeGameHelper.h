//
//  WeGameHelper.h
//  WeGame
//
//  Created by Lynnrichter on 14/12/23.
//  Copyright (c) 2014年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking/AFNetworking.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import "PrefixHeader.pch"

@interface WeGameHelper : NSObject



//加密数据对接
+ (NSString *)hmac_sha1:(NSString *)decode;
+ (void)saveString:(NSString *)value key:(NSString *)keyValue;
+ (NSString *)getString:(NSString *)key;
+ (BOOL)getLogin;
+ (void)setLogin:(BOOL)value;
+(int)intervalSinceNow: (NSDate *) theDate;
@end
