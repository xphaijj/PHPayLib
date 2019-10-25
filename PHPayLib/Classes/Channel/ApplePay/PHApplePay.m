//
//  PHApplePay.m
//  App
//
//  Created by 項普華 on 2017/6/1.
//  Copyright © 2017年 項普華. All rights reserved.
//

#import "PHApplePay.h"
#import <PassKit/PassKit.h>
#import "PHPayErrorUtils.h"
#import "PHPayUtils.h"

@interface PHApplePay ()<PKPaymentAuthorizationViewControllerDelegate> {
}
@property (nonatomic, strong) PHPayOrder *order;
@property (nonatomic, copy) PHPayComplation complation;

@end


@implementation PHApplePay

- (void)payWithOrder:(PHPayOrder *)payOrder target:(UIViewController *)target scheme:(NSString *)scheme complation:(PHPayComplation)complation {
    _complation = complation;
    _order = payOrder;
    
    if (![PKPaymentAuthorizationController canMakePayments]) {
        _complation(_order, [PHPayErrorUtils create:PHPayCodeErrorCall]);
        return;
    }
    
    PKPaymentRequest *payRequest = [[PKPaymentRequest alloc] init];
    PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:_order.shopName amount:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f", ((CGFloat) [_order.amount floatValue])/100.]]];
    payRequest.paymentSummaryItems = @[total];
    payRequest.currencyCode = @"CNY";
    payRequest.countryCode = @"CN";
    payRequest.merchantIdentifier = _order.credential[@"merchantIdentifier"];
    payRequest.merchantCapabilities = PKMerchantCapability3DS | PKMerchantCapabilityEMV | PKMerchantCapabilityCredit | PKMerchantCapabilityDebit;
    
    // 支持哪种结算网关
    payRequest.supportedNetworks = @[PKPaymentNetworkChinaUnionPay];
    PKPaymentAuthorizationViewController *vc = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:payRequest];
    vc.delegate = self;
    
    [target presentViewController:vc animated:YES completion:NULL];
}

-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectShippingContact:(PKContact *)contact completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKShippingMethod *> * _Nonnull, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion {
    YLT_Log(@"didSelectShippingContact");
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                   didSelectShippingMethod:(PKShippingMethod *)shippingMethod
                                completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion {
    YLT_Log(@"didSelectShippingMethod");
}

- (void)paymentAuthorizationViewControllerWillAuthorizePayment:(PKPaymentAuthorizationViewController *)controller {
    YLT_Log(@"paymentAuthorizationViewControllerWillAuthorizePayment");
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    if (payment.token && [PHPayUtils validString:payment.token.transactionIdentifier]) {
        _complation(_order, [PHPayErrorUtils create:PHPaySuccess]);
    }
    completion(PKPaymentAuthorizationStatusSuccess);
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [controller dismissViewControllerAnimated:controller completion:NULL];
}


- (BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary *)options {
    return YES;
}



@end
