//
//  PHNetworkProtocol.h
//  App
//
//  Created by 項普華 on 2017/6/18.
//  Copyright © 2017年 項普華. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@protocol PHNetworkProtocol <NSObject>

@optional
/**
 网络状态的变化
 
 @param status 网络状态
 */
- (void)ph_networkStatus:(AFNetworkReachabilityStatus)status;

@end
