//
//  PHLocationProtocol.h
//  App
//
//  Created by 項普華 on 2017/6/18.
//  Copyright © 2017年 項普華. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol PHLocationProtocol <NSObject>

@optional
/**
 定位回调
 */
- (void)ph_location:(CLLocation *)newLocation oldLocation:(CLLocation *)oldLocation;

/**
 地址解析的回调
 
 @param address 地址信息
 @param info 地址原始信息
 */
- (void)ph_address:(NSString *)address info:(CLPlacemark *)info;

@end
