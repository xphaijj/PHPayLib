//
//  PHPayMacro.h
//  PPDemo
//
//  Created by 項普華 on 2017/5/29.
//  Tel:(+86)13316987488  Mail:xiangpuhua@126.com
//  Copyright © 2017年 項普華. All rights reserved.
//

#ifndef PHPayMacro_h
#define PHPayMacro_h

#import "PHPayError.h"


typedef void(^PHPayComplation)(id response, PHPayError *error);

#define PAY_WXPAY @"wxpay"
#define PAY_UNIONPAY @"unionpay"
#define PAY_ALIPAY @"alipay"
#define PAY_APPLE @"applepay"
#define PAY_IAP @"iappay"

#endif /* PHPayMacro_h */
