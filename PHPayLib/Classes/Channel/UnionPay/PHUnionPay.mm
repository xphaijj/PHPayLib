//
//  PHUnionPay.m
//  PPDemo
//
//  Created by 項普華 on 2017/5/29.
//  Tel:(+86)13316987488  Mail:xiangpuhua@126.com
//  Copyright © 2017年 項普華. All rights reserved.
//

#import "PHUnionPay.h"
#import "UPPaymentControl.h"
#import "PHPayErrorUtils.h"

@interface PHUnionPay () {
}

@property (nonatomic, strong) PHPayOrder *order;
@property (nonatomic, copy) PHPayComplation complation;

@end

@implementation PHUnionPay

//银联支付的调用
- (void)payWithOrder:(PHPayOrder *)payOrder
              target:(UIViewController *)target
              scheme:(NSString *)scheme
          complation:(PHPayComplation)complation {
    _order = payOrder;
    _complation = complation;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *tn = [payOrder.credential objectForKey:@"tn"];
        NSString *mode = [payOrder.credential objectForKey:@"mode"];
        BOOL isSuccess = [[UPPaymentControl defaultControl] startPay:tn fromScheme:scheme mode:mode viewController:target];
        if (!isSuccess) {
            _complation(_order, [PHPayErrorUtils create:PHPayCodeErrorCall]);
        }
    });
}

- (BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary *)options {
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        if ([code isEqualToString:@"success"]) {
            _complation(_order, [PHPayErrorUtils create:PHPaySuccess]);
        }
        else if ([code isEqualToString:@"fail"]) {
            _complation(_order, [PHPayErrorUtils create:PHPayFailed]);
        }
        else if ([code isEqualToString:@"cancel"]) {
            _complation(_order, [PHPayErrorUtils create:PHPayCodeCanceled]);
        }
        else {
            _complation(_order, [PHPayErrorUtils create:PHPayCodeErrorUnknown]);
        }
    }];
    return YES;
}








@end
