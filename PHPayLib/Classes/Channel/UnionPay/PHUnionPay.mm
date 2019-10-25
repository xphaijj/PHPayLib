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
#import <ReactiveObjC/ReactiveObjC.h>

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
    
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *tn = [payOrder.credential objectForKey:@"tn"];
        NSString *mode = [payOrder.credential objectForKey:@"mode"];
        BOOL isSuccess = [[UPPaymentControl defaultControl] startPay:tn fromScheme:scheme mode:mode viewController:target];
        @strongify(self);
        if (!isSuccess) {
            self.complation(self.order, [PHPayErrorUtils create:PHPayCodeErrorCall]);
        }
    });
}

- (BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary *)options {
    @weakify(self);
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        @strongify(self);
        if ([code isEqualToString:@"success"]) {
            self.complation(self.order, [PHPayErrorUtils create:PHPaySuccess]);
        }
        else if ([code isEqualToString:@"fail"]) {
            self.complation(self.order, [PHPayErrorUtils create:PHPayFailed]);
        }
        else if ([code isEqualToString:@"cancel"]) {
            self.complation(self.order, [PHPayErrorUtils create:PHPayCodeCanceled]);
        }
        else {
            self.complation(self.order, [PHPayErrorUtils create:PHPayCodeErrorUnknown]);
        }
    }];
    return YES;
}








@end
