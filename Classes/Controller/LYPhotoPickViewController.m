//
//  LYPhotoPickViewController.m
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2018/3/6.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//


#import "LYPhotoPickViewController.h"
#import "LYAssetPhotoNavigationController.h"
#import "LYAssetPreviewController.h"

#import "LYAssetGridCollectionView.h"
#import "LYAssetGridCell.h"
#import "LYAssetGridToolBar.h"

#import "LYAsset.h"

#import "UIView+Frame.h"
#import "PHPhotoLibrary+Authorization.h"
#import "UIViewController+VisibleVc.h"
#import "PHAsset+FetchAsset.h"
#import "LYAssetPhotoConst.h"


@interface LYPhotoPickViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,LYAssetGridCellDelegate, LYAssetGridToolBarDelegate, LYAssetViewControllerDelegate>

@property (weak, nonatomic) LYAssetGridToolBar *assetGridToolBar;
@property (weak, nonatomic) LYAssetGridCollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *selectedItems;
@property (strong, nonatomic) NSArray <LYAsset *>* assetArray;


@property (strong, nonatomic) PHFetchResult *allPhotos;
@property (weak, nonatomic) id<LYPhotoPickViewControllerDelegate> delegate;

/** <#des#> */
@property (nonatomic,weak) UIViewController * pushVc;

/** <#des#> */
@property(nonatomic,assign,getter=isOriginSelected) BOOL originSelected;
@end


@implementation LYPhotoPickViewController
static NSString *const LYAssetGridViewCellId = @"LYAssetGridViewCellId";

#pragma mark - init
- (instancetype)initWithDelegate:(id <LYPhotoPickViewControllerDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}
- (void)showAssetGridViewController {
    [self showAssetGridViewControllerWithNavigationVc:[[LYAssetPhotoNavigationController alloc] init]];
}
- (void)showAssetGridViewControllerWithNavigationVc:(UINavigationController *)nav {
    
    [PHPhotoLibrary ly_requestAuthorizationWithBlock:^(LYPhotoAuthorizationStatus status) {
        if (status == LYAuthorizationStatusAuthorized) {
            UIViewController *vc = [UIViewController ly_currentVisibleRootVcFromKeywindow];
            if (vc == nil) {
                return;
            }
            // 获取全部相册
            self.allPhotos = [PHAsset ly_fetchAllAssets];
            
            if (nav.view.window) {
                _pushVc = [nav topViewController];
                return [nav pushViewController:self animated:YES];
            }
            [nav pushViewController:self animated:NO];
            
            [vc presentViewController:nav animated:YES completion:nil];
            
        }else {
            if ([self.delegate respondsToSelector:@selector(photoPickViewController:notFetchPhotoWithStatus:)]) {
                [self.delegate photoPickViewController:self notFetchPhotoWithStatus:status];
            }
        }
    }];
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self.collectionView reloadData];
    [self assetGridToolBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.collectionView reloadData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 拦截点击事件
}

#pragma mark - nav
- (void)setupNav {
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickReturnButton) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)clickReturnButton {
    [self dismissViewControllerWithSelectedItems:nil];
}

- (void)didSelectOutOfMaxCount:(NSInteger)maxCount {
    if ([self.delegate respondsToSelector:@selector(photoPickViewController:didSelectOutOfMaxCount:)]) {
        [self.delegate photoPickViewController:self didSelectOutOfMaxCount:maxCount];
    }
}

// 最大选择图片数 不实现默认为5
- (NSInteger)maxSelectedCount {
    if ([self.delegate respondsToSelector:@selector(maxSelectedCount)]) {
        NSInteger count = [self.delegate maxSelectedCountWithPhotoPickViewController:self];
        return (count > 0) ? count : maxSelectedImageCount;
    }
    return maxSelectedImageCount;
}
#pragma jump vc
- (void)pushPreviewControllerWithAssetArray:(NSArray <LYAsset *>*)assetArray selectIndex:(NSInteger)selectItem {
    LYAssetPreviewController *assetVc = [[LYAssetPreviewController alloc] initWithAssetArray:assetArray maxSelectCount:[self maxSelectedCount]];
    assetVc.selectedItems = self.selectedItems;
    assetVc.index = selectItem;
    assetVc.delegate = self;
    assetVc.originSelect = self.isOriginSelected;
    [self.navigationController pushViewController:assetVc animated:YES];
}

- (void)dismissViewControllerWithSelectedItems:(NSArray <LYAsset *>*)assets {
    // 发送完成
    if (assets.count) {
        if ([self.delegate respondsToSelector:@selector(photoPickViewController:didPickImages:)]) {
            [self.delegate photoPickViewController:self didPickImages:[LYAsset ly_imageArrayFromAssets:assets compressTargetWidth:0]];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(photoPickViewControllerDidCancel:)]) {
            [self.delegate photoPickViewControllerDidCancel:self];
        }
    }
    
    if (self.pushVc) {
        [self.navigationController popToViewController:self.pushVc animated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LYAssetGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LYAssetGridViewCellId forIndexPath:indexPath];
    
    LYAsset *internalAsset = self.assetArray[indexPath.item];
    internalAsset.assetGridThumbnailSize = self.collectionView.assetGridThumbnailSize;
    cell.internalAsset = internalAsset;
    cell.delegate = self;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self pushPreviewControllerWithAssetArray:self.assetArray selectIndex:indexPath.item];
}


#pragma mark - LYAssetGridToolBarDelegate
// 点击了预览
- (void)didClickPreviewInAssetGridToolBar:(LYAssetGridToolBar *)assetGridToolBar {
    [self pushPreviewControllerWithAssetArray:[NSArray arrayWithArray:self.selectedItems] selectIndex:0];
}

// 监听assetGridToolBar确定按钮
- (void)didClickSenderButtonInAssetGridToolBar:(LYAssetGridToolBar *)assetGridToolBar {
    [self dismissViewControllerWithSelectedItems:self.selectedItems];
}

- (void)assetGridToolBar:(LYAssetGridToolBar *)assetGridToolBar didClickOriginButton:(UIButton *)btn {
    self.originSelected = btn.selected;
}

#pragma mark - LYAssetViewControllerDelegate
// 点击了原图按钮
- (void)assetPreviewController:(LYAssetPreviewController *)assetPreviewController didSelectOrigin:(BOOL)isOrigin {
    self.originSelected = isOrigin;
    [self.assetGridToolBar setOriginEnable:isOrigin];
}

// 点击确定按钮
- (void)assetPreviewController:(LYAssetPreviewController *)assetPreviewController didClickSenderButton:(NSMutableArray *)selectedItems {
    [self dismissViewControllerWithSelectedItems:self.selectedItems];
}

// 超过最大的选择数量
- (void)assetPreviewController:(LYAssetPreviewController *)assetPreviewController didSelectOutOfMaxCount:(NSInteger)maxCount {
    [self didSelectOutOfMaxCount:maxCount];
}

// 监听assetGridCell中选中的图片
#pragma mark - LYAssetGridCellDelegate
- (BOOL)assetGridCell:(LYAssetGridCell *)assetGridCell shouldChangeSelectedWithAsset:(LYAsset *)asset {
    BOOL selected = !asset.selected;
    if (selected) {
        NSInteger maxCount = [self maxSelectedCount];
        if ((self.selectedItems.count + 1) > maxCount) {
            
            [self didSelectOutOfMaxCount:maxCount];
            
            return NO;
        }
        
        [self.selectedItems addObject:assetGridCell.internalAsset];
    } else {
        [self.selectedItems removeObject:assetGridCell.internalAsset];
    }
    
    self.assetGridToolBar.selectedItems = self.selectedItems;
    return YES;
}


#pragma mark - lazy load
- (NSMutableArray *)selectedItems
{
    if (!_selectedItems) {
        _selectedItems = [NSMutableArray array];
    }
    
    return _selectedItems;
}

- (NSArray <LYAsset *>*)assetArray {
    if (!_assetArray) {
        _assetArray = [LYAsset arrayFromPHFetchResult:self.allPhotos];
    }
    return _assetArray;
}
- (LYAssetGridCollectionView *)collectionView {
    if (!_collectionView) {
        LYAssetGridCollectionView *collectionView = [[LYAssetGridCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - toolBarHeight) column:col itemMargin:gridMargin];
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        [collectionView registerClass:[LYAssetGridCell class] forCellWithReuseIdentifier:LYAssetGridViewCellId];
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
#else
        self.automaticallyAdjustsScrollViewInsets = NO;
#endif
        
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, navBarHeight, 0);
        _collectionView = collectionView;
        
        [self.view addSubview:self.collectionView];
    }
    return _collectionView;
}

-  (LYAssetGridToolBar *)assetGridToolBar {
    if (!_assetGridToolBar) {
        LYAssetGridToolBar *toolbar = [[LYAssetGridToolBar alloc] initWithFrame:CGRectMake(0, self.view.height - toolBarHeight - navBarHeight, self.view.width, toolBarHeight)];
        toolbar.delegate = self;
        _assetGridToolBar = toolbar;
        [self.view addSubview:_assetGridToolBar];
    }
    return _assetGridToolBar;
}

@end
