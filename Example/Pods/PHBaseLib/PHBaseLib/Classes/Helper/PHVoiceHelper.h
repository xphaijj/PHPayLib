//
//  PHVoiceHelper.h
//  App
//
//  Created by Alex on 2017/6/19.
//  Copyright © 2017年 項普華. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHMacro.h"

@interface PHVoiceHelper : NSObject

PH_ShareInstanceHeader(PHVoiceHelper);


/**
 播放声音 该声音长度最多30s

 @param filename 文件名 默认mp3格式 filename.mp3
*/
+ (void)playerSystemVoiceForFilename:(NSString *)filename;


@end
