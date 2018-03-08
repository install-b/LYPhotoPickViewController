//
//  PHAsset+FetchAsset.h
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2018/3/7.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHAsset (FetchAsset)
+ (PHFetchResult <PHAsset *>*)ly_fetchAllAssets;
@end
