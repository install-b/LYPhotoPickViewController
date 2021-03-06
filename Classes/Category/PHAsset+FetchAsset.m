//
//  PHAsset+FetchAsset.m
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2018/3/7.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//

#import "PHAsset+FetchAsset.h"
#define SystemVersion [[UIDevice currentDevice] systemVersion].floatValue


@implementation PHAsset (FetchAsset)
+ (PHFetchResult <PHAsset *>*)ly_fetchAllAssets {
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
#ifdef __IPHONE_9_0
    if (SystemVersion >= 9.0f) {
        option.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;
    }else {
        option.includeAllBurstAssets = YES;
    }
#else
    option.includeAllBurstAssets = YES;
#endif
    
    return [self fetchAssetsWithOptions:option];
}
@end
