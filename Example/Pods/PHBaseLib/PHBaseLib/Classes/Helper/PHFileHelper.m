//
//  PHFileHelper.m
//  App
//
//  Created by Alex on 2017/6/19.
//  Copyright © 2017年 項普華. All rights reserved.
//

#import "PHFileHelper.h"
#import "PHMacro.h"

@implementation PHFileHelper

PH_ShareInstance(PHFileHelper);

- (void)ph_init {
}

+ (NSString *)defaultFilePath {
    NSString *basePath = [NSString stringWithFormat:@"%@/%@", PH_CACHE_PATH, PH_BundleIdentifier];
    if ([PHFileHelper createDirectory:basePath]) {
        return basePath;
    }
    return @"";
}

+ (BOOL)createDirectory:(NSString *)basePath {
    BOOL result = YES;
    BOOL isDirectory = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:basePath isDirectory:&isDirectory]) {
        if (!isDirectory) {
            @try {
                result = [[NSFileManager defaultManager] createDirectoryAtPath:basePath withIntermediateDirectories:YES attributes:nil error:nil];
            } @catch (NSException *exception) {
                PHLogError(@"路径创建失败 %@", exception);
                result = NO;
            } @finally {
            }
        }
    }
    return result;
}

+ (NSString *)createPath:(NSString *)path filename:(NSString *)filename {
    NSString *filepath = [NSString stringWithFormat:@"%@/%@", path, filename];
    BOOL isDirectory = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filepath isDirectory:&isDirectory]) {
        if (isDirectory) {
            @try {
                [[NSFileManager defaultManager] createFileAtPath:filepath contents:nil attributes:nil];
            } @catch (NSException *exception) {
                PHLogError(@"文件创建失败 %@", exception);
            } @finally {
            }
        }
    }
    PHLog(@"%@", filepath);
    return filepath;
}

+ (NSString *)createLogWithFilename:(NSString *)filename {
    NSString *basePath = [NSString stringWithFormat:@"%@/OpenLog", PH_CACHE_PATH];
    [PHFileHelper createDirectory:basePath];
    return [PHFileHelper createPath:basePath filename:filename];
}

+ (NSString *)createWithFilename:(NSString *)filename {
    NSString *basePath = [NSString stringWithFormat:@"%@/Other", PH_CACHE_PATH];
    [PHFileHelper createDirectory:basePath];
    return [PHFileHelper createPath:basePath filename:filename];
}

+ (void)saveToPath:(NSString *)path file:(NSData *)data {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @try {
            [data writeToFile:path atomically:YES];
        } @catch (NSException *exception) {
            PHLogError(@"文件写入失败 %@", exception);
        } @finally {
        }
    });
}

+ (void)saveToPath:(NSString *)path image:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 0.95);
    [PHFileHelper saveToPath:path file:data];
}

+ (void)saveWithFileName:(NSString *)filename file:(NSData *)data {
    NSString *path = [PHFileHelper createPath:[PHFileHelper defaultFilePath] filename:filename];
    [PHFileHelper saveWithFileName:path file:data];
}

+ (void)saveWithFilename:(NSString *)filename image:(UIImage *)image {
    NSString *path = [PHFileHelper createPath:[PHFileHelper defaultFilePath] filename:filename];
    NSData *data = UIImageJPEGRepresentation(image, 0.95);
    [PHFileHelper saveToPath:path file:data];
}

+ (UIImage *)readImageWithFilename:(NSString *)filename {
    NSString *path = [PHFileHelper createPath:[PHFileHelper defaultFilePath] filename:filename];
    return [UIImage imageWithData:[PHFileHelper readFileFromPath:path]];
}

+ (NSData *)readFileWithFilename:(NSString *)filename {
    NSString *path = [PHFileHelper createPath:[PHFileHelper defaultFilePath] filename:filename];
    return [PHFileHelper readFileFromPath:path];
}

+ (UIImage *)readImageFromPath:(NSString *)path {
    return [UIImage imageWithData:[PHFileHelper readFileFromPath:path]];
}

+ (NSData *)readFileFromPath:(NSString *)path {
    return [NSData dataWithContentsOfFile:path];
}


@end
