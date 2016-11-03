//
//  ChooseTypeView.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/28.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "ChooseTypeView.h"
#import "ChooseTypeTableViewCell.h"
#import "SureOrderViewController.h"
#import "Watch.h"
#import "TypeView.h"


@interface ChooseTypeView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSArray *guigeArray;

@property (nonatomic, assign)CGFloat cellheight;

@end

@implementation ChooseTypeView


- (void)awakeFromNib
{
    self.backView.backgroundColor = [UIColor colorFromHexString:@"#ccd8e2"];

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"ChooseTypeView" owner:nil options:nil][0];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.buyBtn.backgroundColor = MacoColor;
        self.buyBtn.layer.cornerRadius = 35/2.;
        self.buyBtn.layer.masksToBounds = YES;
        self.cellheight = 0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self.backView addGestureRecognizer:tap];

    }
    return self;
}

- (void)tap
{
    [self removeFromSuperview];
}

- (void)setDataModel:(Watch *)dataModel
{
    _dataModel = dataModel;
    [self getGoodsSpec:_dataModel.mch_id];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ChooseTypeTableViewCell indentify]];
    if (!cell) {
        cell = [ChooseTypeTableViewCell newCell];
    }
    if (self.dataModel) {
        cell.dataModel = self.dataModel;
    }
    if (self.guigeArray) {
        cell.guigeArray = self.guigeArray;
    }

    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellheight;
}

#pragma mark - 获取商品规格
- (void)getGoodsSpec:(NSString *)goodsId
{
    [HttpClient GET:@"shop/goodsSpec/get" parameters:@{@"id":goodsId} success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            NSArray *array = jsonObject[@"data"];
            self.guigeArray = array;
            
            
            CGFloat numbertop = 0;
            for (int i = 0; i < self.guigeArray.count; i ++) {
                TypeView *view = [[TypeView alloc]initWithFrame:CGRectMake(0, TWitdh/(15/4.5) + 15, TWitdh, 50) andDatasource:_guigeArray[i][@"specList"] :_guigeArray[i][@"specAttr"]];
                view.bounds = CGRectMake(0, 0, TWitdh, view.height);
                numbertop += view.height;
            }
            self.cellheight = numbertop +  80 + TWitdh/(15/4.5) + 15;
            
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}


- (IBAction)buyBtn:(UIButton *)sender {
    if (![TTXUserInfo shareUserInfos].currentLogined) {
        //判断是否先登录
        [self loginController];
        return;
    }
    ChooseTypeTableViewCell *cell =  self.tableView.visibleCells[0];
    NSDictionary *dic = @{@"yetSelcetPre":[cell.yetSelectLabel.text substringFromIndex:4],
                          @"number":NullToNumber(cell.numberTF.text),
                          @"price":NullToNumber(cell.goodsPrice.text)
                          };
    SureOrderViewController *sureVC = [[SureOrderViewController alloc]init];
    sureVC.mch_model = cell.dataModel;
    sureVC.goosPramsDic = dic;
    [self.viewController.navigationController pushViewController:sureVC animated:YES];
    [self removeFromSuperview];
}

#pragma mark - 登录
- (void)loginController
{
    UINavigationController *navc = [LoginViewController controller];
    [self.viewController presentViewController:navc animated:YES completion:NULL];
}
@end
