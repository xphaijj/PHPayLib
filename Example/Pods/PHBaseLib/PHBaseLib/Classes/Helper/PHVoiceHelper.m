//
//  PHVoiceHelper.m
//  App
//
//  Created by Alex on 2017/6/19.
//  Copyright © 2017年 項普華. All rights reserved.
//

#import "PHVoiceHelper.h"
#import "PHSystemModel.h"
#import <AVFoundation/AVFoundation.h>

@interface PHVoiceHelper () {
}

@property (nonatomic, strong) NSMutableDictionary *info;

@end

@implementation PHVoiceHelper

- (NSMutableDictionary *)info {
    if (!_info) {
        _info = [[NSMutableDictionary alloc] init];
    }
    return _info;
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
PH_ShareInstance(PHVoiceHelper);
#pragma clang diagnostic pop

- (void)ph_init {
}
/**
 播放声音 该声音长度最多30s
 
 @param path 文件名
 */
+ (void)playerSystemVoiceForFilename:(NSString *)path {
    [[PHVoiceHelper shareInstance] playerSystemVoiceForFilename:path];
}

- (void)playerSystemVoiceForFilename:(NSString *)path {
    SystemSoundID soundID = 0;
    NSArray *files = [path componentsSeparatedByString:@"."];
    NSString *filename = @"";
    NSString *typename = @"mp3";
    switch (files.count) {
        case 0:{
            return;
        }
            break;
        case 1: {
            filename = files[0];
        } break;
        default: {
            filename = files[0];
            typename = files[1];
        }
            break;
    }
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient
                                           error:nil];
    if (![self.info.allKeys containsObject:filename]) {
        NSString *filepath = [[NSBundle mainBundle] pathForResource:filename ofType:typename];
        //构建URL
        NSURL *url3 = [NSURL fileURLWithPath:filepath];
        //创建系统声音ID
        //注册声音文件，并且将ID保存
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url3), &soundID);
        [self.info setObject:@(soundID) forKey:filename];
    } else {
        soundID = (SystemSoundID)[[self.info objectForKey:filename] integerValue];
    }
    
    //播放声音
    AudioServicesPlaySystemSound(soundID);
}


- (void)dealloc {
    NSArray *infos = [PHSystemSound readFromSystem];
    SystemSoundID soundID = 0;
    for (PHSystemSound *info in infos) {
        soundID = (UInt32)info.soundId;
        //移除注册的系统声音
        AudioServicesRemoveSystemSoundCompletion(soundID);
    }
    
}

@end
