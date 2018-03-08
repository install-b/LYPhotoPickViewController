//
//  UIViewController+VisibleVc.h
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2018/3/7.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (VisibleVc)
+ (instancetype)ly_currentVisibleRootVcFromWindow:(UIWindow *)window;

+ (instancetype)ly_currentVisibleRootVcFromKeywindow;
@end
