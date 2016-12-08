//
//  MyInvitationViewController.m
//  天添薪
//
//  Created by ttx on 16/1/11.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "MyInvitationViewController.h"
#import "MyWallectCollectionViewCell.h"
#import <UShareUI/UShareUI.h>



@implementation RecommendMerchantModel

+ (id)modelWithDic:(NSDictionary *)dic
{
    RecommendMerchantModel *model = [[RecommendMerchantModel alloc]init];
    model.mchCode = NullToSpace(dic[@"mchCode"]);
    model.mchName = NullToSpace(dic[@"mchName"]);

    return model;
}

@end


@interface MyInvitationViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,BasenavigationDelegate>

@property (nonatomic, assign)NSInteger page;//页数

@property (nonatomic, strong)NSMutableArray *dataSouceArray;
@property (nonatomic, strong)NSMutableArray *mchDataSouceArray;

@property (nonatomic, copy)NSString *targetMchCodeId;

@property (nonatomic, strong)UIView *backView;
@end

@implementation MyInvitationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"我的邀请";
//    self.mchLabel.adjustsFontSizeToFitWidth = YES;
    self.mchLabel.textColor = MacoTitleColor;
    self.shouyiLabel.textColor = MacoTitleColor;
    self.moneyLabel.textColor = MacoColor;
    self.invitationBtn.layer.cornerRadius = 8;
    self.invitationBtn.layer.borderWidth = 1;
    self.invitationBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView reloadData];
    
    
    self.backView.frame = CGRectMake(0, 104, TWitdh, THeight-104-44);
    self.backView.alpha = 0.8;
    self.backView.backgroundColor = [UIColor colorFromHexString:@"#ccd8e2"];
//    [self.view addSubview:self.backView];
    
    self.tableView.frame = CGRectMake(0, 104 , TWitdh, 150);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    [self.view bringSubviewToFront:self.tableView];
    
    self.naviBar.hiddenDetailBtn = NO;
    self.naviBar.detailTitle = @"邀请规则说明";
    self.naviBar.delegate = self;
    
    self.targetMchCodeId = @"";    
    [self.collectionView addNoDatasouceWithCallback:^{
        [self.collectionView.mj_header beginRefreshing];
    } andAlertSting:@"您还没有邀请商家哦，快去邀请吧！" andErrorImage:@"pic_3" andRefreshBtnHiden:YES];
    
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self invitationRequest:YES andTargetMchCode:self.targetMchCodeId];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self invitationRequest:NO andTargetMchCode:self.targetMchCodeId];
    }];
    [self.collectionView.mj_header beginRefreshing];
    
    
    [self RecommendMerchantListRequest];
    
    
    self.invitationBtn.layer.cornerRadius = 25;
    self.invitationBtn.layer.masksToBounds = YES;
    self.invitationBtn.backgroundColor = MacoColor;
    self.alerLabel.textColor  = MacoColor;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (NSMutableArray *)dataSouceArray
{
    if (!_dataSouceArray) {
        _dataSouceArray = [NSMutableArray array];
    }
    return _dataSouceArray;
}

- (NSMutableArray *)mchDataSouceArray
{
    if (!_mchDataSouceArray) {
        _mchDataSouceArray = [NSMutableArray array];
    }
    return _mchDataSouceArray;
}

- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc]init];
    }
    return _backView;
}

#pragma mark - 数据请求

//我的推荐商户列表

- (void)RecommendMerchantListRequest
{
    [HttpClient POST:@"user/recommendProfit/mch/get" parameters:@{@"token":[TTXUserInfo shareUserInfos].token} success:^(NSURLSessionDataTask *operation, id jsonObject) {
        [self.mchDataSouceArray removeAllObjects];
        if (IsRequestTrue) {
            NSArray *array = jsonObject[@"data"];
            RecommendMerchantModel *model = [[RecommendMerchantModel alloc]init];
            model.mchCode = @"";
            model.mchName = @"所有商家";
            [self.mchDataSouceArray addObject:model];
            for (NSDictionary *dic in array) {
                [self.mchDataSouceArray addObject:[RecommendMerchantModel modelWithDic:dic]];
            }
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
    
}


//我的邀请详情数据
- (void)invitationRequest:(BOOL)isHeader andTargetMchCode:(NSString *)targetMchCode
{
    NSDictionary *parms = @{@"pageNo":@(self.page),
                            @"pageSize":MacoRequestPageCount,
                            @"token":[TTXUserInfo shareUserInfos].token,
                            @"targetMchCode":targetMchCode};
    [HttpClient POST:@"user/recommendProfit/get" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            if (self.page == 1) {
                self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",[NullToNumber(jsonObject[@"data"][@"totalqueryAmount"]) floatValue]];
            }
            if (isHeader) {
                [self.dataSouceArray removeAllObjects];
                [self.collectionView.mj_header endRefreshing];
            }
            [self.collectionView.mj_footer endRefreshing];
            NSArray *array = jsonObject[@"data"][@"data"];
            if (array.count > 0) {
                self.page ++;
            }
            for (NSDictionary *dic in array) {
                [self.dataSouceArray addObject:[InnitationModel modelWithDic:dic]];
            }
            //判断数据源有无数据
            [self.collectionView judgeIsHaveDataSouce:self.dataSouceArray];
            if (self.mchDataSouceArray.count > 1) {
                [self.collectionView changeAlerSring:@"亲，暂时没有数据" andErrorImage:@"pic_2"];
            }
            [self.collectionView reloadData];
//            CGFloat total = 0.0;
//            for (InnitationModel *model in self.dataSouceArray) {
//                total = total + [model.tranAmount floatValue];
//            }
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (isHeader) {
            [self.collectionView.mj_header endRefreshing];
        }else{
            [self.collectionView.mj_footer endRefreshing];
        }
        [self.collectionView showRereshBtnwithALerString:@"网络连接不好"];
    }];
}


//让利回馈规则
- (void)detailBtnClick
{
    BaseHtmlViewController *htmlVC = [[BaseHtmlViewController alloc]init];
    htmlVC.htmlUrl = @"http://www.tiantianxcn.com/html5/forapp/introduce-notice.html";
    htmlVC.htmlTitle = @"邀请规则";
    [self.navigationController pushViewController:htmlVC animated:YES];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
    }
    return _tableView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSouceArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}



//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier =[MyWallectCollectionViewCell indentify];
    static BOOL nibri =NO;
    if(!nibri)
    {
        UINib *nib = [MyWallectCollectionViewCell newCell];
        [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
        nibri =YES;
    }
    MyWallectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (self.dataSouceArray.count > 0) {
        cell.inviteDataModel = self.dataSouceArray[indexPath.item];
    }
    nibri=NO;
    return cell;
}



//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake(TWitdh, 80);
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



//每个cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - UITableview


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mchDataSouceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.textLabel.text = ((RecommendMerchantModel *)self.mchDataSouceArray[indexPath.row]).mchName;
    cell.textLabel.textColor = MacoTitleColor;
    cell.textLabel.font = [UIFont systemFontOfSize:14.];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.hidden = YES;
    RecommendMerchantModel *model = self.mchDataSouceArray[indexPath.row];
    self.targetMchCodeId = model.mchCode;
    self.mchLabel.text = model.mchName;
    [self.backView removeFromSuperview];
    
    if (self.tableView.hidden) {
        [UIView animateWithDuration:0.2 animations:^{
            self.markImageView.transform=CGAffineTransformMakeRotation(0);
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.markImageView.transform=CGAffineTransformMakeRotation(M_PI);
        }];
    }
    [self.collectionView.mj_header beginRefreshing];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)select_btn:(UIButton *)sender {
    
    if (self.mchDataSouceArray.count == 1) {
        [[JAlertViewHelper shareAlterHelper] showTint:@"您暂时还没有邀请商家数据，点击屏幕下方的“立即邀请”按钮马上去邀请吧!" duration:2.0];
        return;
    }
    
    sender.selected = !sender.selected;
    self.tableView.hidden = !self.tableView.hidden;
    if (self.tableView.hidden) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.backView removeFromSuperview];
            self.markImageView.transform=CGAffineTransformMakeRotation(0);
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            [self.view addSubview:self.backView];
            [self.view bringSubviewToFront:self.tableView];
            self.markImageView.transform=CGAffineTransformMakeRotation(M_PI);
        }];
    }
}

- (IBAction)invitationBtn:(UIButton *)sender {
    
    //设置用户自定义的平台
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_WechatTimeLine),
                                               ]];
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [HttpClient POST:@"user/recomendInfo/get" parameters:@{@"token":[TTXUserInfo shareUserInfos].token} success:^(NSURLSessionDataTask *operation, id jsonObject) {
        [SVProgressHUD dismiss];
        if (IsRequestTrue) {
            [UMSocialUIManager removeAllCustomPlatformWithoutFilted];
            [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
            [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRadius;
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                [self runShareWithType:platformType withTitle:@"推荐商家" withUrl:NullToSpace(jsonObject[@"data"][@"url"])];
            }];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


- (void)runShareWithType:(UMSocialPlatformType)type withTitle:(NSString *)title withUrl:(NSString *)url
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:title thumImage:AppIconImage];
    //设置网页地址
    shareObject.webpageUrl = url;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [[JAlertViewHelper shareAlterHelper]showTint:@"分享失败，请重试..." duration:2.];
        //        [self alertWithError:error];
    }];
    
}


@end
