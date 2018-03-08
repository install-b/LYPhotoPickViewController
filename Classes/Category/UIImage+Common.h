//
//  UIImage+Common.h
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2018/3/7.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface UIImage (Extension)

+ (UIImage *)ly_imageNamed:(NSString *)name withBundle:(NSString *)bundle;

+ (UIImage *)ly_imageWithColor:(UIColor *)color;

@end



@interface UIImage (Operations)

- (UIImage *)ly_scaleToSize:(CGSize)size;

- (UIImage *)ly_compressImageWithTargetWidth:(CGFloat)targetWidth;

- (UIImage *)ly_fixOrientation;

@end
