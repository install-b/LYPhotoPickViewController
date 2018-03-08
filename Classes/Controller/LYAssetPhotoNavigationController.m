//
//  LYAssetPhotoNavigationController.m
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2018/3/6.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//

#import "LYAssetPhotoNavigationController.h"
#import "LYAssetPhotoConst.h"
#import "UIImage+Common.h"

@interface LYAssetPhotoNavigationController ()

@end

@implementation LYAssetPhotoNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpNav];
}

- (void)setUpNav {
    
    UINavigationBar *bar = self.navigationBar;
    bar.translucent = NO;
    
    UIColor *navBgColor = LYColor(47, 176, 252);
    [bar setBackgroundImage: [UIImage ly_imageWithColor:navBgColor] forBarMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[[UIImage alloc] init]];
    
    // 设置导航条字体
    NSMutableDictionary *attri = [NSMutableDictionary dictionary];
    attri[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attri[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    [bar setTitleTextAttributes:attri];
    
    //导航条主题颜色
    bar.tintColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 阻挡点击事件
}
@end
