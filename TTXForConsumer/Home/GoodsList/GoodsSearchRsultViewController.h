//
//  GoodsSearchRsultViewController.h
//  TTXForConsumer
//
//  Created by ttx on 16/7/2.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseViewController.h"

@interface GoodsSearchRsultViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)saleBtn:(UIButton *)sender;


- (IBAction)priceBtn:(UIButton *)sender;

- (IBAction)defaultBtn:(UIButton *)sender;

//类型id
@property (nonatomic, strong)NSString *typeId;
//搜索的商品名称
@property (nonatomic, strong)NSString *searchName;
//排序方式取值：price （按价格）salenum(按销量)
@property (nonatomic, strong)NSString *sort;
//u升序 down 降序
@property (nonatomic, strong)NSString *upDownFlag;

@property (weak, nonatomic) IBOutlet UIButton *defaltBtn;

@property (weak, nonatomic) IBOutlet UIButton *saleBtn;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *priceBtn;

@property (weak, nonatomic) IBOutlet UIImageView *priceImage;

//管id
@property (nonatomic, strong)NSString *venceId;
//管名字
@property (nonatomic, strong)NSString *venceName;
//活动id
@property (nonatomic, strong)NSString *activityId;
@end
