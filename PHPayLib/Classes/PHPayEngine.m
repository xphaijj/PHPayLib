//
//  PHPayEngine.m
//  PPDemo
//
//  Created by 項普華 on 2017/5/29.
//  Tel:(+86)13316987488  Mail:xiangpuhua@126.com
//  Copyright © 2017年 項普華. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import "PHPayEngine.h"
#import "PHPayMacro.h"
#import "PHPayErrorUtils.h"

@interface PHPayEngine () {
}
//支付渠道信息
@property (nonatomic, strong) NSMutableDictionary *channelInfo;
@property (nonatomic, strong) PHPayOrder *payOrder;

@end

@implementation PHPayEngine

YLT_ShareInstance(PHPayEngine);

- (void)ph_init {
    self.channelInfo = [[NSMutableDictionary alloc] init];
    NSArray<NSDictionary *> *channels = @[
                                            @{PAY_UNIONPAY:@"PHUnionPay"},
                                            @{PAY_WXPAY:@"PHWxPay"},
                                            @{PAY_ALIPAY:@"PHAliPay"},
                                            @{PAY_APPLE:@"PHApplePay"},
                                            @{PAY_IAP:@"PHIapPay"}];
    [channels enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = obj.allKeys.firstObject;
        NSString *value = obj.allValues.firstObject;
        Class cls = NSClassFromString(value);
        if (cls != NULL) {
            [self.channelInfo setObject:[[cls alloc] init] forKey:key];
        }
    }];
}

- (void)payWithOrder:(PHPayOrder *)payOrder
              target:(UIViewController *)target
              scheme:(NSString *)scheme
          complation:(PHPayComplation)complation {
    if (complation == nil) {
        complation = ^(id response, PHPayError *error) {
            YLT_LogError(@"%@  %@", response, error.errorMsg);
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
        YLT_LogError(@"支付异常 %@", exception);
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
