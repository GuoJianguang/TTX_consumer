//
//  MallDetailTableViewCell.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/23.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "MallDetailTableViewCell.h"
#import "FlagshipCollectionViewCell.h"

@interface MallDetailTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation MallDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if (self.sortDataSouceArray.count < 5) {
//        return self.sortDataSouceArray.count;
//    }
    return 6;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier =[FlagshipCollectionViewCell indentify];
    static BOOL nibri =NO;
    if(!nibri)
    {
        UINib *nib = [FlagshipCollectionViewCell newCell];
        [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
        nibri =YES;
    }
    FlagshipCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    nibri=NO;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    

}


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.sortDataSouceArray.count < 5) {
//        return CGSizeMake(TWitdh/self.sortDataSouceArray.count, 50);
//    }
    return CGSizeMake((TWitdh- 16)/3., (TWitdh/2-(TWitdh *(8/75.)))/2.);
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




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
