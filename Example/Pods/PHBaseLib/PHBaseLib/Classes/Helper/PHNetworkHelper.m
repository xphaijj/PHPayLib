//
//  PHNetworkHelper.m
//  App
//
//  Created by 項普華 on 2017/6/18.
//  Copyright © 2017年 項普華. All rights reserved.
//

#import "PHNetworkHelper.h"
#import "PHNetworkProtocol.h"
#import "PHTools.h"

@implementation PHNetworkHelper

PH_ShareInstance(PHNetworkHelper);

- (void)ph_init {
}

+ (void)ph_monitorNetworkStatus {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [PHNetworkHelper shareInstance].status = status;
        id vc = PH_CurrentVC();
        if ([vc respondsToSelector:@selector(ph_networkStatus:)]) {
            [vc ph_networkStatus:status];
        }
    }];
}

@end
