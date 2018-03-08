//
//  PHPhotoLibrary+Authorization.m
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2018/3/7.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//

#import "PHPhotoLibrary+Authorization.h"

@implementation PHPhotoLibrary (Authorization)
+ (void)ly_requestAuthorizationWithBlock:(LYPhotoAuthBlock)errorCallBack {
    if (errorCallBack == nil) return;
    // 获取当前的权限
    PHAuthorizationStatus oldAuthory = [PHPhotoLibrary authorizationStatus];
    
    // 发送相册权限请求
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 已授权
            if (status == PHAuthorizationStatusAuthorized) {
                return errorCallBack(LYAuthorizationStatusAuthorized);
            }
            
            // 未授权
            if ((status == PHAuthorizationStatusRestricted) ||
                ((status == PHAuthorizationStatusDenied) && (oldAuthory == PHAuthorizationStatusNotDetermined))) {
                return errorCallBack(LYAuthorizationStatusRestricted);
            }
            // 获取不到权限
            errorCallBack(LYAuthorizationStatusDenied);
        });
        
    }];
}

@end
