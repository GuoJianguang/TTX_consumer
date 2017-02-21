//
//  MerchantProductListView.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/20.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "MerchantProductListView.h"
#import "GoodsListTableViewCell.h"
#import "GoodsDetailNewViewController.h"
#import "MchchantAllgoodsViewController.h"

@interface MerchantProductListView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MerchantProductListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.talbeView.delegate = self;
    self.talbeView.dataSource = self;
    self.alerLabel.textColor = MacoDetailColor;
    self.backgroundColor = [UIColor clearColor];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"MerchantProductListView" owner:nil options:nil][0];
        self.gengduoLabel.textColor = MacoColor;

    }
    return self;
}



- (IBAction)moreBtn:(id)sender {
    
    MchchantAllgoodsViewController *allgoodsVC =[[MchchantAllgoodsViewController alloc]init];
    allgoodsVC.mchChantCode = self.mchCode;
    [self.viewController.navigationController pushViewController:allgoodsVC animated:YES];
}


- (void)setGoodsArray:(NSMutableArray *)goodsArray
{
    _goodsArray = goodsArray;
    if (_goodsArray.count == 0) {
        self.alerLabel.hidden = NO;
        self.moreBtn.enabled = NO;
    }else{
        self.alerLabel.hidden = YES;
        self.moreBtn.enabled = YES;
    }
    self.gengduoLabel.hidden = self.rightImageview.hidden= !self.alerLabel.hidden;

    [self.talbeView reloadData];

}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[GoodsListTableViewCell indentify]];
    if (!cell) {
        cell = [GoodsListTableViewCell newCell];
    }
    if (self.goodsArray.count > 0) {
        cell.dataModel = self.goodsArray[indexPath.row];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 80;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsListModel *model = self.goodsArray[indexPath.row];
    GoodsDetailNewViewController *detailvC = [[GoodsDetailNewViewController alloc]init];
    detailvC.goodsID = model.goodsId;
    [self.viewController.navigationController pushViewController:detailvC animated:YES];
        
}


@end
