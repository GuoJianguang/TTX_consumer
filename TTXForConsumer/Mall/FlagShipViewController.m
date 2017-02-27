//
//  FlagShipViewController.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/27.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "FlagShipViewController.h"
#import "FlagshipCollectionViewCell.h"
#import "GoodsSearchRsultViewController.h"

@interface FlagShipViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation FlagShipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"旗舰店";
    self.collectionView.backgroundColor = [UIColor clearColor];
}


- (void)setFlagShipArray:(NSMutableArray *)flagShipArray
{
    _flagShipArray = flagShipArray;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //    if (self.sortDataSouceArray.count < 5) {
    //        return self.sortDataSouceArray.count;
    //    }
    return self.flagShipArray.count;
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
    cell.dataModel = self.flagShipArray[indexPath.item];
    nibri=NO;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FlagShipDataModel *model = self.flagShipArray[indexPath.item];
    GoodsSearchRsultViewController *resultVC = [[GoodsSearchRsultViewController alloc]init];
    resultVC.venceId = model.flagShipId;
    resultVC.venceName = model.name;
    resultVC.searchName = @"";
    [self.navigationController pushViewController:resultVC animated:YES];
}


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (self.sortDataSouceArray.count < 5) {
    //        return CGSizeMake(TWitdh/self.sortDataSouceArray.count, 50);
    //    }
    return CGSizeMake((TWitdh- 16)/3., (TWitdh*(490/750.)-(TWitdh *(8/75.)))/2.);
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
