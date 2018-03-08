//
//  LYAssetGridCollectionView.h
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2018/3/6.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYAssetGridCollectionView : UICollectionView
/** <#des#> */
@property(nonatomic,assign,readonly) CGSize assetGridThumbnailSize ;

- (instancetype)initWithFrame:(CGRect)frame column:(CGFloat)col itemMargin:(CGFloat)margin;
@end
