//
//  PHPhotoHelper.h
//  App
//
//  Created by Alex on 2017/6/20.
//  Copyright © 2017年 項普華. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "PHMacro.h"

@interface PHPhotoAlbumInfo : NSObject

@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, strong) PHAsset *thumb;

@end

@interface PHPhotoHelper : NSObject

PH_ShareInstanceHeader(PHPhotoHelper);

/**
 所有相册的基本信息 包括名称 name 数量 count 缩略图 thumb
 */
@property (nonatomic, copy) NSMutableArray *allAlbumInfo;

/**
 所有相册
 */
@property (nonatomic, copy) NSMutableArray *allAlbums;

/**
 获取系统相册
 
 @param callback 获取系统相册的回调
 */
+ (void)cameraRoll:(void(^)(PHAssetCollection *cameraRoll))callback;

/**
 获取系统相册权限
 
 @param callback 获取到系统相册权限的回调
 */
+ (void)checkAuthorizationStatus:(void(^)(PHAuthorizationStatus status))callback;

/**
 加载所有相册
 
 @param finish 相册加载成功的block
 @param error 相册加载失败的block
 */
+ (void)loadAlbums:(void(^)(NSArray *albums))finish
             error:(void(^)(NSString *error))error;

/**
 获取一个相册中的照片
 
 @param album 指定的相册
 @param finish 照片获取成功的回调
 @param error 照片获取失败的回调
 */
+ (void)loadPhotosFromAlbum:(PHAssetCollection *)album
                     finish:(void(^)(NSArray *photos))finish
                      error:(void(^)(NSString *error))error;


/**
 加载缩略图
 
 @param asset asset
 @param finish 加载成功的回调
 @param error 加载失败的回调
 */
+ (void)loadThumbnailFromAsset:(PHAsset *)asset
                        finish:(void(^)(UIImage *result, NSDictionary *info))finish
                         error:(void(^)(NSString *error))error;

/**
 加载原图
 
 @param asset asset
 @param finish 加载成功的回调
 @param error 加载失败的回调
 */
+ (void)loadOriginalFromAsset:(PHAsset *)asset
                       finish:(void(^)(UIImage *result, NSDictionary *info))finish
                        error:(void(^)(NSString *error))error;


/**
 加载固定size的图片
 
 @param asset asset
 @param size size
 @param finish 成功回调
 @param error 失败回调
 */
+ (void)loadSizePhotoFromAsset:(PHAsset *)asset
                          size:(CGSize)size
                        finish:(void(^)(UIImage *result, NSDictionary *info))finish
                         error:(void(^)(NSString *error))error;


@end
