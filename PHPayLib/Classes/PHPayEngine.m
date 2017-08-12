//
//  PHPayEngine.m
//  PPDemo
//
//  Created by 項普華 on 2017/5/29.
//  Tel:(+86)13316987488  Mail:xiangpuhua@126.com
//  Copyright © 2017年 項普華. All rights reserved.
//

#import "PHPayEngine.h"
#import "PHUnionPay.h"
#import "PHAliPay.h"
#import "PHWxPay.h"
#import "PHApplePay.h"
#import "PHIapPay.h"
#import "PHPayMacro.h"
#import "PHPayErrorUtils.h"

@interface PHPayEngine () {
}
//支付渠道信息
@property (nonatomic, strong) NSDictionary *channelInfo;
@property (nonatomic, strong) PHPayOrder *payOrder;

@end

@implementation PHPayEngine

PH_ShareInstance(PHPayEngine);

- (void)ph_init {
    self.channelInfo = @{
                         PAY_UNIONPAY:[[PHUnionPay alloc] init],
                         PAY_WXPAY:[[PHWxPay alloc] init],
                         PAY_ALIPAY:[[PHAliPay alloc] init],
                         PAY_APPLE:[[PHApplePay alloc] init],
                         PAY_IAP:[[PHIapPay alloc] init]
                         };
}

- (void)payWithOrder:(PHPayOrder *)payOrder
              target:(UIViewController *)target
              scheme:(NSString *)scheme
          complation:(PHPayComplation)complation {
    if (complation == nil) {
        complation = ^(id response, PHPayError *error) {
            PHLog(@"%@  %@", response, error.errorMsg);
        };
    }
    if (payOrder == nil) {
        complation(@"订单参数为空", [PHPayErrorUtils create:PHPayCodeErrorParams]);
        return;
    }
    //校验本地是否集成了支付渠道
    if (![[PHPayEngine shareInstance].channelInfo.allKeys containsObject:payOrder.channel]) {
        complation(payOrder, [PHPayErrorUtils create:PHPayCodeInvalidChannel]);
        return;
    }
    
    //校验订单信息
    if (![PHPayErrorUtils invalidOrderInfo:payOrder complation:complation]) {
        return;
    }
    //检测当前target是否为空
    if (target == nil) {
        complation(payOrder, [PHPayErrorUtils create:PHPayCodeTargetIsNil]);
        return;
    }
    
    _payOrder = payOrder;
    id<PHPayProtocol> pay = [_channelInfo objectForKey:payOrder.channel];
    //再次校验本地是否集成了支付渠道
    if (pay == nil) {
        complation(payOrder, [PHPayErrorUtils create:PHPayCodeInvalidChannel]);
        return;
    }
    @try {
        //调用具体的实现
        [pay payWithOrder:payOrder target:target scheme:scheme complation:complation];
    } @catch (NSException *exception) {
        PHLogError(@"支付异常 %@", exception);
    } @finally {
    }
    
}

//回调的处理
- (BOOL)handleOpenURL:(NSURL *)url
              options:(NSDictionary *)options {
    return [[_channelInfo objectForKey:_payOrder.channel] handleOpenURL:url
                                                                options:options];
}


@end
