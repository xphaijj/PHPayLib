//
//  PHLogProtocol.h
//  App
//
//  Created by Alex on 2017/6/20.
//  Copyright © 2017年 項普華. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PHLogProtocol <NSObject>

@optional
/**
 View显示的调用
 */
- (void)ph_logViewAppear;

/**
 View消失的记录
 */
- (void)ph_logViewDisappear;

/**
 点击动作的记录
 */
- (void)ph_logClick;

/**
 自定义事件的统计
 */
- (void)ph_logEvent:(NSString *)event;

@end
