//
//  PopularMerchantsTableViewCell.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/14.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "PopularMerchantsTableViewCell.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "MerchantDetailViewController.h"
#import "NewMerchantDetailViewController.h"

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

@interface PopularMerchantsTableViewCell()

@property (nonatomic, strong)NSMutableArray *dataSouceArray;

@end

@implementation PopularMerchantsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.popularLabel.textColor = self.goodMLabel.textColor = MacoTitleColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setIsAlreadyRefrefsh:(BOOL)isAlreadyRefrefsh
{
    _isAlreadyRefrefsh = isAlreadyRefrefsh;
    [self getPopularMRequest];
    
}


- (NSMutableArray *)dataSouceArray
{
    if (!_dataSouceArray) {
        _dataSouceArray = [NSMutableArray array];
    }
    return _dataSouceArray;
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
    MerchantDetailViewController *merchantDVC = [[MerchantDetailViewController alloc]init];
    PopularMerModel *model = self.dataSouceArray[1];
    merchantDVC.merchantCode = model.mchCode;
    [self.viewController.navigationController pushViewController:merchantDVC animated:YES];
    
}


- (IBAction)button3stAction:(id)sender {
    
    if (self.dataSouceArray.count<3) {
        return;
    }
    MerchantDetailViewController *merchantDVC = [[MerchantDetailViewController alloc]init];
    PopularMerModel *model = self.dataSouceArray[2];
    merchantDVC.merchantCode = model.mchCode;
    [self.viewController.navigationController pushViewController:merchantDVC animated:YES];
}

@end
