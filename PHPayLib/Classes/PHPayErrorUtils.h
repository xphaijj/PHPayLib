//
//  PHPayErrorUtils.h
//  PPDemo
//
//  Created by 項普華 on 2017/5/29.
//  Tel:(+86)13316987488  Mail:xiangpuhua@126.com
//  Copyright © 2017年 項普華. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHPayError.h"
#import "PHPayMacro.h"
#import "PHPayOrder.h"

@interface PHPayErrorUtils : NSObject

/**
 异常信息的创建
 
 @param code 异常Code
 @return 异常信息
 */
+ (PHPayError *)create:(PHPayCode)code;


/**
 支付订单信息校验
 
 @param orderInfo 订单信息
 @param complation 回调
 @return 校验是否成功
 */
+ (BOOL)invalidOrderInfo:(PHPayOrder *)orderInfo
              complation:(PHPayComplation)complation;


@end
