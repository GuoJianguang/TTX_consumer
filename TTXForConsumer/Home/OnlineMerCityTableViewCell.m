//
//  OnlineMerCityTableViewCell.m
//  TTXForConsumer
//
//  Created by Guo on 16/10/18.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "OnlineMerCityTableViewCell.h"
#import "OnlineMerCityCollectionViewCell.h"
#import "GoodsListViewController.h"
#import "GoodsSearchRsultViewController.h"

@interface OnlineMerCityTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>


@end

@implementation OnlineMerCityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView reloadData];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setVenceArray:(NSMutableArray *)venceArray
{
    _venceArray = venceArray;
    [self.collectionView reloadData];
}

#pragma mark - 分类
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
 
    return self.venceArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier =[OnlineMerCityCollectionViewCell indentify];
    static BOOL nibri =NO;
    if(!nibri)
    {
        UINib *nib = [OnlineMerCityCollectionViewCell newCell];
        [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
        nibri =YES;
    }
    OnlineMerCityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.dataModel = self.venceArray[indexPath.item];
    nibri=NO;
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    VenceDataModel *model = self.venceArray[indexPath.item];
    GoodsSearchRsultViewController *resultVC = [[GoodsSearchRsultViewController alloc]init];
    resultVC.venceId = model.venceId;
    resultVC.venceName = model.name;
    resultVC.searchName = @"";
    [self.viewController.navigationController pushViewController:resultVC animated:YES];
}


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    CGFloat width = TWitdh*(300/750.);
    return CGSizeMake(width, width);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark - 更多商品
- (IBAction)allGoodsBtn:(id)sender {
    
    GoodsListViewController *goodslistVC = [[GoodsListViewController alloc]init];
    [self.viewController.navigationController pushViewController:goodslistVC animated:YES];
}
@end
