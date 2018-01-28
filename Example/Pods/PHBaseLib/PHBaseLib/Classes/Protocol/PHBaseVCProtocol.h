//
//  PHBaseVCProtocol.h
//  App
//
//  Created by 項普華 on 2017/6/18.
//  Copyright © 2017年 項普華. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHMacro.h"

@protocol PHBaseVCProtocol <NSObject>

@optional

/**
 添加子视图 在viewDidload中第一步开始调用 仅仅调用一次
 */
- (void)ph_addSubviews;

/**
 绑定Model 在viewDidLoad中第二步调用 仅仅调用一次
 */
- (void)ph_bindModel;

/**
 初始化网络请求 在viewDidLoad中第三步调用   仅仅调用一次
 */
- (void)ph_request;

/**
 自动布局的更新 在viewDidAppear中调用 可能调用多次
 */
- (void)ph_autolayout;

/**
 初始数据刷新 在viewWillAppear中调用 可能调用多次
 */
- (void)ph_loadData;

/**
 刷新数据  默认不调用
 */
- (void)ph_reloadData;

/**
 视图即将跳转的时候调用  可能调用多次
 */
- (void)ph_dismiss;

/**
 从下级页面返回当前页面的调用
 
 @param data 返回的参数
 */
- (void)ph_back:(id)data;

/**
 页面向下传递参数
 
 @param data 向下一个页面传递的参数
 @param backBlock 返回的block调用
 */
- (void)ph_nextData:(id)data
          backBlock:(PHVCBackBlock)backBlock;

@end
