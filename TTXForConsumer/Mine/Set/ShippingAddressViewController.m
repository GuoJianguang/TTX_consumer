//
//  ShippingAddressViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/24.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "ShippingAddressViewController.h"
#import "ShippingALTableViewCell.h"
#import "ShippingAlerTableViewCell.h"
#import "EditShippingAddressViewController.h"



@interface ShippingAddressViewController ()<UITableViewDelegate,UITableViewDataSource,BasenavigationDelegate>

@property (nonatomic, strong)NSMutableArray *dataSouceArray;

@end

@implementation ShippingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"收货地址";
    self.naviBar.hiddenDetailBtn = NO;
    self.naviBar.detailTitle = @"添加";
    self.naviBar.delegate = self;
    
    self.tableView.backgroundColor = [UIColor clearColor];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addressRequest];
}

- (NSMutableArray *)dataSouceArray
{
    if (!_dataSouceArray) {
        _dataSouceArray = [NSMutableArray array];
    }
    return _dataSouceArray;
}


#pragma mark - 地址的列表请求
- (void)addressRequest
{
    NSDictionary *parms = @{@"token":[TTXUserInfo shareUserInfos].token};
    [HttpClient POST:@"user/userInfo/address/get" parameters:parms success:^(AFHTTPRequestOperation *operation, id jsonObject) {
        if (IsRequestTrue) {
            NSArray *array = jsonObject[@"data"];
            [self.dataSouceArray removeAllObjects];
            for (NSDictionary *dic in array) {
                [self.dataSouceArray addObject:[ShippingAddressModel modelWithDic:dic]];
            }
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - 添加收货地址
- (void)detailBtnClick
{
    if (self.dataSouceArray.count == 5) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"您最多添加5个收货地址" duration:2.];
        return;
    }
    EditShippingAddressViewController *editVC = [[EditShippingAddressViewController alloc]init];
    editVC.isAddAddress = YES;
    [self.navigationController pushViewController:editVC animated:YES];
}

#pragma mark - UITableView

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
    EditShippingAddressViewController *editVC = [[EditShippingAddressViewController alloc]init];
    editVC.isAddAddress = NO;
    editVC.addressModel = self.dataSouceArray[indexPath.row];
    [self.navigationController pushViewController:editVC animated:YES];
    
    
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
