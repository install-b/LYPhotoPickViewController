//
//  LYAssetPhotoConst.h
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2018/3/6.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//

#ifndef LYAssetPhotoConst_h
#define LYAssetPhotoConst_h

#define LYColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define LYColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]


#define color227shallblue [UIColor colorWithRed:0.133 green:0.478 blue:0.898 alpha:1.000]
#define globaBblue LYColor(47, 176, 252)
#define previewBg [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1]


#define LYAssetBundleName @"LYAssetPhoto"

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


#define gridMargin 3
#define col 3
#define toolBarHeight 55
#define navBarHeight  (iPhoneX ? 88 : 64)


#define maxSelectedImageCount 5

#endif /* LYAssetPhotoConst_h */
