//
//  PHPayError.m
//  PPDemo
//
//  Created by 項普華 on 2017/5/29.
//  Tel:(+86)13316987488  Mail:xiangpuhua@126.com
//  Copyright © 2017年 項普華. All rights reserved.
//

#import "PHPayError.h"

@interface PHPayError ()

@property (nonatomic, strong) NSMutableDictionary *errorConfig;

@end

@implementation PHPayError

- (id)init {
    self = [super init];
    if (self) {
        _errorConfig = [[NSMutableDictionary alloc] init];
        [_errorConfig setObject:@"支付成功" forKey:@(PHPaySuccess)];
        [_errorConfig setObject:@"支付失败" forKey:@(PHPayFailed)];
        [_errorConfig setObject:@"支付渠道验证失败" forKey:@(PHPayCodeInvalidChannel)];
        [_errorConfig setObject:@"支付参数异常" forKey:@(PHPayCodeErrorParams)];
        [_errorConfig setObject:@"当前TARGET为空" forKey:@(PHPayCodeTargetIsNil)];
        [_errorConfig setObject:@"链接异常" forKey:@(PHPayCodeErrorConnection)];
        [_errorConfig setObject:@"请求超时" forKey:@(PHPayCodeErrorTimeOut)];
        [_errorConfig setObject:@"支付取消" forKey:@(PHPayCodeCanceled)];
        [_errorConfig setObject:@"未知异常" forKey:@(PHPayCodeErrorUnknown)];
        [_errorConfig setObject:@"微信未安装" forKey:@(PHPayCodeWxNoInstalled)];
        [_errorConfig setObject:@"微信Appid注册失败" forKey:@(PHPayCodeWxRegisterFailed)];
        [_errorConfig setObject:@"应用调起失败" forKey:@(PHPayCodeErrorCall)];
    }
    return self;
}

- (void)setErrorCode:(PHPayCode)errorCode {
    _errorCode = errorCode;
}

- (NSString *)errorMsg {
    return [_errorConfig objectForKey:@(_errorCode)];
}

@end
