//
//  LYAssetPreviewController.m
//  LYAssetPhoto
//
//  Created by Shangen Zhang on 2018/3/6.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//


#import "LYAssetPreviewController.h"
#import "LYAssetCell.h"
#import "LYAsset.h"
#import "UIView+Frame.h"
#import "LYAssetPhotoConst.h"
#import "LYAssetToolBar.h"
#import "UIImageView+AssetImage.h"
#import "LYFullItemCollectionView.h"
#import "UIImage+Common.h"

@interface LYAssetPreviewController ()<UICollectionViewDelegate, UICollectionViewDataSource,LYAssetToolBarDelegate>

/** LYAssetToolBar * */
@property (nonatomic,weak) LYAssetToolBar  * toolBar;

/** collectionView */
@property (nonatomic,weak) LYFullItemCollectionView * collectionView;

/** 导航选择按钮 */
@property (nonatomic,weak) UIButton * selectedButton;

/** 最大选择数量 */
@property(nonatomic,assign,readonly) NSUInteger maxSlectedCount;
@end



@implementation LYAssetPreviewController

static NSString * const LYAssetViewCellId = @"LYAssetViewCellId";

- (instancetype)initWithAssetArray:(NSArray <LYAsset *>*)assetArray maxSelectCount:(NSUInteger)maxSelecedCount{
    if (self = [super init]) {
        _assetArray = assetArray;
        _maxSlectedCount = maxSelecedCount;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = previewBg;
    // 设置导航
    [self setupNav];
    // 进入当前控制器后,显示的图片
    [self.collectionView setContentOffset:CGPointMake(self.view.width * self.index, 0)];
    // 加载tooBar
    [self toolBar];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated ];
    [self updateToolBar];
}

- (void)setupNav {
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

#pragma mark - update
- (void)updateToolBar {
    LYAsset *internalAsset = [self currentAsset];
    
    self.selectedButton.selected = internalAsset.isSelected;
    self.toolBar.originalButton.selected = self.isOriginSelect;
    [self.toolBar updateOriginImageBytes:internalAsset.bytes ?: @""];
    [self.toolBar setSenderCount:self.selectedItems.count];
}
- (LYAsset *)currentAsset{
    if (self.index >= 0 && self.assetArray.count && self.index < self.assetArray.count) {
        return self.assetArray[self.index];
    }
    return nil;
}

#pragma mark - setter and getter
- (void)setIndex:(NSInteger)index {
    if (_index == index) {
        return;
    }
    _index = index;
    self.selectedButton.selected = [(LYAsset *)self.assetArray[index] isSelected];
    [self updateToolBar];
}
- (LYAssetToolBar *)toolBar {
    if (!_toolBar) {
        LYAssetToolBar *toolBar = [[LYAssetToolBar alloc] initWithFrame:CGRectMake(0, self.view.height - toolBarHeight - navBarHeight, self.view.width, toolBarHeight)];
        toolBar.delegate = self;
        
        [self.view addSubview:toolBar];
        _toolBar = toolBar;
    }
    return _toolBar;
}
- (UIButton *)selectedButton {
    if (!_selectedButton) {
         UIButton *selectedButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        
        [selectedButton setBackgroundImage:[UIImage ly_imageNamed:@"photoPickerVc_sel" withBundle:LYAssetBundleName] forState:UIControlStateSelected];
        [selectedButton setBackgroundImage:[UIImage ly_imageNamed:@"photoPickerVc_def" withBundle:LYAssetBundleName] forState:UIControlStateNormal];
        
        [selectedButton addTarget:self action:@selector(clickSelectedButton:) forControlEvents:UIControlEventTouchDown
         ];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:selectedButton];
        _selectedButton = selectedButton;
    }
    return _selectedButton;
}

- (LYFullItemCollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat collectionHeight = self.view.height - CGRectGetMaxY(self.navigationController.navigationBar.frame) - toolBarHeight;
        LYFullItemCollectionView *collectionView = [[LYFullItemCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, collectionHeight)];
        collectionView.delegate = self;
        collectionView.dataSource = self;
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
#else
        self.automaticallyAdjustsScrollViewInsets = NO;
#endif
        [collectionView registerClass:[LYAssetCell class] forCellWithReuseIdentifier:LYAssetViewCellId];
        [self.view addSubview:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LYAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LYAssetViewCellId forIndexPath:indexPath];
    [cell.imageView setImageWithAsset:self.assetArray[indexPath.item].asset];
    return cell;
}
#pragma mark - scrollview delegate
// 页码设置
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self collectionViewDidEndScroll:scrollView];
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self collectionViewDidEndScroll:scrollView];
    
}
- (void)collectionViewDidEndScroll:(UIScrollView *)scrollView {
    self.index =  (NSInteger)(scrollView.contentOffset.x / scrollView.width);
}


#pragma mark - LYAssetToolBarDelegate
- (void)assetToolBar:(LYAssetToolBar *)toolBar clickOriginalButton:(UIButton *)button {
    
    // 点击后,计算当前图片的大小
    if (button.isSelected == YES) {
        [toolBar updateOriginImageBytes:self.assetArray[self.index].bytes];
    }
    if ([self.delegate respondsToSelector:@selector(assetPreviewController:didSelectOrigin:)]) {
        [self.delegate assetPreviewController:self didSelectOrigin:button.isSelected];
    }
    
}
- (void)assetToolBar:(LYAssetToolBar *)toolBar clickSenderButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(assetPreviewController:didClickSenderButton:)]) {
        [self.delegate assetPreviewController:self didClickSenderButton:self.selectedItems];
    }
}

#pragma mark - nav events
- (void)clickBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickSelectedButton:(UIButton *)selectedButton {
    
    BOOL selected = !selectedButton.isSelected;
    
    if (selected == YES && (self.selectedItems.count >= self.maxSlectedCount)) {
        return [self.delegate assetPreviewController:self didSelectOutOfMaxCount:self.maxSlectedCount];
    }
    
    selectedButton.selected = selected;
    
    // 当前显示的图片
    LYAsset *internalAsset = self.assetArray[self.index];
    internalAsset.selected = selected;
    
    // 添加/删除
    if (selected) {
        [self.selectedItems addObject:internalAsset];
    } else {
        [self.selectedItems removeObject:internalAsset];
    }
    
    // 更新toolbar
    [self updateToolBar];
}


@end
