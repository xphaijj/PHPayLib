//
//  PHTools.m
//  App
//
//  Created by 項普華 on 2017/6/14.
//  Copyright © 2017年 項普華. All rights reserved.
//

#import "PHTools.h"
#include <sys/sysctl.h>
#import <CommonCrypto/CommonDigest.h>
#import <AVFoundation/AVFoundation.h>
#import "PHMacro.h"
#import <objc/message.h>
#import "NSDictionary+Safe.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "PHSystemModel.h"

@implementation PHTools

- (void)ph_init {
}

#pragma mark -- 判断设备是否是iPad
BOOL PH_DeviceIsiPad() {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
    if ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)])
        return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);
#endif
    return NO;
}

#pragma mark -- 验证邮箱的有效性
BOOL PH_CheckEmail(NSString *sender) {
    NSString *emailRegex =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [pred evaluateWithObject:sender];
}

#pragma mark -- 验证字符串的有效性
BOOL PH_CheckString(NSString *sender) {
    if (sender == nil || sender == NULL) {
        return NO;
    }
    if ([sender isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if ([[sender stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return NO;
    }
    return YES;
}

#pragma mark -- 验证手机号的有效性
BOOL PH_CheckTelNumber(NSString *sender) {
    NSString *pattern = @"^1+[34578]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:sender];
}

#pragma mark -- 正则匹配用户密码6-18位数字和字母组合
BOOL PH_CheckPassword(NSString *sender) {
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:sender];
}

#pragma mark --  正则匹配用户姓名,20位的中文或英文
BOOL PH_CheckUserName(NSString *sender) {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5]{1,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [pred evaluateWithObject:sender];
}

#pragma mark -- 正则匹配用户身份证号15或18位
BOOL PH_CheckUserIdCard(NSString *sender) {
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:sender];
}

#pragma mark -- 正则匹员工号,12位的数字
BOOL PH_CheckEmployeeNumber(NSString *sender) {
    NSString *pattern = @"^[0-9]{12}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:sender];
}

#pragma mark -- 正则匹配URL
BOOL PH_CheckURL(NSString *sender) {
    NSString *pattern = @"^[0-9A-Za-z]{1,50}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:sender];
}

#pragma mark -- 16进制颜色值转化为颜色 #FF555511
UIColor *PH_ColorWithHexString(NSString *sender) {
    //删除字符串中的空格
    sender = [[sender stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([sender hasPrefix:@"0X"]) {
        sender = [sender substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([sender hasPrefix:@"#"]) {
        sender = [sender substringFromIndex:1];
    }
    
    if (sender.length != 3 && sender.length != 4 && sender.length != 6 && sender.length != 8) {
        return [UIColor clearColor];
    }
    
    if (sender.length == 3 || sender.length == 4) {
        NSRange range;
        range.location = 0;
        range.length = 1;
        NSString *r = [sender substringWithRange:range];
        range.location = 1;
        NSString *g = [sender substringWithRange:range];
        range.location = 2;
        NSString *b = [sender substringWithRange:range];
        NSString *a = @"FF";
        if (sender.length == 4) {
            range.location = 3;
            a = [sender substringWithRange:range];
        }
        
        sender = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", r, r, g, g, b, b, a, a];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [sender substringWithRange:range];
    range.location = 2;
    NSString *gString = [sender substringWithRange:range];
    range.location = 4;
    NSString *bString = [sender substringWithRange:range];
    
    NSString *aString = @"FF";
    if ([sender length] == 8) {
        range.location = 6;
        aString = [sender substringWithRange:range];
    }
    
    // Scan values
    unsigned int r, g, b, a;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    [[NSScanner scannerWithString:aString] scanHexInt:&a];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:((float) a / 255.0f)];
}

#pragma mark -- 字符串MD5 加密
NSString *PH_MD5(NSString *sender) {
    const char*cStr =[sender UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (int)strlen(cStr), result);
    return[[NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ] lowercaseString];
}

#pragma mark -- 按钮添加倒计时效果
BOOL PH_StartTime(UIButton *sender) {
    __block int timeout = 120; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [sender setTitle:@"重发" forState:UIControlStateNormal];
                sender.userInteractionEnabled = YES;
            });
        }else{
            //int minutes = timeout / 60;
            //int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [sender setTitle:[NSString stringWithFormat:@"%@", strTime] forState:UIControlStateNormal];
                sender.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    return YES;
}

#pragma mark -- 生成随机码 isCode 表示是否是纯数字
NSString *PH_MakeCode(BOOL isCode) {
    if (isCode) {
        NSInteger ver = 0;
        for (int i = 0; i < 5; i++) {
            ver = ver*10 + arc4random()%10;
        }
        return [NSString stringWithFormat:@"%06li", (long)ver];
    }
    else {
        NSInteger length = (arc4random()%5+5);
        char data[length];
        for (int x=0;x<length;data[x++] = (char)('A' + (arc4random_uniform(26))));
        return [[NSString alloc] initWithBytes:data length:length encoding:NSUTF8StringEncoding];
    }
    return @"";
}

#pragma mark -- 创建纯色的图片
UIImage *PH_CreateImageWithColor(UIColor *sender) {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [sender CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

#pragma mark -- 根据视频URL 生成缩略图
UIImage *PH_ThumbnailImageForVideo(NSURL *videoURL, NSTimeInterval time) {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime cmtime = CMTimeMakeWithSeconds(time, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:cmtime actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    return thumb;
}

#pragma mark -- 提示信息
void PH_ShowTips(NSString *tips) {
    [SVProgressHUD showInfoWithStatus:tips];
}

#pragma mark -- 获取当前vc
UIViewController *PH_CurrentVC() {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(window in windows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                break;
            }
        }
    }
    
    for (UIView *subView in [window subviews]) {
        UIResponder *responder = [subView nextResponder];
        if ([responder isEqual:window]) {
            if ([[subView subviews] count]) {
                UIView *subSubView = [subView subviews][0];
                responder = [subSubView nextResponder];
            }
        }
        
        if([responder isKindOfClass:[UIViewController class]]) {
            return PH_TopViewController((UIViewController *) responder);
        }
    }
    
    return window.rootViewController;
}

UIViewController *PH_TopViewController(UIViewController *controller)
{
    BOOL isPresenting = NO;
    do {
        UIViewController *presented = [controller presentedViewController];
        isPresenting = presented != nil;
        if(presented != nil) {
            controller = presented;
        }
        
    } while (isPresenting);
    
    if ([controller isKindOfClass:[UITabBarController class]]) {
        controller = ((UITabBarController *) controller).selectedViewController;
    }
    
    if ([controller isKindOfClass:[UINavigationController class]]) {
        controller = [((UINavigationController *) controller).viewControllers lastObject];
    }
    
    return controller;
}

/**
 *  生成随机码
 *
 *  @return <#return value description#>
 */
NSString *PH_Randomstr()
{
    NSInteger length = (arc4random()%5+6);
    char data[length];
    for (int x=0;x<length;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:length encoding:NSUTF8StringEncoding];
}

/**
 将对象转化为Json字符串
 
 @param object 对象
 @return JSON字符串
 */
NSString *PH_JsonStringFromObject(id object) {
    NSString *jsonString;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        PHLogError(@"%@ error to convert: %@", object, error);
        return @"";
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    [mutStr replaceOccurrencesOfString:@" "withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n"withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

/**
 将JSON字符串转化为对象
 
 @param string JSON字符串
 @return 对象
 */
id PH_ObjectFromJsonString(NSString *string) {
    NSError *error;
    id result = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        PHLogError(@"%@ error to convert:%@", string, error);
        return nil;
    }
    return result;
}

/**
 方法交换
 
 @param theClass 需要交换方法的Class
 @param originalSelector 需要交换的原始方法
 @param swizzledSelector 需要交换的方法
 */
void PH_SwizzleSelector(Class theClass, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(theClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(theClass, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

/**
 通过URLString 获取到对应的params
 
 @param urlString urlString
 @return 对应的params
 */
NSDictionary *PH_DictionaryFromURLString(NSString *urlString) {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    NSString *paramsString = urlString;
    //如果存在问号表示这是一整个urlstring 不存在表示只是参数列表
    if ([urlString rangeOfString:@"?"].location != NSNotFound) {
        paramsString = [[urlString componentsSeparatedByString:@"?"] lastObject];
    }
    //处理可能出现的特殊字符串
    paramsString = [paramsString stringByReplacingOccurrencesOfString:@"#" withString:@"&"];
    paramsString = [paramsString stringByReplacingOccurrencesOfString:@"%23" withString:@"&"];
    //使用&符号区分不同参数
    NSArray *list = [paramsString componentsSeparatedByString:@"&"];
    for (NSString *str in list) {
        //使用 = 区分key 与 value
        NSArray *params = [str componentsSeparatedByString:@"="];
        if (params.count == 2) {
            [result setObject:params[1] forKey:params[0]];
        }
    }
    
    return result;
}


/**
 自动布局计算cell高度
 
 @param cell cell
 @param info 数据
 @return 高度
 */
CGFloat PH_CellHeightForAutoLayout(UITableViewCell *cell, id info) {
    cell.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat contentViewWidth = CGRectGetWidth(PH_SCREEN_BOUNDS);
    if (cell.accessoryType != UITableViewCellAccessoryNone) {
        contentViewWidth -= 44;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
    if ([cell respondsToSelector:@selector(setInfo:)]) {
        [cell performSelector:@selector(setInfo:) withObject:info];
    }
#pragma clang diagnostic pop
    /*-----重点这里必须加上contentView的宽度约束不然计算出来的高度不准确---*/
    
    NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentViewWidth];
    [cell.contentView addConstraint:widthFenceConstraint];
    CGFloat fittingHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    [cell.contentView removeConstraint:widthFenceConstraint];
    /*-------------------------------End------------------------------------*/
    
    CGFloat cellHeight = fittingHeight + 2 * 1 / [UIScreen mainScreen].scale; //必须加上上下分割线的高度
    return cellHeight;
}


@end
