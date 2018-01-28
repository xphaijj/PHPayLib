//
//  PHSystemMarco.h
//  App
//
//  Created by 項普華 on 2017/6/16.
//  Copyright © 2017年 項普華. All rights reserved.
//

#ifndef PHSystemMarco_h
#define PHSystemMarco_h

typedef NS_ENUM(NSUInteger, PHDirection) {
    PHDirectionTop=1,
    PHDirectionBottom,
    PHDirectionLeft,
    PHDirectionRight,
};


#if DEBUG
//输出带颜色的日志信息
#define PHLogAll(type,format,...) NSLog(@"%@ %s+%d " format,type,__func__,__LINE__,##__VA_ARGS__)
#define PHLog(format,...) PHLogAll(@"",format,##__VA_ARGS__)
#define PHLogInfo(format,...) PHLogAll(@"",format,##__VA_ARGS__)
#define PHLogWarn(format,...) PHLogAll(@"‼️",format,##__VA_ARGS__)
#define PHLogError(format,...) PHLogAll(@"❌❌",format,##__VA_ARGS__)
#else
#define PHLog(format,...)
#define PHLogInfo(format,...)
#define PHLogWarn(format,...)
#define PHLogError(format,...)
#define NSLog(format,...)
#endif

//强弱引用
#define PH_Weak(self) __weak typeof(self) self##Weak = self;
#define PH_Strong(self) __strong typeof(self) self = self##Weak;
//获取系统对象
#define PH_Application        [UIApplication sharedApplication]
#define PH_AppWindow          [UIApplication sharedApplication].keyWindow
#define PH_AppDelegate        (AppDelegate *)[UIApplication sharedApplication].delegate
#define PH_RootViewController [UIApplication sharedApplication].delegate.window.rootViewController
#define PH_UserDefaults       [NSUserDefaults standardUserDefaults]
#define PH_NotificationCenter [NSNotificationCenter defaultCenter]
//获取屏幕宽高
#define PH_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define PH_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define PH_SCREEN_BOUNDS [UIScreen mainScreen].bounds

//iOS系统版本
#define PH_iOS_VERSION [[[UIDevice currentDevice] systemVersion] integerValue]
#define PH_iOS7     [[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0
#define PH_iOS8     [[[UIDevice currentDevice] systemVersion] integerValue] >= 8.0
#define PH_iOS9     [[[UIDevice currentDevice] systemVersion] integerValue] >= 9.0
#define PH_iOS10    [[[UIDevice currentDevice] systemVersion] integerValue] >= 10.0
#define PH_iOS11    [[[UIDevice currentDevice] systemVersion] integerValue] >= 11.0

//当前语言
#define PH_CurrentLanguage [[NSLocale preferredLanguages] objectAtIndex:0]

#define PH_InfoDictionary [[NSBundle mainBundle] infoDictionary]
//当前应用程序的 bundle ID
#define PH_BundleIdentifier [[NSBundle mainBundle] bundleIdentifier]
//当前应用程序的版本号
// app名称
#define PH_AppName [PH_InfoDictionary objectForKey:@"CFBundleDisplayName"]
//将URLTypes 中的第一个当做当前的回调参数
#define PH_URL_SCHEME [[PH_InfoDictionary[@"CFBundleURLTypes"] firstObject][@"CFBundleURLSchemes"] firstObject]
// app版本
#define PH_AppVersion [PH_InfoDictionary objectForKey:@"CFBundleShortVersionString"]
// app build版本
#define PH_BuildVersion [PH_InfoDictionary objectForKey:@"CFBundleVersion"]
// iPhone 别名
#define PH_PhoneName [[UIDevice currentDevice] name]
//当前Bundle
#define PH_CurrentBundle [NSBundle bundleForClass:[self class]]
//主bundle
#define PH_MainBundle [NSBundle mainBundle]
//全局队列
#define PH_GlobalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//主线程
#define PH_MainQueue dispatch_get_main_queue()
//图片资源的加载
#define PH_ImageRes(name, type, bundleName, dir) [UIImage imageWithContentsOfFile:[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForAuxiliaryExecutable:[NSString stringWithFormat:@"%@.bundle", bundleName]]]?:PH_CurrentBundle pathForResource:name ofType:type?:@"png" inDirectory:dir]]
//加载storyboard
#define PH_Storyboard(storyboardName) [UIStoryboard storyboardWithName:storyboardName bundle:nil]

//颜色宏定义
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]


#endif /* PHSystemMarco_h */
