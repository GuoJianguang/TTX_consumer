//
//  MallSelectShippingAddressViewController.m
//  tiantianxin
//
//  Created by ttx on 16/4/5.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "MallSelectShippingAddressViewController.h"
#import "MallShippingALTableViewCell.h"
//#import "AddShippingATableViewCell.h"
#import "EditShippingAddressViewController.h"
#import "ShippingAlerTableViewCell.h"

@interface MallSelectShippingAddressViewController ()<BasenavigationDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *dataSouceArray;

@property (nonatomic, assign)BOOL isEditShipping;

@end

@implementation MallSelectShippingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"选择收货地址";
    self.naviBar.hiddenDetailBtn = NO;
    self.naviBar.detailTitle = @"添加";
    self.naviBar.delegate = self;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.isEditShipping = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addressRequest];
}

- (void)detailBtnClick
{
    if (self.dataSouceArray.count == 5) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"您最多添加5个收货地址" duration:2.];
        return;
    }
    self.isEditShipping = !self.isEditShipping;
    EditShippingAddressViewController *editVC = [[EditShippingAddressViewController alloc]init];
    editVC.isAddAddress = YES;
    [self.navigationController pushViewController:editVC animated:YES];
//    if (self.isEditShipping) {
//        self.naviBar.detailTitle = @"完成";
//    }
//    [self.tableView reloadData];
}


- (void)addressRequest
{
    NSDictionary *parms = @{@"token":[TTXUserInfo shareUserInfos].token};
    [HttpClient POST:@"user/userInfo/address/get" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            NSArray *array = jsonObject[@"data"];
            [self.dataSouceArray removeAllObjects];
            for (NSDictionary *dic in array) {
                [self.dataSouceArray addObject:[MallShippingAddressModel modelWithDic:dic]];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

- (NSMutableArray *)dataSouceArray
{
    if (!_dataSouceArray) {
        _dataSouceArray = [NSMutableArray array];
    }
    return _dataSouceArray;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSouceArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == self.dataSouceArray.count) {
        ShippingAlerTableViewCell *cell = (ShippingAlerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[ShippingAlerTableViewCell indentify]];
        if (!cell) {
            cell = [ShippingAlerTableViewCell newCell];
        }
        return cell;
    }
    ShippingALTableViewCell *cell = (ShippingALTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[ShippingALTableViewCell indentify]];
    if (!cell) {
        cell = [ShippingALTableViewCell newCell];
    }
    cell.rightImage.hidden = YES;
    if (indexPath.row == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TWitdh, 1)];
        view.backgroundColor = [UIColor grayColor];
        view.alpha = 0.2;
        [cell.item_view addSubview:view];
    }
    if (indexPath.row == self.dataSouceArray.count - 1) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 79, TWitdh, 1)];
        view.backgroundColor = [UIColor grayColor];
        view.alpha = 0.2;
        cell.lineView.hidden = YES;
        [cell.item_view addSubview:view];
    }
    if (self.dataSouceArray.count > 0 && indexPath.row < self.dataSouceArray.count) {
        cell.dataModel = self.dataSouceArray[indexPath.row];
        
    }
    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataSouceArray.count) {
        return 44;
    }
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataSouceArray.count) {
        return;
    }
    MallShippingAddressModel *model = self.dataSouceArray[indexPath.row];
    NSDictionary *dic = @{@"model":model};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"selectAddress" object:nil userInfo:dic];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
