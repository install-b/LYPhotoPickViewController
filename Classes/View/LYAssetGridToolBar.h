//
//  LYAssetGridToolBar.h
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2018/3/6.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//


#import <UIKit/UIKit.h>

@class LYAssetGridToolBar;

@protocol LYAssetGridToolBarDelegate <NSObject>

@required

- (void)didClickPreviewInAssetGridToolBar:(LYAssetGridToolBar *)assetGridToolBar;
- (void)didClickSenderButtonInAssetGridToolBar:(LYAssetGridToolBar *)assetGridToolBar;
- (void)assetGridToolBar:(LYAssetGridToolBar *)assetGridToolBar didClickOriginButton:(UIButton *)btn;

@end

@interface LYAssetGridToolBar : UIView

@property (strong, nonatomic) NSMutableArray *selectedItems;

@property (weak, nonatomic) id<LYAssetGridToolBarDelegate> delegate;

- (void)setOriginEnable:(BOOL)isOrigin;
@end
