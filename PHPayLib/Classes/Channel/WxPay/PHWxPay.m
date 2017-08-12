//
//  PHWxPay.m
//  PPDemo
//
//  Created by 項普華 on 2017/5/29.
//  Tel:(+86)13316987488  Mail:xiangpuhua@126.com
//  Copyright © 2017年 項普華. All rights reserved.
//

#import "PHWxPay.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "PHPayErrorUtils.h"

@interface PHWxPay ()<WXApiDelegate> {
}

@property (nonatomic, strong) PHPayOrder *order;
@property (nonatomic, copy) PHPayComplation complation;

@end

@implementation PHWxPay

- (void)payWithOrder:(PHPayOrder *)payOrder target:(UIViewController *)target scheme:(NSString *)scheme complation:(PHPayComplation)complation {
    _order = payOrder;
    _complation = complation;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([WXApi registerApp:payOrder.credential[@"appid"]]) {
            NSDictionary *result = payOrder.credential;
            PayReq *req = [[PayReq alloc] init];
            req.partnerId = result[@"partnerid"];
            req.prepayId = result[@"prepayid"];
            req.nonceStr = result[@"noncestr"];
            req.timeStamp = (UInt32)[result[@"timestamp"] integerValue];
            req.package = result[@"package"];
            req.sign = result[@"sign"];
            [WXApi sendReq:req];
        }
        else {
            _complation(_order, [PHPayErrorUtils create:PHPayCodeWxRegisterFailed]);
        }
        
        
    });
}

- (BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary *)options {
    if ([url.host isEqualToString:@"pay"]) {
        [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        switch (resp.errCode) {
            case WXSuccess:
            {
                _complation(_order, [PHPayErrorUtils create:PHPaySuccess]);
            }
                break;
            case WXErrCodeUserCancel:
            {
                _complation(_order, [PHPayErrorUtils create:PHPayCodeCanceled]);
            }
                break;
            case WXErrCodeSentFail:
            {
                _complation(_order, [PHPayErrorUtils create:PHPayFailed]);
            }
                break;
            default:
            {
                _complation(_order, [PHPayErrorUtils create:PHPayCodeErrorUnknown]);
            }
                break;
        }
    }
}

- (void)onReq:(BaseReq *)req {
}


@end
