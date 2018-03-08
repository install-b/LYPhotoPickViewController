//
//  PHPhotoLibrary+Authorization.h
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2018/3/7.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//

#import <Photos/Photos.h>

typedef NS_ENUM(NSInteger,LYPhotoAuthorizationStatus) {
    LYAuthorizationStatusRestricted = 1,    //  没有授权
    LYAuthorizationStatusDenied,            //  无法获取到相册
    LYAuthorizationStatusAuthorized         //  已授权
};


typedef void(^LYPhotoAuthBlock)(LYPhotoAuthorizationStatus status);

@interface PHPhotoLibrary (Authorization)
+ (void)ly_requestAuthorizationWithBlock:(LYPhotoAuthBlock)block;
@end
