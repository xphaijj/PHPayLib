//
//  PHKeyChainHelper.h
//  App
//
//  Created by Alex on 2017/6/19.
//  Copyright © 2017年 項普華. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHServiceMarco.h"
#import "PHSystemMarco.h"

@interface PHKeyChainHelper : NSObject

PH_ShareInstanceHeader(PHKeyChainHelper);

/**
 储存字符串到🔑钥匙串
 
 @param aValue 对应的Value
 @param aKey   对应的Key
 */
+ (void)ph_saveKeychainValue:(NSString *)aValue key:(NSString *)aKey;


/**
 从🔑钥匙串获取字符串
 
 @param aKey 对应的Key
 @return 返回储存的Value
 */
+ (NSString *)ph_readValueWithKeychain:(NSString *)aKey;


/**
 从🔑钥匙串删除字符串
 
 @param aKey 对应的Key
 */
+ (void)ph_deleteKeychainValue:(NSString *)aKey;

+ (NSString *)ph_uuid;

@end

#define PH_UUID [PHKeyChainHelper ph_uuid]


