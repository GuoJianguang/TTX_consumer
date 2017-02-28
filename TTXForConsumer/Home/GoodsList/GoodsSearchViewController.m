//
//  GoodsSearchViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/7/2.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "GoodsSearchViewController.h"
#import "SortCollectionViewCell.h"
#import "IndustryCollectionViewCell.h"
#import "GoodsSearchRsultViewController.h"
#import "MoreDisCountViewController.h"

@interface GoodsSearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong)NSMutableArray *sortDataSouceArray;

@end

@implementation GoodsSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviBar.hidden = YES;
    self.searchView.layer.cornerRadius = 15.;
    self.searchView.layer.masksToBounds = YES;
    self.searchView.layer.borderWidth = 1;
    self.searchView.layer.borderColor = MacolayerColor.CGColor;
    
    self.serchTF.delegate = self;
    
    [self.cancelBtn setTitleColor:MacoColor forState:UIControlStateNormal];
    
    [self getGoodsTypeRequest];
}

- (void)setIsSerach:(BOOL)isSerach
{
    _isSerach = isSerach;
    self.collectionView.hidden = _isSerach;
}

#pragma mark- 懒加载

- (NSMutableArray *)sortDataSouceArray
{
    if (!_sortDataSouceArray) {
        _sortDataSouceArray = [NSMutableArray array];
    }
    return _sortDataSouceArray;
}

//获取所有商品类型
- (void)getGoodsTypeRequest
{
    [HttpClient GET:@"shop/goodsType/get" parameters:nil success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            [self.sortDataSouceArray removeAllObjects];
            NSArray *array = jsonObject[@"data"];
            for (NSDictionary *dic in array) {
                GoodsSort *model = [GoodsSort modelWithDic:dic];
                [self.sortDataSouceArray addObject:model];
            }
            [self.collectionView reloadData];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

#pragma mark - 分类
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.sortDataSouceArray.count;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier =[IndustryCollectionViewCell indentify];
    static BOOL nibri =NO;
    if(!nibri)
    {
        UINib *nib = [IndustryCollectionViewCell newCell];
        [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
        nibri =YES;
    }
    IndustryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (self.sortDataSouceArray.count > 0) {
        cell.goodsSortModel = self.sortDataSouceArray[indexPath.item];
    }
    nibri=NO;
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsSort *model = self.sortDataSouceArray[indexPath.item];
    [self.view removeFromSuperview];
    
    if (self.isDisCount) {
        MoreDisCountViewController *disCountVC = [[MoreDisCountViewController alloc]init];
        disCountVC.searchName = @"";
        disCountVC.typeId = model.sortId;
        [self.navigationController pushViewController:disCountVC animated:YES];
        return;
    }
    GoodsSearchRsultViewController *resultVC = [[GoodsSearchRsultViewController alloc]init];
    resultVC.typeId = model.sortId;
    resultVC.searchName = @"";
    [self.navigationController pushViewController:resultVC animated:YES];
    
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.sortDataSouceArray.count < 5) {
//        return CGSizeMake(TWitdh/self.sortDataSouceArray.count, 50);
//    }
    return CGSizeMake(TWitdh/3, TWitdh/3. *0.6);
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

- (IBAction)backBtn:(UIButton *)sender {
    //    [self.navigationController popViewControllerAnimated:YES];
    [self.view removeFromSuperview];
}

#pragma mark - 取消搜索的按钮
- (IBAction)cancelBtn:(UIButton *)sender {
    [self.view removeFromSuperview];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.collectionView.hidden = YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view removeFromSuperview];
    if (self.isDisCount) {
        MoreDisCountViewController *disCountVC = [[MoreDisCountViewController alloc]init];
        disCountVC.searchName = textField.text;
        textField.text = @"";
        [self.navigationController pushViewController:disCountVC animated:YES];
        return YES;
    }
    
    GoodsSearchRsultViewController *resultVC = [[GoodsSearchRsultViewController alloc]init];
    resultVC.searchName = textField.text;
    textField.text = @"";
    [self.navigationController pushViewController:resultVC animated:YES];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
