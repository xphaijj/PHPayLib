//
//  PHLoadingProtocol.h
//  App
//
//  Created by Alex on 2017/6/20.
//  Copyright © 2017年 項普華. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PHLoadingProtocol <NSObject>

@optional
/**
 加载视图
 */
- (void)ph_loadingView;

/**
 加载视图

 @param size 设置尺寸
 */
- (void)ph_loadingViewWithSize:(CGSize)size;

/**
 加载视图消失
 */
- (void)ph_loadingViewDismiss;

@end
