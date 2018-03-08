//
//  LYAssetGridToolBar.m
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2018/3/6.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//


#import "LYAssetGridToolBar.h"
#import "LYAsset.h"
#import "LYAssetPhotoConst.h"
#import "UIImage+Common.h"
#import "UIView+Frame.h"


@interface LYAssetGridToolBar ()

@property (weak, nonatomic) UIButton *previewButton;
@property (weak, nonatomic) UIButton *originalButton;
@property (weak, nonatomic) UIButton *senderButton;
@property (weak, nonatomic) UILabel *originalLabel;
@property (assign, nonatomic) NSInteger bytes;

@end

@implementation LYAssetGridToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self previewButton];
        [self originalButton];
        [self originalLabel];
        [self senderButton];
    }
    return self;
}

#pragma mark - lazy
- (UIButton *)previewButton
{
    if (!_previewButton) {
        UIButton *previewButton = [[UIButton alloc] init];
        [previewButton setTitle:@"预览" forState:UIControlStateNormal];
        [previewButton setTitleColor:color227shallblue forState:UIControlStateNormal];
        [previewButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [previewButton setEnabled:NO];
        [previewButton addTarget:self action:@selector(clickPreviewButton:) forControlEvents:UIControlEventTouchUpInside];
        [previewButton sizeToFit];
        _previewButton = previewButton;
        [self addSubview:previewButton];
    }
    
    return _previewButton;
}

- (UIButton *)originalButton
{
    if (!_originalButton) {
        UIButton *originalButton = [[UIButton alloc] init];
        [originalButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [originalButton setTitle:@"  原图" forState:UIControlStateNormal];
        [originalButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [originalButton setTitleColor:color227shallblue forState:UIControlStateSelected];
        [originalButton setImage:[UIImage ly_imageNamed:@"file_unselected" withBundle:LYAssetBundleName] forState:UIControlStateNormal];
        
        [originalButton setImage:[UIImage ly_imageNamed:@"file_selected" withBundle:LYAssetBundleName] forState:UIControlStateSelected];
        //[originalButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [originalButton setUserInteractionEnabled:NO];
        [originalButton addTarget:self action:@selector(clickOriginalButton:) forControlEvents:UIControlEventTouchUpInside];
        [originalButton sizeToFit];
        _originalButton = originalButton;
        [self addSubview:_originalButton];
    }
    
    return _originalButton;
}

- (UILabel *)originalLabel
{
    if (!_originalLabel) {
        UILabel *originalLabel = [[UILabel alloc] init];
        [originalLabel setFont:[UIFont systemFontOfSize:16]];
        [originalLabel setHidden:YES];
        [originalLabel setTextColor:color227shallblue];
        _originalLabel = originalLabel;
        [self addSubview:_originalLabel];
    }
    
    return _originalLabel;
}

- (UIButton *)senderButton
{
    if (!_senderButton) {
        UIButton *senderButton = [[UIButton alloc] init];
        [senderButton setBackgroundImage:[UIImage ly_imageWithColor:globaBblue] forState:UIControlStateNormal];
        [senderButton setBackgroundImage:[UIImage ly_imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
        [senderButton setTitle:@"确定" forState:UIControlStateDisabled];
        [senderButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [senderButton.layer setCornerRadius:5];
        [senderButton.layer setMasksToBounds:YES];
        [senderButton setEnabled:NO];
        [senderButton addTarget:self action:@selector(clickSenderButton:) forControlEvents:UIControlEventTouchUpInside];
        senderButton.size = CGSizeMake(68, 29);
        _senderButton = senderButton;
        [self addSubview:_senderButton];
    }
    
    return _senderButton;
}

#pragma mark - allButton Action
- (void)clickPreviewButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didClickPreviewInAssetGridToolBar:)]) {
        [self.delegate didClickPreviewInAssetGridToolBar:self];
    }
}

- (void)clickOriginalButton:(UIButton *)button
{
    button.selected = !button.isSelected;
    
    [self calculateAllselectedItemsBytes];
    [self.delegate assetGridToolBar:self didClickOriginButton:button];
}

- (void)setOriginEnable:(BOOL)isOrigin {
    self.originalButton.selected = isOrigin;
    [self calculateAllselectedItemsBytes];
}

- (void)clickSenderButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didClickSenderButtonInAssetGridToolBar:)]) {
        [self.delegate didClickSenderButtonInAssetGridToolBar:self];
    }
}

- (void)setSelectedItems:(NSMutableArray *)selectedItems {
     _selectedItems = selectedItems;
    
    // 按钮能否点击
    self.previewButton.enabled = selectedItems.count > 0 ? YES : NO;
    self.originalButton.userInteractionEnabled = selectedItems.count > 0 ? YES : NO;
    self.senderButton.enabled = selectedItems.count > 0 ? YES : NO;
    
    // 按钮是否显示
    if (selectedItems.count == 0) self.originalButton.selected = NO;
    if (selectedItems.count > 0) [self.senderButton setTitle:[NSString stringWithFormat:@"确定(%ld)", (unsigned long)selectedItems.count] forState:UIControlStateNormal];
    if (selectedItems.count == 0) self.originalLabel.hidden = YES;
    
    // 显示大小
    [self calculateAllselectedItemsBytes];
}

// 计算所有选中image的大小
- (void)calculateAllselectedItemsBytes
{
    self.originalLabel.hidden = !self.originalButton.isSelected;
    if (self.originalButton.isSelected) {
        __block NSInteger dataLength = 0;
        __block NSInteger lastSelectedItem = 0;
        
        for (LYAsset *internalAsset in self.selectedItems) {
            lastSelectedItem++;
            dataLength += internalAsset.dataLength;
            
            if (lastSelectedItem == self.selectedItems.count) {
                NSString *bytes = nil;
                if (dataLength >= 0.1 * (1024 * 1024)) {
                    bytes = [NSString stringWithFormat:@"%0.1fM",dataLength/1024/1024.0];
                } else if (dataLength >= 1024) {
                    bytes = [NSString stringWithFormat:@"%0.0fK",dataLength/1024.0];
                } else {
                    bytes = [NSString stringWithFormat:@"%zdB",dataLength];
                }
                
                self.originalLabel.text = [NSString stringWithFormat:@"(%@)", bytes];
                
            }
        }
    }
}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
//#warning hpwys_makeConstraints
    
    CGFloat centerY = self.inCenterY;
    
    CGFloat left = 12;
    CGFloat margin = 10;
    
    _previewButton.center = CGPointMake(_previewButton.width * 0.5 + left, centerY);
    left += _previewButton.width;
    
    _originalButton.center = CGPointMake(_originalButton.width * 0.5 + margin + left, centerY);
    left += _originalButton.width + margin;
    _originalLabel.center = CGPointMake(_originalLabel.width * 0.5 + left, centerY);
    
    _senderButton.center = CGPointMake(self.width - _senderButton.width * 0.5 - 12, centerY);
//    [_previewButton hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
//        make.left.equalTo(self).offset(12);
//        make.centerY.equalTo(self);
//    }];
//
//    [_originalButton hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
//        make.left.equalTo(self).offset(80);
//        make.width.equalTo(@(70));
//        make.centerY.equalTo(self);
//    }];
//
//    [_originalLabel hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
//        make.centerY.equalTo(self);
//        make.left.equalTo(self.originalButton.hpwys_right);
//    }];
//
//    [_senderButton hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
//        make.right.equalTo(self).offset(-12);
//        make.centerY.equalTo(self);
//        make.height.equalTo(@(29));
//        make.width.equalTo(@(68));
//    }];
}

@end
