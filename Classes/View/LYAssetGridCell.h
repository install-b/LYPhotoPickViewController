//
//  LYAssetGridCell.h
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2018/3/6.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//


#import <UIKit/UIKit.h>

//typedef void (^currentSeletedCount)(BOOL);

@class LYAssetGridCell, LYAsset;

@protocol LYAssetGridCellDelegate <NSObject>

@required

- (BOOL)assetGridCell:(LYAssetGridCell *)assetGridCell shouldChangeSelectedWithAsset:(LYAsset *)asset;

@end

@interface LYAssetGridCell : UICollectionViewCell

@property (weak, nonatomic) id<LYAssetGridCellDelegate> delegate;
@property (strong, nonatomic) LYAsset *internalAsset;
//@property (copy, nonatomic) void (^currentSeletedCount)(BOOL add);
@end
