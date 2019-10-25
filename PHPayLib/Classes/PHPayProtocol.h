//
//  PHPayProtocol.h
//  PPDemo
//
//  Created by 項普華 on 2017/5/21.
//  Tel:(+86)13316987488  Mail:xiangpuhua@126.com
//  Copyright © 2017年 項普華. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YLT_BaseLib/YLT_BaseLib.h>
#import "PHPayOrder.h"
#import "PHPayMacro.h"

@protocol PHPayProtocol <NSObject>

/**
 支付需要实现的方法

 @param payOrder 服务端返回数据组合成的订单信息
 @param target 当前调用的Target
 @param scheme URLScheme
 @param complation 回调
 */
- (void)payWithOrder:(PHPayOrder *)payOrder
              target:(UIViewController *)target
              scheme:(NSString *)scheme
          complation:(PHPayComplation)complation;

/**
 支付结果的回调

 @param url 回调的URL
 @param options 可选参数
 @return 是否处理成功
 */
- (BOOL)handleOpenURL:(NSURL *)url
              options:(NSDictionary *)options;

@end
