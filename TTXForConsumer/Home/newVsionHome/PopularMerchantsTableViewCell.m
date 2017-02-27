//
//  PopularMerchantsTableViewCell.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/14.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "PopularMerchantsTableViewCell.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "NewMerchantDetailViewController.h"
#import "NewMerchantDetailViewController.h"
#import "PrivateCustomCollectionViewCell.h"
#import "SecondActivityTableViewCell.h"

@implementation PopularMerModel

+ (id)modelWithDic:(NSDictionary *)dic
{
    PopularMerModel *model  = [[PopularMerModel alloc]init];
    model.aviableBalance = NullToNumber(dic[@"aviableBalance"]);
    model.mchCode = NullToSpace(dic[@"mchCode"]);
    model.mchName = NullToSpace(dic[@"mchName"]);
    model.pic = NullToSpace(dic[@"pic"]);
    return model;
}
@end

@interface PopularMerchantsTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong)NSMutableArray *dataSouceArray;


@property (nonatomic, strong)NSMutableArray *privteDataSouceArray;

@end

@implementation PopularMerchantsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.popularLabel.textColor = self.goodMLabel.textColor = self.shirenLabel.textColor = MacoTitleColor;
    
    self.collectionView.delegate =self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setIsAlreadyRefrefsh:(BOOL)isAlreadyRefrefsh
{
    _isAlreadyRefrefsh = isAlreadyRefrefsh;
    [self getPopularMRequest];
    //私人定制接口
    [self getRequest];
    
}


- (NSMutableArray *)dataSouceArray
{
    if (!_dataSouceArray) {
        _dataSouceArray = [NSMutableArray array];
    }
    return _dataSouceArray;
}

- (NSMutableArray *)privteDataSouceArray
{
    if (!_privteDataSouceArray) {
        _privteDataSouceArray = [NSMutableArray array];
    }
    return _privteDataSouceArray;
}

- (void)getPopularMRequest{
    NSDictionary *parms = @{@"city":[TTXUserInfo shareUserInfos].locationCity};
    [HttpClient POST:@"mch/hotMchs" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            [self.dataSouceArray removeAllObjects];
            for (NSDictionary *dic in jsonObject[@"data"]) {
                PopularMerModel *model = [PopularMerModel modelWithDic:dic];
                [self.dataSouceArray addObject:model];
            }
            
            if (self.dataSouceArray.count >0) {
                self.label1st.text = ((PopularMerModel *)self.dataSouceArray[0]).mchName;
                [self.button1st sd_setBackgroundImageWithURL:[NSURL URLWithString:((PopularMerModel *)self.dataSouceArray[0]).pic] forState:UIControlStateNormal placeholderImage:LoadingErrorImage];

            }
            if (self.dataSouceArray.count >1) {
                self.label2st.text = ((PopularMerModel *)self.dataSouceArray[1]).mchName;
                [self.button2st sd_setBackgroundImageWithURL:[NSURL URLWithString:((PopularMerModel *)self.dataSouceArray[1]).pic] forState:UIControlStateNormal placeholderImage:LoadingErrorImage];
                
            }
            if (self.dataSouceArray.count >2) {
                self.label3st.text = ((PopularMerModel *)self.dataSouceArray[2]).mchName;
                [self.button3st sd_setBackgroundImageWithURL:[NSURL URLWithString:((PopularMerModel *)self.dataSouceArray[2]).pic] forState:UIControlStateNormal placeholderImage:LoadingErrorImage];
                
            }
            
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];

}


- (void)getRequest{
    [HttpClient POST:@"find/mch/list" parameters:nil success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            [self.privteDataSouceArray removeAllObjects];
            NSArray *array = jsonObject[@"data"];
            for (NSDictionary *dic in array) {
                [self.privteDataSouceArray addObject:[SecondACtivityModel modelWithDic:dic]];
            }
            [self.collectionView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}


- (IBAction)button1stAction:(id)sender {
    
    if (self.dataSouceArray.count<1) {
        return;
    }
    NewMerchantDetailViewController *merchantDVC = [[NewMerchantDetailViewController alloc]init];
    PopularMerModel *model = self.dataSouceArray[0];
    merchantDVC.merchantCode = model.mchCode;
    [self.viewController.navigationController pushViewController:merchantDVC animated:YES];
}


- (IBAction)button2stAction:(id)sender {
    if (self.dataSouceArray.count<2) {
        return;
    }
    NewMerchantDetailViewController *merchantDVC = [[NewMerchantDetailViewController alloc]init];
    PopularMerModel *model = self.dataSouceArray[1];
    merchantDVC.merchantCode = model.mchCode;
    [self.viewController.navigationController pushViewController:merchantDVC animated:YES];
}


- (IBAction)button3stAction:(id)sender {
    
    if (self.dataSouceArray.count<3) {
        return;
    }
    NewMerchantDetailViewController *merchantDVC = [[NewMerchantDetailViewController alloc]init];
    PopularMerModel *model = self.dataSouceArray[2];
    merchantDVC.merchantCode = model.mchCode;
    [self.viewController.navigationController pushViewController:merchantDVC animated:YES];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   
    return self.privteDataSouceArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier =[PrivateCustomCollectionViewCell indentify];
    static BOOL nibri =NO;
    if(!nibri)
    {
        UINib *nib = [PrivateCustomCollectionViewCell newCell];
        [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
        nibri =YES;
    }
    PrivateCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.dataModel = self.privteDataSouceArray[indexPath.item];
    nibri=NO;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SecondACtivityModel *model = self.privteDataSouceArray[indexPath.item];
    switch ([model.jumpWay integerValue]) {
        case 3:
        {
            BaseHtmlViewController *htmlVC = [[BaseHtmlViewController alloc]init];
            htmlVC.htmlUrl = model.jumpValue;
            if ([model.remark isEqualToString:@""] ) {
                htmlVC.isAboutMerChant = NO;
            }else{
                htmlVC.isAboutMerChant = YES;
                htmlVC.merchantCode = model.remark;
            }
            htmlVC.htmlTitle = model.name;
            [self.viewController.navigationController pushViewController:htmlVC animated:YES];
        }
            
            break;
            
        default:
            break;
    }
    
    
}


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (self.sortDataSouceArray.count < 5) {
    //        return CGSizeMake(TWitdh/self.sortDataSouceArray.count, 50);
    //    }
    return CGSizeMake((TWitdh- 24)/3., TWitdh * (26/75.));
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



@end
