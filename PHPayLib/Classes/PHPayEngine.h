//
//  PHPayEngine.h
//  PPDemo
//
//  Created by 項普華 on 2017/5/29.
//  Tel:(+86)13316987488  Mail:xiangpuhua@126.com
//  Copyright © 2017年 項普華. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YLT_BaseLib/YLT_BaseLib.h>
#import "PHPayProtocol.h"
#import "PHPayChannelProtocol.h"

@interface PHPayEngine : NSObject<PHPayProtocol>

YLT_ShareInstanceHeader(PHPayEngine);

@end
