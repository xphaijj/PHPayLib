//
//  PHModel.h
//  Example
//
//  Created by 項普華 on 2017/5/10.
//  Tel:(+86)13316987488  Mail:xiangpuhua@126.com
//  Copyright © 2017年 項普華. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

@interface PHModel : NSObject<NSCopying>

/**
 获取当前的ORM映射
 
 @return 映射字典
 */
+ (NSDictionary *)ph_keyMapper;

+ (NSDictionary *)ph_classInArray;

/**
 存储  存储到默认的key
 */
- (void)save;

/**
 存储

 @param key 使用key存储
 */
- (void)saveForKey:(NSString *)key;

/**
 读取默认key的内容
 */
+ (id)read;

/**
 读取指定key的内容

 @param key 指定的key
 */
+ (id)readForKey:(NSString *)key;

/**
 移除
 */
- (void)remove;
/**
 移除
 */
+ (void)remove;

/**
 根据key移除

 @param key key
 */
+ (void)removeForKey:(NSString *)key;

/**
 移除所有
 */
+ (void)removeAll;

/**
 添加到系统的中 注意这种形式 是以一个数组的形式存储起来的  读取也是以数组的形式读取
 */
- (void)addToSystem;

/**
 读取系统中的数组内容

 @return 数组
 */
+ (NSArray *)readFromSystem;







@end
