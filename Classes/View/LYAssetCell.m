//
//  LYAssetCell.m
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2018/3/6.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//


#import "LYAssetCell.h"


@implementation LYAssetCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        imageV.userInteractionEnabled = YES;
        _imageView = imageV;
        [self.contentView addSubview:_imageView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat leftRight = 5.0f;
    
    CGRect frame = self.contentView.bounds;
    frame.origin.x += leftRight;
    frame.size.width -= 2 * leftRight;
    _imageView.frame = frame;

}
@end
