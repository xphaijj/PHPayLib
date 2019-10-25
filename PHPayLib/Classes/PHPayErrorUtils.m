
//
//  PHPayErrorUtils.m
//  PPDemo
//
//  Created by 項普華 on 2017/5/29.
//  Tel:(+86)13316987488  Mail:xiangpuhua@126.com
//  Copyright © 2017年 項普華. All rights reserved.
//

#import "PHPayErrorUtils.h"
#import <YLT_BaseLib/YLT_BaseLib.h>

@implementation PHPayErrorUtils

+ (PHPayError *)create:(PHPayCode)code {
    PHPayError *error = [[PHPayError alloc] init];
    error.errorCode = code;
#if DEBUG
    switch (code) {
        case PHPayCodeInvalidChannel: {
            YLT_LogError(@"渠道信息验证失败");
        }
            break;
        case PHPayCodeErrorParams: {
            YLT_LogError(@"支付参数异常");
        }
            break;
        case PHPayCodeErrorTimeOut: {
            YLT_LogError(@"支付超时");
        }
            break;
        case PHPayCodeErrorConnection: {
            YLT_LogError(@"链接异常");
        }
            break;
        case PHPayCodeTargetIsNil: {
            YLT_LogError(@"target目标为空");
        }
            break;
        case PHPayCodeErrorCall: {
            YLT_LogError(@"调起支付方式失败");
        }
            break;

        case PHPayCodeCanceled: {
            YLT_LogWarn(@"取消支付");
        }
            break;
        case PHPaySuccess: {
            YLT_LogWarn(@"支付成功");
        }
            break;
        case PHPayFailed: {
            YLT_LogError(@"支付失败");
        }
            break;
        case PHPayCodeWxNoInstalled: {
            YLT_LogWarn(@"微信未安装");
        }
            break;
        case PHPayCodeWxRegisterFailed: {
            YLT_LogError(@"微信appid注册失败");
        }
            break;
        case PHPayCodeErrorUnknown: {
            YLT_LogError(@"未知异常");
        }
            break;
            
        default:
            break;
    }
#endif
    return error;
}

/**
 支付订单信息校验
 
 @param orderInfo 订单信息
 @param complation 回调
 @return 校验是否成功
 */
+ (BOOL)invalidOrderInfo:(PHPayOrder *)orderInfo
              complation:(PHPayComplation)complation {
#warning 这里可以添加上很多对订单信息校验的错误 --后期完善
    
    switch (orderInfo.failCode) {
        case 1:
            return YES;
            break;
        case 2:
            complation(orderInfo, [PHPayErrorUtils create:PHPayCodeErrorParams]);
            return NO;
            break;
        case 3:
            complation(orderInfo, [PHPayErrorUtils create:PHPayCodeErrorParams]);
            return NO;
            break;
        case 4:
            complation(orderInfo, [PHPayErrorUtils create:PHPayCodeErrorParams]);
            return NO;
            break;
            
        default:
            break;
    }

    complation(orderInfo, [PHPayErrorUtils create:PHPayCodeErrorParams]);
    return NO;
}


@end
