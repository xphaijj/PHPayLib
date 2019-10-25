//
//  PHIapPay.m
//  App
//
//  Created by 項普華 on 2017/6/1.
//  Copyright © 2017年 項普華. All rights reserved.
//

#import "PHIapPay.h"
#import <StoreKit/StoreKit.h>
#import <YLT_BaseLib/YLT_BaseLib.h>
#import "PHPayErrorUtils.h"
#import "PHPayError.h"

@interface PHIapPay ()<SKPaymentTransactionObserver, SKProductsRequestDelegate> {
}
@property (nonatomic, strong) PHPayOrder *order;
@property (nonatomic, copy) PHPayComplation complation;
@property (nonatomic, strong) SKPaymentTransaction *paymentTransaction;//支付状态的处理
@end

@implementation PHIapPay

- (void)payWithOrder:(PHPayOrder *)payOrder target:(UIViewController *)target scheme:(NSString *)scheme complation:(PHPayComplation)complation {
    _complation = complation;
    _order = payOrder;

    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    if (![SKPaymentQueue canMakePayments]) {
        _complation(_order, [PHPayErrorUtils create:PHPayCodeErrorCall]);
        return;
    }
    
    NSSet *productSets = [NSSet setWithArray:@[payOrder.credential[@"iapid"]]];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productSets];
    request.delegate = self;
    [request start];
}

- (BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary *)options {
    return YES;
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray<SKDownload *> *)downloads {
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *tran in transactions) {
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchasing://商品添加进列表 购买中
            {
            }
                break;
            case SKPaymentTransactionStateDeferred://购买进入队列 等待外部的操作
            {
                _complation(_order, [PHPayErrorUtils create:PHPayCodeErrorUnknown]);
            }
                break;
            case SKPaymentTransactionStatePurchased://购买成功
            case SKPaymentTransactionStateRestored://已经购买了
            {
                _complation(_order, [PHPayErrorUtils create:PHPaySuccess]);
            }
                break;
            case SKPaymentTransactionStateFailed://购买失败
            {
                _complation(_order, [PHPayErrorUtils create:PHPayFailed]);
            }
                break;
            default:
                break;
        }
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSString *productID = _order.credential[@"iapid"];
    SKProduct *product = nil;
    for (SKProduct *pro in response.products) {
        if ([productID isEqualToString:pro.productIdentifier]) {
            product = pro;
        }
    }
    
    if (product) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else {
        YLT_LogError(@"%@", @"应用内购产品为空");
        _complation(_order, [PHPayErrorUtils create:PHPayCodeErrorParams]);
    }
}

- (void)requestDidFinish:(SKRequest *)request {
    YLT_Log(@"完成");
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    _complation(_order, [PHPayErrorUtils create:PHPayFailed]);
}


@end
