
//
//  Additions.h
//
//
//  Created by 王会洲 on 16/2/19.
//  Copyright © 2016年 王会洲. All rights reserved.
//


#import "UPPaymentControl.h"



#define pay_dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define pay_dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#ifndef pay_dispatch_main_async_safe
#define pay_dispatch_main_async_safe(block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
#endif

/*
 测试地址
 https://open.unionpay.com/ajweb/product/detail?id=3
 
 测试银行卡号和手机号码+验证码
 测试商户号：
 
 在本网站申请账号后，会自动分配一个测试商户号(777开头)，如已签约，则可以直接使用签约商户号进行测试。
 
 测试卡信息：
 
 卡号                              卡性质    机构名称    手机号码            密码    CVN2    有效期    证件号                        姓名
 6216261000000000018    借记卡    平安银行    13552535506    123456                         341126197709218366    全渠道
 
 6221558812340000       贷记卡    平安银行    13552535506     123456    123    1711       341126197709218366    互联网
 短信验证码    111111 （需要点击 获取验证码后再填入，否则会验证失败） 123456（手机控件场景）
 */






