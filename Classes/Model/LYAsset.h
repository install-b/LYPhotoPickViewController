//
//  LYAsset.h
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2018/3/6.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface LYAsset : NSObject

@property (strong, nonatomic) PHAsset *asset;

@property (assign, nonatomic, getter=isSelected) BOOL selected;

@property (assign, nonatomic) CGSize assetGridThumbnailSize;

@property (assign, nonatomic) NSInteger dataLength;

@property (copy, nonatomic) NSString *bytes;

@end

@interface LYAsset (Create)

+ (instancetype)assetWithPHAsset:(PHAsset *)asset;

+ (NSArray <LYAsset *>*)arrayFromPHFetchResult:(PHFetchResult *)fetchResult;
@end


@interface LYAsset (FetchImage)
/**
 获取图片

 @param assets 相片集合
 @param targetWidth 要压缩的最大宽度
 @return 转化的 image 集合
 */
+ (NSArray <UIImage *>*)ly_imageArrayFromAssets:(NSArray <LYAsset *>*)assets compressTargetWidth:(CGFloat)targetWidth;
@end
