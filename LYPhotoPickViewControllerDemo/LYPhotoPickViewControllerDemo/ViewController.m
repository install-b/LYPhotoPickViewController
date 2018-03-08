//
//  ViewController.m
//  LYPhotoPickViewControllerDemo
//
//  Created by Shangen Zhang on 2018/3/8.
//  Copyright © 2018年 Zhangsg. All rights reserved.
//

#import "ViewController.h"
#import "LYAssetGridCollectionView.h"
#import "LYPhotoPickViewController.h"
@interface ViewController () <LYPhotoPickViewControllerDelegate,UICollectionViewDataSource>
/** LYAssetGridCollectionView */
@property (nonatomic,weak) LYAssetGridCollectionView * collectionView;
/** <#des#> */
@property (nonatomic,strong) NSArray<UIImage *> * images;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height *= 0.8;
    LYAssetGridCollectionView *collectionView = [[LYAssetGridCollectionView alloc] initWithFrame:frame column:2 itemMargin:10];
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"123456"];
    
    collectionView.dataSource = self;
    
    [self.view addSubview: collectionView];
    self.collectionView = collectionView;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self showImage];
    
}


- (void)showImage {
    [[[LYPhotoPickViewController alloc] initWithDelegate:self] showAssetGridViewController];
}





- (void)photoPickViewController:(LYPhotoPickViewController *)PhotoPickViewController didPickImages:(NSArray<UIImage *> *)imageArray {
    self.images = imageArray;
    [self.collectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"123456" forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
    imageView.image = self.images[indexPath.item];
    
    cell.backgroundView = imageView;
    return cell;
}

@end
