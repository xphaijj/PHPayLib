//
//  PHBlockMarco.h
//  App
//
//  Created by 項普華 on 2017/6/16.
//  Copyright © 2017年 項普華. All rights reserved.
//

#ifndef PHBlockMarco_h
#define PHBlockMarco_h
#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

/**
 VC dismiss 的Block

 @param response 响应
 */
typedef void(^PHDismissBlock)(id response);
/**
 DB 操作的回调

 @param success 是否成功
 @param response 回调的数据
 */
typedef void(^PHDBManagerResultBlock)(BOOL success, id response);


/**
 vc 回调的Block
 
 @param response 回调参数
 */
typedef void(^PHVCBackBlock)(id response);

/**
 view 回调Block
 
 @param response 回调参数
 */
typedef void(^PHViewBlock)(id response);

/**
 button 回调Block
 
 @param response 回调参数
 */
typedef void(^PHButtonBlock)(UIButton *response);

/**
 cell 回调Block
 
 @param indexPath indexpath
 @param response 数据
 */
typedef void(^PHCellBlock)(NSIndexPath *indexPath, id response);

/**
 Cell上面添加事件的回调
 
 @param indexPath indexPath
 @param response 回调参数
 */
typedef void(^PHCellActionBlock)(NSIndexPath *indexPath,  id response);

/**
 搜索框的搜索回调
 
 @param searchBar 搜索框
 */
typedef void(^PHSearchBlock)(UISearchBar *searchBar);

/**
 显示页面或隐藏页面的block

 @param value 数据
 */
typedef void(^PHValueBlock)(id value);

/**
 约束block
 
 @param make 添加约束的block
 */
typedef void(^PHLayout)(MASConstraintMaker *make);





#endif /* PHBlockMarco_h */
