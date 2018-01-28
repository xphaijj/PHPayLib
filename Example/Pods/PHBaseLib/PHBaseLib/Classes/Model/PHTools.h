//
//  PHTools.h
//  App
//
//  Created by 項普華 on 2017/6/14.
//  Copyright © 2017年 項普華. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PHMacro.h"

@interface PHTools : NSObject

/**
 判断设备是否是iPad

 @return 是否是iPad
 */
BOOL PH_DeviceIsiPad();

/**
 验证邮箱的有效性

 @param sender 待验证的邮箱
 @return 验证结果
 */
BOOL PH_CheckEmail(NSString *sender);

/**
 验证字符串的有效性

 @param sender 待验证的字符串
 @return 验证结果
 */
BOOL PH_CheckString(NSString *sender);

/**
 验证手机号码的有效性

 @param sender 待验证的手机号
 @return 验证结果
 */
BOOL PH_CheckTelNumber(NSString *sender);

/**
 正则匹配用户密码6-18位数字和字母组合

 @param sender 待验证的密码
 @return 密码的有效性
 */
BOOL PH_CheckPassword(NSString *sender) ;

/**
 正则匹配用户姓名,20位的中文或英文

 @param sender 待验证的用户名
 @return 用户名的有效性
 */
BOOL PH_CheckUserName(NSString *sender) ;

/**
 正则匹配用户身份证号15或18位

 @param sender 待验证的身份证号码
 @return 身份证号码的有效性
 */
BOOL PH_CheckUserIdCard(NSString *sender) ;

/**
 正则匹员工号,12位的数字

 @param sender 待验证的工号
 @return 工号的有效性
 */
BOOL PH_CheckEmployeeNumber(NSString *sender);

/**
 正则匹配URL

 @param sender 待验证的URL
 @return URL的有效性
 */
BOOL PH_CheckURL(NSString *sender);

/**
 16进制颜色值转化为颜色 #FF555511

 @param sender 待转化的字符串
 @return 颜色
 */
UIColor *PH_ColorWithHexString(NSString *sender);

/**
 字符串MD5 加密

 @param sender 待加密的字符串
 @return 加密后的字符串
 */
NSString *PH_MD5(NSString *sender);

/**
 按钮添加倒计时效果

 @param sender 按钮
 @return 调用结果
 */
BOOL PH_StartTime(UIButton *sender);

/**
 生成随机码 isCode 表示是否是纯数字

 @param isCode 是否生成纯数字
 @return 随机码
 */
NSString *PH_MakeCode(BOOL isCode);

/**
 创建纯色的图片

 @param sender 使用的颜色
 @return 纯色的图像
 */
UIImage *PH_CreateImageWithColor(UIColor *sender);

/**
 根据视频URL 生成缩略图

 @param videoURL 视频的地址
 @param time 截取的时间位置
 @return 截取的图像
 */
UIImage *PH_ThumbnailImageForVideo(NSURL *videoURL, NSTimeInterval time);

/**
 提示信息

 @param tips 提示内容
 */
void PH_ShowTips(NSString *tips);

/**
 获取当前vc

 @return 当前VC
 */
UIViewController *PH_CurrentVC();

/**
 *  生成随机码
 *
 *  @return <#return value description#>
 */
NSString *PH_Randomstr();
/**
 将对象转化为Json字符串

 @param object 对象
 @return JSON字符串
 */
NSString *PH_JsonStringFromObject(id object);

/**
 将JSON字符串转化为对象

 @param string JSON字符串
 @return 对象
 */
id PH_ObjectFromJsonString(NSString *string);


/**
 方法交换

 @param theClass 需要交换方法的Class
 @param originalSelector 需要交换的原始方法
 @param swizzledSelector 需要交换的方法
 */
void PH_SwizzleSelector(Class theClass, SEL originalSelector, SEL swizzledSelector);


/**
 通过URLString 获取到对应的params

 @param urlString urlString
 @return 对应的params
 */
NSDictionary *PH_DictionaryFromURLString(NSString *urlString);


/**
 自动布局计算cell高度

 @param cell cell
 @param info 数据
 @return 高度
 */
CGFloat PH_CellHeightForAutoLayout(UITableViewCell *cell, id info);







#pragma mark -- 可以写扩展的参数







@end
