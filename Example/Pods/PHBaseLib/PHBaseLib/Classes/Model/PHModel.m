//
//  PHModel.m
//  Example
//
//  Created by 項普華 on 2017/5/10.
//  Tel:(+86)13316987488  Mail:xiangpuhua@126.com
//  Copyright © 2017年 項普華. All rights reserved.
//

#import "PHModel.h"
#import "PHMacro.h"
#import <objc/message.h>
#import "NSDictionary+Safe.h"
#define SYSTEM_MEMORY_KEY [NSString stringWithFormat:@"PH_SYSTEM_%@_%@", PH_BundleIdentifier, NSStringFromClass([self class])]

@interface PHModel () {
}

@end

@implementation PHModel

#pragma mark -- 
/**
 获取当前的ORM映射
 
 @return 映射字典
 */
+ (NSDictionary *)ph_keyMapper {
    return @{};
}

/**
 获取数组中model的映射

 @return 映射字典
 */
+ (NSDictionary *)ph_classInArray {
    return @{};
}

#pragma mark -- MJ method
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return [[self class] ph_keyMapper];
}

+ (NSDictionary *)mj_objectClassInArray {
    return [[self class] ph_classInArray];
}

#pragma mark -- NSCopying delegate

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[self class] mj_objectWithKeyValues:self.mj_keyValues];
}

/**
 存储  存储到默认的key
 */
- (void)save {
    [self saveForKey:NSStringFromClass([self class])];
}

/**
 存储
 
 @param key 使用key存储
 */
- (void)saveForKey:(NSString *)key {
    NSDictionary *data = [self mj_keyValues];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/**
 读取默认key的内容
 */
+ (id)read {
    return [self readForKey:NSStringFromClass(self)];
}

/**
 读取指定key的内容
 
 @param key 指定的key
 */
+ (id)readForKey:(NSString *)key {
    NSDictionary *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (data) {
        id result = nil;
        @try {
            result = [[self class] mj_objectWithKeyValues:data];
        } @catch (NSException *exception) {
            PHLogWarn(@"%@", exception);
        } @finally {
            return result;
        }
    } else {
        PHLogWarn(@"没有找到对应key的内容");
    }
    return nil;
}

/**
 移除
 */
- (void)remove {
    [PHModel removeForKey:NSStringFromClass([self class])];
}
/**
 移除
 */
+ (void)remove {
    [self removeForKey:NSStringFromClass(self)];
}

/**
 根据key移除
 
 @param key key
 */
+ (void)removeForKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 移除所有
 */
+ (void)removeAll {
    NSUserDefaults *defatluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [defatluts dictionaryRepresentation];
    for(NSString *key in [dictionary allKeys]){
        [defatluts removeObjectForKey:key];
    }
    [defatluts synchronize];
}

/**
 添加到系统的中 注意这种形式 是以一个数组的形式存储起来的  读取也是以数组的形式读取
 */
- (void)addToSystem {
    NSMutableArray *list = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:SYSTEM_MEMORY_KEY]];
    if (list == nil) {
        list = [[NSMutableArray alloc] init];
    }
    [list addObject:[self mj_keyValues]];
    [[NSUserDefaults standardUserDefaults] setObject:list forKey:SYSTEM_MEMORY_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 读取系统中的数组内容
 
 @return 数组
 */
+ (NSArray *)readFromSystem {
    NSMutableArray *list = [[NSUserDefaults standardUserDefaults] objectForKey:SYSTEM_MEMORY_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SYSTEM_MEMORY_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSDictionary *info in list) {
        [result addObject:[self mj_objectWithKeyValues:info]];
    }
    return result;
}




@end
