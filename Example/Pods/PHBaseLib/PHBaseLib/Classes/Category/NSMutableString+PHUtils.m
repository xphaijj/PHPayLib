//
//  NSMutableString+PHUtils.m
//  App
//
//  Created by Alex on 2017/6/19.
//  Copyright © 2017年 項普華. All rights reserved.
//

#import "NSMutableString+PHUtils.h"
#import "PHTools.h"
#import "PHMacro.h"
#import <objc/message.h>

@implementation NSMutableString (PHUtils)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PH_SwizzleSelector(NSClassFromString(@"__NSCFString"), @selector(appendString:), @selector(ph_appendString:));
    });
}

- (void)ph_appendString:(NSString *)aString {
    if (PH_CheckString(aString)) {
        [self ph_appendString:aString];
    }
}

@end
