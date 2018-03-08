//
//  UIImageView+AssetImage.m
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2017/8/17.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "UIImageView+AssetImage.h"
#import "UIImage+Common.h"


@implementation UIImageView (AssetImage)
- (void)setImageWithAsset:(PHAsset *)asset {
    [self setImageWithAsset:asset targetSize:CGSizeZero];
}
- (void)setImageWithAsset:(PHAsset *)asset  targetSize:(CGSize)size {
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    __block UIImage *image;
    
    CGFloat pixelWidth = size.width;
    CGFloat pixelHeight = size.height;
    
    if (pixelWidth == 0) {
        CGFloat photoWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat multiple = [UIScreen mainScreen].scale;
        
        CGFloat aspectRatio = asset.pixelWidth / (CGFloat)asset.pixelHeight;
        pixelWidth = photoWidth * multiple;
        pixelHeight = pixelWidth / aspectRatio;
        
    }
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(pixelWidth, pixelHeight) contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage *result, NSDictionary *info) {
        self.image =result;
        if (result) {
            image = result;
        }
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && result) {
            result = [result ly_fixOrientation];
            self.image = result;
            //if (completion) completion(result,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        }
        // Download image from iCloud / 从iCloud下载图片
        if ([info objectForKey:PHImageResultIsInCloudKey] && !result ) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            //            options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
            //                dispatch_async(dispatch_get_main_queue(), ^{
            //                    if (progressHandler) {
            //                        progressHandler(progress, error, stop, info);
            //                    }
            //                });
            //            };
            options.networkAccessAllowed = YES;
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                UIImage *resultImage = [UIImage imageWithData:imageData scale:0.1];
                if (size.width != 0) {
                    resultImage = [resultImage ly_scaleToSize:size];
                }
                
                if (!resultImage) {
                    resultImage = image;
                }
                resultImage = [resultImage ly_fixOrientation];
                self.image = resultImage;
                //if (completion) completion(resultImage,info,NO);
            }];
        }
    }];

}


@end





