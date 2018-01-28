//
// PHSystemModel.m 
//
// Created By 项普华 Version: 2.0
// Copyright (C) 2017/08/06  By AlexXiang  All rights reserved.
// email:// xiangpuhua@126.com  tel:// +86 13316987488 
//
//

#import "PHMacro.h"
#import "PHSystemModel.h"



@implementation PHSystemSound

@synthesize soundId;
@synthesize filename;

- (id)init {
	self = [super init];
	if (self) {
		self.soundId = 0;
		self.filename = @"";
	}
	return self;
}

+ (NSDictionary *)ph_keyMapper {
	return @{
				};
}
+ (NSDictionary *)ph_classInArray {
	return @{
				};
}

@end


@implementation PHKeyConfig

PH_ShareInstance(PHKeyConfig);

/**
 载入配置文件
 
 @param configName 配置文件的名称
 */
+ (void)PH_SystemConfig:(NSString *)configName {
    [PHKeyConfig shareInstance].systemConfig = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:configName]];
    
    if (![PHKeyConfig shareInstance].systemConfig || [PHKeyConfig shareInstance].systemConfig.allKeys.count == 0) {
        PHLogWarn(@"请配置基本参数");
    }
}

- (void)ph_init {
    self.request_extras = [[NSMutableDictionary alloc] init];
}

- (void)setSystemConfig:(NSDictionary *)systemConfig {
    _systemConfig = systemConfig;
    //(1)获取类的属性及属性对应的类型
    NSMutableArray * keys = [NSMutableArray array];
    NSMutableArray * attributes = [NSMutableArray array];
    unsigned int outCount;
    objc_property_t * properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i ++) {
        objc_property_t property = properties[i];
        //通过property_getName函数获得属性的名字
        NSString * propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
        //通过property_getAttributes函数可以获得属性的名字和@encode编码
        NSString * propertyAttribute = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        [attributes addObject:propertyAttribute];
    }
    //立即释放properties指向的内存
    free(properties);
    
    //(2)根据类型给属性赋值
    for (NSString * key in keys) {
        if ([_systemConfig valueForKey:key] == nil) continue;
        if ([key isEqualToString:@"request_extras"]) {
            [self.request_extras addEntriesFromDictionary:[self.systemConfig objForKey:@"request_extras"]];
        }
        else {
            [self setValue:[_systemConfig valueForKey:[key lowercaseString]] forKey:[key lowercaseString]];
        }
    }
}


+ (NSDictionary *)ph_keyMapper {
	return @{
				};
}
+ (NSDictionary *)ph_classInArray {
	return @{
				};
}

@end
