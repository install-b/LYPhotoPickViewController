//
//  LYAssetToolBar.m
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2018/3/6.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//


#import "LYAssetToolBar.h"
#import "LYAsset.h"
#import "LYAssetPhotoConst.h"
//#import "UIImageView+AssetImage.h"
#import "UIView+Frame.h"
#import "UIImage+Common.h"
@interface LYAssetToolBar ()



@property (weak, nonatomic) UIButton *senderButton;

@property (assign, nonatomic) NSInteger bytes;

@end

@implementation LYAssetToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = previewBg;
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews {
    // 原图按钮
    UIButton *originalButton = [[UIButton alloc] init];
    [originalButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [originalButton setTitle:@"  原图" forState:UIControlStateNormal];
    [originalButton setTitleColor:LYColor(93, 93, 93) forState:UIControlStateNormal];
    [originalButton setTitleColor:LYColor(224, 224, 224) forState:UIControlStateSelected];
    
    
    [originalButton setImage:[UIImage ly_imageNamed:@"photo_original_def" withBundle:LYAssetBundleName] forState:UIControlStateNormal];
    [originalButton setImage:[UIImage ly_imageNamed:@"photo_original_sel" withBundle:LYAssetBundleName] forState:UIControlStateSelected];
    //[originalButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
    [originalButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [originalButton addTarget:self action:@selector(clickOriginalButton:) forControlEvents:UIControlEventTouchUpInside];
    [originalButton sizeToFit];
    originalButton.width = 130;
    _originalButton = originalButton;
    
    [self addSubview:_originalButton];

    
    // 确定按钮
    UIButton *senderButton = [[UIButton alloc] init];
    [senderButton setTitle:@"确定" forState:UIControlStateDisabled];
    [senderButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [senderButton setBackgroundImage:[UIImage ly_imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    [senderButton setBackgroundImage:[UIImage ly_imageWithColor:globaBblue] forState:UIControlStateNormal];
    [senderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [senderButton.layer setCornerRadius:5];
    [senderButton.layer setMasksToBounds:YES];
    senderButton.size = CGSizeMake(68, 29);
//    [senderButton setTitleColor:LYColor(93, 93, 93) forState:UIControlStateDisabled];
//    [senderButton setTitleColor:globaBblue forState:UIControlStateNormal];
    [senderButton setEnabled:NO];
    [senderButton addTarget:self action:@selector(clickSenderButton:) forControlEvents:UIControlEventTouchUpInside];
    //[senderButton sizeToFit];
    _senderButton = senderButton;
    [self addSubview:_senderButton];
}


- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat centerY = self.inCenterY;
    CGFloat leftRight = 10;
    //[_originalButton sizeToFit];
    _originalButton.center = CGPointMake(leftRight + _originalButton.inCenterX, centerY);
    //[_senderButton sizeToFit];
    _senderButton.center = CGPointMake(self.width - (leftRight + _senderButton.inCenterX), centerY);

}
- (void)clickOriginalButton:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if ([self.delegate respondsToSelector:@selector(assetToolBar:clickOriginalButton:)]) {
        [self.delegate assetToolBar:self clickOriginalButton:sender];
    }
}
- (void)clickSenderButton:(id)sender  {
    if ([self.delegate respondsToSelector:@selector(assetToolBar:clickSenderButton:)]) {
        [self.delegate assetToolBar:self clickSenderButton:sender];
    }
}

- (void)setSenderCount:(NSUInteger)count {
    if (count == 0) {
        self.senderButton.enabled = NO;
    } else {
        self.senderButton.enabled = YES;
        [self.senderButton setTitle:[NSString stringWithFormat:@"确定(%zd)",count] forState:UIControlStateNormal];
    }
}

- (void)updateOriginImageBytes:(NSString *)bytes {
    // 滚动后,计算当前图片的大小
    if (self.originalButton.selected == YES) {
        [self.originalButton setTitle:[NSString stringWithFormat:@"  原图(%@)",bytes] forState:UIControlStateSelected];
//        [self.originalButton sizeToFit];
        //[self layoutSubviews];
    }
}
@end

