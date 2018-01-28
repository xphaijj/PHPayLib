//
//  PHNetworkHelper.h
//  App
//
//  Created by 項普華 on 2017/6/18.
//  Copyright © 2017年 項普華. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "PHMacro.h"

@interface PHNetworkHelper : NSObject

PH_ShareInstanceHeader(PHNetworkHelper);


/**
 获取网络状态
 */
@property (nonatomic, assign) AFNetworkReachabilityStatus status;

#pragma mark -- 网络相关
/**
 监听网络状态的变化
 */
+ (void)ph_monitorNetworkStatus;

@end


#define WIFI ([PHNetworkHelper shareInstance].status == AFNetworkReachabilityStatusReachableViaWiFi)
#define WWAN ([PHNetworkHelper shareInstance].status == AFNetworkReachabilityStatusReachableViaWWAN)






