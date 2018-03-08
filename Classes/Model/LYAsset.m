//
//  LYAsset.m
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2018/3/6.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//

#import "LYAsset.h"
#import "UIImage+Common.h"

@implementation LYAsset
- (NSString *)bytes
{
    if (!_bytes ){ // 计算一次
        if (self.dataLength >= 0.1 * (1024 * 1024)) {
            _bytes = [NSString stringWithFormat:@"%0.1fM",self.dataLength/1024/1024.0];
        } else if (self.dataLength >= 1024) {
            _bytes = [NSString stringWithFormat:@"%0.0fK",self.dataLength/1024.0];
        } else {
            _bytes = [NSString stringWithFormat:@"%zdB",self.dataLength];
        }
    }
    return _bytes;
}

- (NSInteger)dataLength
{
    if (!_dataLength) {
        __block NSInteger dataLength = 0;
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        
        [[PHImageManager defaultManager] requestImageDataForAsset:self.asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            dataLength = imageData.length;
        }];
        
        _dataLength = dataLength;
    }
    
    return _dataLength;
}
@end

@implementation LYAsset (Create)

+ (instancetype)assetWithPHAsset:(PHAsset *)asset {
    LYAsset *internalAsset = [[LYAsset alloc] init];
    internalAsset.asset = asset;
    internalAsset.selected = NO;
    return internalAsset;
}

+ (NSArray <LYAsset *>*)arrayFromPHFetchResult:(PHFetchResult *)fetchResult {
    NSMutableArray *tempArrayM = [NSMutableArray arrayWithCapacity:fetchResult.count];
    [fetchResult enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempArrayM addObject:[self assetWithPHAsset:asset]];
    }];
    return [NSArray arrayWithArray:tempArrayM];
}

@end

@implementation LYAsset (FetchImage)
+ (NSArray <UIImage *>*)ly_imageArrayFromAssets:(NSArray <LYAsset *>*)assets compressTargetWidth:(CGFloat)targetWidth {
    
    if (assets == nil) {
        return nil;
    }
    
    NSMutableArray *tempArrayM = [NSMutableArray arrayWithCapacity:assets.count];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    
    PHImageManager *mgr = [PHImageManager defaultManager] ;
    [assets enumerateObjectsUsingBlock:^(LYAsset * _Nonnull lyAsset, NSUInteger idx, BOOL * _Nonnull stop) {
        [mgr requestImageDataForAsset:lyAsset.asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            
            UIImage *image = [[UIImage imageWithData:imageData] ly_fixOrientation];
            
            // 压缩图片
            if (targetWidth > 0.0f && lyAsset.dataLength > 1024 * 1024 * 0.1) {
                image = [image ly_compressImageWithTargetWidth:targetWidth];
            }
            
            [tempArrayM addObject:image];
        }];
    }];
    
    return [NSArray arrayWithArray:tempArrayM];
}
@end
