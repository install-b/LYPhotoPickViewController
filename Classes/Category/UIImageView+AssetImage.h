//
//  UIImageView+AssetImage.h
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2017/8/17.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>



@interface UIImageView (AssetImage)

- (void)setImageWithAsset:(PHAsset *)asset;

- (void)setImageWithAsset:(PHAsset *)asset  targetSize:(CGSize)size;
@end
