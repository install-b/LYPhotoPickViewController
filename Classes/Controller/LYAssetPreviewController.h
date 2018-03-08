//
//  LYAssetPreviewController.h
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2018/3/6.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//
//  照片选择器（预览照片模式）

#import <UIKit/UIKit.h>


@class LYAssetPreviewController;
@class LYAsset;

@protocol LYAssetViewControllerDelegate <NSObject>
@required
// 点击了原图按钮
- (void)assetPreviewController:(LYAssetPreviewController *)assetPreviewController didSelectOrigin:(BOOL)isOrigin;

// 点击确定按钮
- (void)assetPreviewController:(LYAssetPreviewController *)assetPreviewController didClickSenderButton:(NSMutableArray *)selectedItems;

// 超过最大的选择数量
- (void)assetPreviewController:(LYAssetPreviewController *)assetPreviewController didSelectOutOfMaxCount:(NSInteger)maxCount;
@end


@interface LYAssetPreviewController : UIViewController
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithAssetArray:(NSArray <LYAsset *>*)assetArray maxSelectCount:(NSUInteger)maxSelecedCount;

/**
 *  显示第一张图片的索引
 */
@property (assign, nonatomic) NSInteger index;

/**
 *  显示图片的数组
 */
@property (strong, nonatomic,readonly) NSArray <LYAsset *>*assetArray;

/**
 *  选中图片的数组
 */
@property (strong, nonatomic) NSMutableArray *selectedItems;


@property (weak, nonatomic) id<LYAssetViewControllerDelegate> delegate;


/** <#des#> */
@property(nonatomic,assign,getter=isOriginSelect) BOOL originSelect;

@end
