//
//  PHPhotoHelper.m
//  App
//
//  Created by Alex on 2017/6/20.
//  Copyright © 2017年 項普華. All rights reserved.
//

#import "PHPhotoHelper.h"
#import "PHMacro.h"
#import "PHTools.h"

@implementation PHPhotoAlbumInfo

@synthesize assetCollection;
@synthesize name;
@synthesize count;
@synthesize thumb;

@end

@interface PHPhotoHelper () {
}
@property (nonatomic, strong) NSArray *albums;

@end

@implementation PHPhotoHelper

PH_ShareInstance(PHPhotoHelper);

- (void)ph_init {
}

- (NSMutableArray *)allAlbumInfo {
    if (!_allAlbumInfo) {
        _allAlbumInfo = [[NSMutableArray alloc] init];
        for (PHAssetCollection *album in self.allAlbums) {
            if (PH_CheckString(album.localizedTitle)) {
                PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:album options:nil];
                if (assets.count > 0) {
                    PHPhotoAlbumInfo *info = [[PHPhotoAlbumInfo alloc] init];
                    info.assetCollection = album;
                    info.name = album.localizedTitle;
                    info.count = assets.count;
                    info.thumb = [assets lastObject];
                    [_allAlbumInfo addObject:info];
                }
            }
        }
    }
    return _allAlbumInfo;
}

- (NSMutableArray *)allAlbums {
    if (!_allAlbums) {
        _allAlbums = [PHPhotoHelper allAlbums];
    }
    return _allAlbums;
}

/**
 获取系统相册
 
 @param callback 获取系统相册的回调
 */
+ (void)cameraRoll:(void(^)(PHAssetCollection *cameraRoll))callback {
    for (PHAssetCollection *asset in [PHPhotoHelper shareInstance].albums) {
        if ((asset.assetCollectionType == PHAssetCollectionTypeSmartAlbum) && (asset.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary)) {
            callback(asset);
        }
    }
}

/**
 获取系统相册权限状态
 
 */
+ (void)checkAuthorizationStatus:(void(^)(PHAuthorizationStatus status))callback {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
            case PHAuthorizationStatusNotDetermined: {
                [[self class] requestAuthorizationStatus:callback];
            } break;
            
        default: {
            callback(status);
        } break;
    }
}

+ (void)requestAuthorizationStatus:(void(^)(PHAuthorizationStatus status))callback {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        callback(status);
    }];
}

/**
 加载所有相册
 
 @param finish 相册加载成功的block
 @param error 相册加载失败的block
 */
+ (void)loadAlbums:(void(^)(NSArray *albums))finish
             error:(void(^)(NSString *error))error {
    [[self class] checkAuthorizationStatus:^(PHAuthorizationStatus status) {
        switch (status) {
                case PHAuthorizationStatusNotDetermined:
            {
            }
                break;
                case PHAuthorizationStatusDenied:
                case PHAuthorizationStatusRestricted: {
                    error(PH_LocalString(@"无权限访问"));
                } break;
                case PHAuthorizationStatusAuthorized: {
                    if ([PHPhotoHelper shareInstance].albums.count == 0) {
                        error(PH_LocalString(@"相册为空"));
                    } else {
                        finish([PHPhotoHelper shareInstance].albums);
                    }
                }
                break;
            default:
                break;
        }
    }];
}

+ (NSMutableArray *)allAlbums {
    NSMutableArray *albums = [NSMutableArray array];
    // 所有智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
            if (fetchResult.count > 0&&collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumVideos && collection.assetCollectionSubtype !=PHAssetCollectionSubtypeSmartAlbumTimelapses) {
                [albums addObject:collection];
            }
        } else {
            NSAssert1(NO, @"Fetch collection not PHCollection: %@", collection);
        }
    }];
    
    //所有用户创建的相册
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
            if (fetchResult.count > 0) {
                [albums addObject:collection];
            }
        }
        else {
            NSAssert1(NO, @"Fetch collection not PHCollection: %@", collection);
        }
    }];
    
    for (int i = 0; i < albums.count; i++) {
        for (int j = i; j < albums.count; j++) {
            PHFetchResult *fetchResult1 = [PHAsset fetchAssetsInAssetCollection:albums[i] options:nil];
            PHFetchResult *fetchResult2 = [PHAsset fetchAssetsInAssetCollection:albums[j] options:nil];
            if (fetchResult1.count < fetchResult2.count) {
                [albums exchangeObjectAtIndex:j withObjectAtIndex:i];
            }
        }
    }
    
    return albums;
}

/**
 获取一个相册中的照片
 
 @param album 指定的相册
 @param finish 照片获取成功的回调
 @param error 照片获取失败的回调
 */
+ (void)loadPhotosFromAlbum:(PHAssetCollection *)album
                     finish:(void(^)(NSArray *photos))finish
                      error:(void(^)(NSString *error))error {
    [[self class] requestAuthorizationStatus:^(PHAuthorizationStatus status) {
        switch (status) {
                case PHAuthorizationStatusAuthorized: {
                    PHFetchOptions *options = [[PHFetchOptions alloc] init];
                    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
                    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:album options:options];
                    if (assets.count != 0) {
                        NSMutableArray *photos = [NSMutableArray array];
                        [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([obj isKindOfClass:[PHAsset class]]) {
                                [photos addObject:obj];
                            }
                        }];
                        finish(photos);
                    } else {
                        error(PH_LocalString(@"相片为空"));
                    }
                } break;
                case PHAuthorizationStatusRestricted:
                case PHAuthorizationStatusDenied: {
                    error(PH_LocalString(@"无权限访问"));
                } break;
                case PHAuthorizationStatusNotDetermined: {
                } break;
            default:
                break;
        }
    }];
}

/**
 加载缩略图
 
 @param asset asset
 @param finish 加载成功的回调
 @param error 加载失败的回调
 */
+ (void)loadThumbnailFromAsset:(PHAsset *)asset
                        finish:(void(^)(UIImage *result, NSDictionary *info))finish
                         error:(void(^)(NSString *error))error {
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake((PH_SCREEN_WIDTH-15)/3, (PH_SCREEN_WIDTH-15)/3) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            finish(result, info);
        });
    }];
}

/**
 加载原图
 
 @param asset asset
 @param finish 加载成功的回调
 @param error 加载失败的回调
 */
+ (void)loadOriginalFromAsset:(PHAsset *)asset
                       finish:(void(^)(UIImage *result, NSDictionary *info))finish
                        error:(void(^)(NSString *error))error {
    static PHImageRequestOptions *originalOptions;
    if (!originalOptions) {
        originalOptions = [[PHImageRequestOptions alloc] init];
        originalOptions.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
        originalOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
        originalOptions.synchronous = NO;
        originalOptions.networkAccessAllowed = YES;
        originalOptions.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
        };
    }
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:originalOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        finish(result, info);
    }];
}

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
                         error:(void(^)(NSString *error))error {
    size.height = size.width*asset.pixelHeight/asset.pixelWidth;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            finish(result, info);
        });
    }];
}

@end
