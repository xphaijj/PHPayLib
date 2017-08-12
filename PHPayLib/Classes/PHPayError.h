//
//  PHPayError.h
//  PPDemo
//
//  Created by 項普華 on 2017/5/29.
//  Tel:(+86)13316987488  Mail:xiangpuhua@126.com
//  Copyright © 2017年 項普華. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PHPayCode) {
    //渠道信息验证失败
    PHPayCodeInvalidChannel,
    //支付参数异常
    PHPayCodeErrorParams,
    //time out
    PHPayCodeErrorTimeOut,
    //connect异常
    PHPayCodeErrorConnection,
    //target目标为空
    PHPayCodeTargetIsNil,
    //调起支付方式失败
    PHPayCodeErrorCall,
    
    //取消支付
    PHPayCodeCanceled,
    //支付成功
    PHPaySuccess,
    //支付失败
    PHPayFailed,
    
    //微信未安装
    PHPayCodeWxNoInstalled,
    //微信appid注册失败
    PHPayCodeWxRegisterFailed,
    
    //未知异常
    PHPayCodeErrorUnknown,
};

@interface PHPayError : NSObject

@property (nonatomic, assign) PHPayCode errorCode;

- (NSString *)errorMsg;

@end
