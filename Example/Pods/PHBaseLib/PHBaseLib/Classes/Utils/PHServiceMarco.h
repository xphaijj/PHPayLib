//
//  PHServiceMarco.h
//  App
//
//  Created by 項普華 on 2017/6/17.
//  Copyright © 2017年 項普華. All rights reserved.
//

#ifndef PHServiceMarco_h
#define PHServiceMarco_h

//获取沙盒目录
#define PH_DOCUMENT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define PH_CACHE_PATH [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
//property 属性快速声明
#define PH_StringProperty(s)                @property (nonatomic, copy)     NSString * s;
#define PH_BoolProperty(s)                  @property (nonatomic, assign)   BOOL  s;
#define PH_IntegerProperty(s)               @property (nonatomic, assign)   NSInteger  s;
#define PH_FloatProperty(s)                 @property (nonatomic, assign)   float  s;
#define PH_LongLongProperty(s)              @property (nonatomic, assign)   long long s;
#define PH_DictionaryProperty(s)            @property (nonatomic, strong)   NSDictionary * s;
#define PH_MutableDictionaryProperty(s)     @property (nonatomic, strong)   NSMutableDictionary * s;
#define PH_ArrayProperty(s)                 @property (nonatomic, strong)   NSArray * s;
#define PH_MutableArrayProperty(s)          @property (nonatomic, strong)   NSMutableArray * s;
#define PH_ColorProperty(s)                 @property (nonatomic, strong)   UIColor * s;
#define PH_AssignProperty(s)                @property (nonatomic, assign)   s;
#define PH_CopyProperty(s)                  @property (nonatomic, copy)     s;
#define PH_StrongProperty(s)                @property (nonatomic, strong)   s;
#define PH_WeakProperty(s)                  @property (nonatomic, weak)     s;

//本地化
#define PH_LocalString(key) NSLocalizedString(key, nil)
//图片加载
#define PH_Image(path) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:path]]
//本地数据
#define PH_Data(path) [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:path]]

//快速生成单例对象
#define PH_ShareInstanceHeader(cls)    + (cls *)shareInstance;
#define PH_ShareInstance(cls)          static cls *share_cls = nil;\
                                        + (cls *)shareInstance {\
                                            static dispatch_once_t onceToken;\
                                                dispatch_once(&onceToken, ^{\
                                                share_cls = [[cls alloc] init];\
                                                if ([share_cls respondsToSelector:@selector(ph_init)]) {\
                                                    [share_cls performSelector:@selector(ph_init) withObject:nil afterDelay:0];\
                                                }\
                                            });\
                                            return share_cls;\
                                        }\
                                        + (instancetype)allocWithZone:(struct _NSZone *)zone {\
                                            if (share_cls == nil) {\
                                                static dispatch_once_t onceToken;\
                                                dispatch_once(&onceToken, ^{\
                                                    share_cls = [super allocWithZone:zone];\
                                                    if ([share_cls respondsToSelector:@selector(ph_init)]) {\
                                                        [share_cls performSelector:@selector(ph_init) withObject:nil afterDelay:0];\
                                                    }\
                                                });\
                                            }\
                                            return share_cls;\
                                        }
//懒加载宏定义
#define PHLazy(cls, sel, _sel) \
                                - (cls *)sel {\
                                    if (!_sel) {\
                                        _sel = [[cls alloc] init];\
                                    }\
                                    return _sel;\
                                }

#define PHLazyCategory(cls, fun) - (cls *)fun {\
                                            cls *result = objc_getAssociatedObject(self, @selector(fun));\
                                            if (result == nil) {\
                                                result = [[cls alloc] init];\
                                                objc_setAssociatedObject(self, @selector(fun), result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
                                            }\
                                            return result;\
                                        }

//VIEW 设置边框圆角
#define PH_ViewBorderRadius(view, radius, width, color) \
                                [view.layer setCornerRadius:(radius)];\
                                [view.layer setMasksToBounds:YES];\
                                [view.layer setBorderWidth:(width)];\
                                [view.layer setBorderColor:[color CGColor]];







#endif /* PHServiceMarco_h */
