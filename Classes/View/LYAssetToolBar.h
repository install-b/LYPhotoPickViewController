//
//  LYAssetToolBar.h
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2018/3/6.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//


#import <UIKit/UIKit.h>

@class LYAssetToolBar;
@protocol LYAssetToolBarDelegate <NSObject>
- (void)assetToolBar:(LYAssetToolBar *)toolBar clickOriginalButton:(UIButton *)sender;

- (void)assetToolBar:(LYAssetToolBar *)toolBar clickSenderButton:(UIButton *)sender;
@end

@interface LYAssetToolBar : UIView
/** <#delegate#> */
@property (nonatomic,weak) id<LYAssetToolBarDelegate> delegate;

@property (weak, nonatomic) UIButton *originalButton;

- (void)setSenderCount:(NSUInteger)count;

- (void)updateOriginImageBytes:(NSString *)bytes;

@end

