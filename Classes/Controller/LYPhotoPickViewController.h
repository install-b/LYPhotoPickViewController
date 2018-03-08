//
//  LYPhotoPickViewController.h
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2018/3/6.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//



#import <UIKit/UIKit.h>



/*
 <key>NSPhotoLibraryUsageDescription</key>
 <string>需要您的授权才能访问相册</string>
 */


@class LYPhotoPickViewController;

@protocol LYPhotoPickViewControllerDelegate <NSObject>
@required
// 点击确定按钮
- (void)photoPickViewController:(LYPhotoPickViewController *)PhotoPickViewController didPickImages:(NSArray <UIImage *>*)imageArray;

@optional
// 点击取消按钮
- (void)photoPickViewControllerDidCancel:(LYPhotoPickViewController *)photoPickViewController;

// 无法获取相册
- (void)photoPickViewController:(LYPhotoPickViewController *)photoPickViewController notFetchPhotoWithStatus:(NSInteger)errorCode;

// 选择的图片个数超出最大值
- (void)photoPickViewController:(LYPhotoPickViewController *)photoPickViewController didSelectOutOfMaxCount:(NSInteger)maxCount;

// 最大选择图片数 不实现默认为5
- (NSInteger)maxSelectedCountWithPhotoPickViewController:(LYPhotoPickViewController *)photoPickViewController;
@end


@interface LYPhotoPickViewController : UIViewController
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;

- (instancetype)initWithDelegate:(id <LYPhotoPickViewControllerDelegate>)delegate;

- (void)showAssetGridViewController;

- (void)showAssetGridViewControllerWithNavigationVc:(UINavigationController *)nav;
@end
