//
//  PHPayUtils.h
//  PayTest
//
//  Created by user on 16/8/16.
//  Copyright © 2016年 phxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSigner.h"
#import "DataVerifier.h"

@interface PHPayUtils : NSObject

/**
 *  MD5加密字符串
 *
 *  @param sender 源字符串
 *
 *  @return 生成的字符串
 */
+ (NSString *)MD5:(NSString *)sender;

/**
 *  判断字符串的有效性
 *
 *  @param sender 字符串
 *
 *  @return 字符串的有效性
 */
+ (BOOL)validString:(NSString *)sender;

/**
 *  订单信息加密 支付宝
 *
 *  @param orderInfo 订单信息
 *
 *  @return 加密信息
 */
+ (NSString*)doRsa:(NSString*)orderInfo;

@end
