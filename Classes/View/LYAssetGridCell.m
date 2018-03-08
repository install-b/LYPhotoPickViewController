//
//  LYAssetGridCell.m
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2018/3/6.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//

#import "LYAssetGridCell.h"
#import <Photos/Photos.h>
#import "UIImage+Common.h"
#import "UIImageView+AssetImage.h"
#import "UIView+Frame.h"
#import "LYAsset.h"
#import "LYAssetPhotoConst.h"


@interface LYAssetGridCell ()

@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UIButton *selectedButton;
@end

@implementation LYAssetGridCell

#pragma mark - lazy

- (UIButton *)selectedButton
{
    if (!_selectedButton) {
        UIButton *selectedButton = [[UIButton alloc] init];
        
        [selectedButton setImage:[UIImage ly_imageNamed:@"file_unselected" withBundle:LYAssetBundleName] forState:UIControlStateNormal];
        [selectedButton setImage:[UIImage ly_imageNamed:@"file_selected" withBundle:LYAssetBundleName] forState:UIControlStateSelected];
        [selectedButton addTarget:self action:@selector(clickSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
        selectedButton.size = CGSizeMake(30, 30);
        _selectedButton = selectedButton;
        
        [self.contentView addSubview:_selectedButton];
    }
    
    return _selectedButton;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        _imageView = imageView;
        [self.contentView addSubview:_imageView];
    }
    
    return _imageView;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self imageView];
        [self selectedButton];
    }
    
    return self;
}

- (void)setInternalAsset:(LYAsset *)internalAsset
{
    _internalAsset = internalAsset;
    
    [self.imageView setImageWithAsset:internalAsset.asset targetSize:self.bounds.size];
    
    self.selectedButton.selected = internalAsset.isSelected;

}


- (void)clickSelectedButton:(UIButton *)selectedButton
{
    if ([self.delegate assetGridCell:self shouldChangeSelectedWithAsset:self.internalAsset]) {
        [self shakeToShow:selectedButton];
        selectedButton.selected = !selectedButton.isSelected;
        self.internalAsset.selected = selectedButton.isSelected;
    }
//    if (selectedButton.isSelected  ||
//        [self.delegate assetGridCell:self shouldSelectAsset:self.internalAsset]) {
//        [self shakeToShow:selectedButton];
//        selectedButton.selected = !selectedButton.isSelected;
//        self.internalAsset.selected = selectedButton.isSelected;
//        
//        return;
//    }
//    if ([self.delegate respondsToSelector:@selector(assetGridCell:shouldSelectAsset:)]) {
//        BOOL shouldAdd = [self.delegate assetGridCell:self shouldSelectAsset:self.internalAsset];
//        if (shouldAdd) {
//            [self shakeToShow:selectedButton];
//            selectedButton.selected = !selectedButton.isSelected;
//            self.internalAsset.selected = selectedButton.isSelected;
//        }
//    }
}

- (void)shakeToShow:(UIButton*)button {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [button.layer addAnimation:animation forKey:nil];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
//#warning layoutSubviews
    self.imageView.frame = self.contentView.bounds;
//    [self.imageView hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
//    }];
//
    CGPoint cp = self.selectedButton.inCenter;
    CGFloat offset = 3;
    self.selectedButton.center = CGPointMake(cp.x + offset, cp.y + offset);
//    [self.selectedButton hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(3);
//        make.right.equalTo(self.contentView).offset(-3);
//        make.size.equalTo(@(30));
//    }];
}

@end
