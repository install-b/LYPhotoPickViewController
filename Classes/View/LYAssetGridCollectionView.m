//
//  LYAssetGridCollectionView.m
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2018/3/6.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//

#import "LYAssetGridCollectionView.h"
#import "UIView+Frame.h"


@implementation LYAssetGridCollectionView

- (instancetype)initWithFrame:(CGRect)frame column:(CGFloat)col itemMargin:(CGFloat)margin{
    CGFloat WH = (frame.size.width - (margin * (col + 1))) / col;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(WH, WH);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = margin;
    flowLayout.minimumInteritemSpacing = margin;
    flowLayout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    
    if (self = [super initWithFrame:frame collectionViewLayout:flowLayout]) {

        self.backgroundColor = [UIColor lightGrayColor];
        self.alwaysBounceVertical = YES;
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize cellSize = flowLayout.itemSize;
        _assetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
    }
    
    return self;
}

@end
