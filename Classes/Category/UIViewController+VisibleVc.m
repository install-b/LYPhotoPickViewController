//
//  UIViewController+VisibleVc.m
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2018/3/7.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//

#import "UIViewController+VisibleVc.h"

@implementation UIViewController (VisibleVc)
+ (instancetype)ly_currentVisibleRootVcFromWindow:(UIWindow *)window {
    return [window.rootViewController ly_visibleVc];
}

+ (instancetype)ly_currentVisibleRootVcFromKeywindow {
    return [self  ly_currentVisibleRootVcFromWindow:[UIApplication sharedApplication].keyWindow];
}


- (UIViewController *)ly_visibleVc {
    if (self.view.window) {
        return self;
    }else {
        return [self.presentedViewController ly_visibleVc];
    }
}
@end
