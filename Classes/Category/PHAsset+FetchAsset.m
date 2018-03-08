//
//  PHAsset+FetchAsset.m
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2018/3/7.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//

#import "PHAsset+FetchAsset.h"

@implementation PHAsset (FetchAsset)
+ (PHFetchResult <PHAsset *>*)ly_fetchAllAssets {
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    if (@available(iOS 9.0, *)) {
        option.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;
    }else {
        option.includeAllBurstAssets = YES;
    }
    return [self fetchAssetsWithOptions:option];
}
@end
