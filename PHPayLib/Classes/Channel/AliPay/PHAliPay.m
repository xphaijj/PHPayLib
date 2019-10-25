//
//  PHAliPay.m
//  PPDemo
//
//  Created by 項普華 on 2017/5/29.
//  Tel:(+86)13316987488  Mail:xiangpuhua@126.com
//  Tel:(+86)13316987488  Mail:xiangpuhua@126.com
//  Copyright © 2017年 項普華. All rights reserved.
//

#import "PHAliPay.h"
#import "PHPayErrorUtils.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <AlipaySDK/AlipaySDK.h>
#import <UIKit/UIKit.h>

@interface PHAliPay () {
}

@property (nonatomic, strong) PHPayOrder *order;
@property (nonatomic, copy) PHPayComplation complation;

@end

@implementation PHAliPay

- (void)payWithOrder:(PHPayOrder *)payOrder target:(UIViewController *)target scheme:(NSString *)scheme complation:(PHPayComplation)complation {
    _order = payOrder;
    _complation = complation;
    dispatch_async(dispatch_get_main_queue(), ^{
        @weakify(self);
        [[AlipaySDK defaultService] payOrder:self.order.orderString fromScheme:scheme callback:^(NSDictionary *resultDic) {
            @strongify(self);
            [self handleDictionary:resultDic];
        }];
    });
}

- (BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary *)options {
    if ([url.host isEqualToString:@"safepay"] || [url.host isEqualToString:@"platformapi"]) {//支付宝回调
        @weakify(self);
        //这个是进程KILL掉之后也会调用，这个只是第一次授权回调，同时也会返回支付信息
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            @strongify(self);
            [self handleDictionary:resultDic];
        }];
        //跳转支付宝钱包进行支付，处理支付结果，这个只是辅佐订单支付结果回调
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            @strongify(self);
            [self handleDictionary:resultDic];
        }];
    }
    
    return YES;
}

- (void)handleDictionary:(NSDictionary *)result {
    switch ([result[@"resultStatus"] integerValue]) {
        case 9000:
            _complation(_order, [PHPayErrorUtils create:PHPaySuccess]);
            break;
        case 4000:
            _complation(_order, [PHPayErrorUtils create:PHPayFailed]);
            break;
        case 6001:
            _complation(_order, [PHPayErrorUtils create:PHPayCodeCanceled]);
            break;
        case 8000:
        case 6002:
        case 6004:
            _complation(_order, [PHPayErrorUtils create:PHPayCodeErrorUnknown]);
            break;
        default:
            _complation(_order, [PHPayErrorUtils create:PHPayCodeErrorUnknown]);
            break;
    }
}


@end
