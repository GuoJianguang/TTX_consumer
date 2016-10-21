//
//  HomeViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/16.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "HomeViewController.h"
#import "CityListViewController.h"
#import "LocationManager.h"
#import "LBXScanViewStyle.h"
#import "SubLBXScanViewController.h"
#import "HomeBannerTableViewCell.h"
#import "HomeBusinessListTableViewCell.h"
#import "MerchantDetailViewController.h"
#import "MineViewController.h"
#import "SharkItOffViewController.h"
#import "UIImage+ColorImage.h"
#import "MerchantSearchViewController.h"
#import "MerchantSearchResultViewController.h"
#import "AppDelegate.h"
#import "HomeTableViewCell.h"



@interface HomeViewController()<CityListViewDelegate,UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate,UITextFieldDelegate,MerchantSearchViewDelegate>
//定位城市
@property (nonatomic, strong)NSString *locationCity;
//定位服务
@property (nonatomic, strong)LocationManager *locationM;

@property (nonatomic, strong)NSMutableArray *highQualityArray;

@property (nonatomic, strong)MerchantSearchViewController *searchVC;

@property (nonatomic, assign)NSInteger page;

@property (nonatomic, assign)BOOL isHasActiviy;


@property (nonatomic, assign)BOOL isAlreadyRefrefsh;

@end


@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = MacoGrayColor;
    self.searchView.layer.cornerRadius = self.searchView.bounds.size.height/2;
    self.searchView.layer.borderWidth = 1;
    self.searchView.backgroundColor = [UIColor whiteColor];
    self.searchView.layer.borderColor = MacolayerColor.CGColor;
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.searchTF.delegate = self;
    UIColor *itemSelectTintColor = MacoColor;
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      itemSelectTintColor,
      NSForegroundColorAttributeName,
      [UIFont boldSystemFontOfSize:15],
      NSFontAttributeName
      ,nil] forState:UIControlStateSelected];
    self.tabBarController.tabBar.tintColor = itemSelectTintColor;
    [[UITabBar appearance] setShadowImage:[[UIImage alloc]init]];
    [[UITabBar appearance] setShadowImage:[UIImage imageWithColor:itemSelectTintColor frame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)]];
    self.locationCity = @"成都";
    self.currentCity = @"成都";
    self.tabBarController.delegate = self;
    self.tabBarController.tabBar.barTintColor = [UIColor whiteColor];

    __weak HomeViewController *weak_self = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weak_self.isAlreadyRefrefsh = YES;
        [weak_self.tableView reloadData];
//        weak_self.page = 1;
//        [self detailReqest:YES andCity:self.currentCity];
//        [self getActicityRequest];
        [weak_self.tableView.mj_header endRefreshing];
    }];
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [self detailReqest:NO andCity:self.currentCity];
//    }];
//    
    [self.tableView addNoDatasouceWithCallback:^{
        [self.tableView.mj_header beginRefreshing];
    } andAlertSting:@"暂时没有数据" andErrorImage:@"pic_2" andRefreshBtnHiden:YES];

    self.isHasActiviy = YES;
    self.isAlreadyRefrefsh = YES;
    //开启定位服务
    [self loadDataUseLocation];
    NSLog(@"guangao");
    [self performSelector:@selector(guanbi) withObject:nil afterDelay:5.];
}

#pragma mark - 关闭广告
- (void)guanbi
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).splash) {
        ((AppDelegate *)[UIApplication sharedApplication].delegate).splash.delegate = nil;
        ((AppDelegate *)[UIApplication sharedApplication].delegate).splash = nil;
        [((AppDelegate *)[UIApplication sharedApplication].delegate).customSplashView removeFromSuperview];
    }
}
- (MerchantSearchViewController *)searchVC
{
    if (!_searchVC) {
        _searchVC = [[MerchantSearchViewController alloc]init];
        _searchVC.delegate = self;
        _searchVC.view.frame = CGRectMake(0, 0, TWitdh, THeight);
    }
    return _searchVC;
}

#pragma mark - 请求是否有第5个活动
- (void)getActicityRequest
{
    NSString *searchCity = [[TTXUserInfo shareUserInfos].locationCity substringToIndex:2];
    NSDictionary *parms = @{@"city":searchCity};
    [HttpClient GET:@"activity/index/list" parameters:parms success:^(AFHTTPRequestOperation *operation, id jsonObject) {
        if (IsRequestTrue) {
            self.tableView.scrollEnabled = YES;
            NSArray *array = jsonObject[@"data"];
            if (array.count == 4) {
                self.isHasActiviy = NO;
            }else{
                self.isHasActiviy= YES;
            }
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.tableView.scrollEnabled = NO;
        [self.tableView showRereshBtnwithALerString:@"网络连接不好"];

    }];
}

#pragma mark -使用当前位置加载数据
- (BOOL)myContainsString:(NSString*)string and:(NSString *)otherString {
    NSRange range = [string rangeOfString:otherString];
    return range.length != 0;
}

-(void) loadDataUseLocation {
    [TTXUserInfo shareUserInfos].locationCity = @"成都";
    NSString *currentCity = [LocationManager sharedLocationManager].currentCity;
    __weak typeof(HomeViewController *) weak_self = self;
    
    if (!currentCity) {
        [[LocationManager sharedLocationManager] startLocationWithGDManager];
        [LocationManager sharedLocationManager].finishLocation = ^(NSString *city,NSString *areaName,NSError *error ,BOOL success){
            if (city) {
                if ([self myContainsString:city and:@"市"]) {
                    city =  [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
                }
                [TTXUserInfo shareUserInfos].locationCity = city;
                [weak_self.cityBtn setTitle:city forState:UIControlStateNormal];
                self.currentCity = city;
                self.locationCity = city;
                
                [self.tableView.mj_header beginRefreshing];
            }else{
                self.currentCity = @"成都";
                [TTXUserInfo shareUserInfos].locationCity = @"成都";
                [weak_self.cityBtn setTitle:@"成都" forState:UIControlStateNormal];
                [self.tableView.mj_header beginRefreshing];
            }
        };
    }else {
        [TTXUserInfo shareUserInfos].locationCity = @"成都";
        [weak_self.cityBtn setTitle:@"成都" forState:UIControlStateNormal];
        [self.tableView.mj_header beginRefreshing];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 城市选择器
- (IBAction)cityBtn:(UIButton *)sender {
    CityListViewController *cityListView = [[CityListViewController alloc]init];
    cityListView.delegate = self;
    //热门城市列表
    cityListView.arrayHotCity = [NSMutableArray arrayWithObjects:@"成都",@"重庆",@"昆明",@"德阳",@"资阳", nil];
    //历史选择城市列表
    NSMutableArray *historicalCity = [[NSUserDefaults standardUserDefaults]objectForKey:CommonlyUsedCity];
    cityListView.arrayHistoricalCity = historicalCity;
    //定位城市列表
    cityListView.arrayLocatingCity   = [NSMutableArray arrayWithObjects:self.locationCity, nil];
    
    [self presentViewController:cityListView animated:YES completion:nil];
}

- (void)didClickedWithCityName:(NSString*)cityName
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:CommonlyUsedCity]) {
        NSArray *historicalCity = [[NSUserDefaults standardUserDefaults]objectForKey:CommonlyUsedCity];
        NSMutableArray *array = [NSMutableArray arrayWithArray:historicalCity];
        
        if (![array containsObject:cityName]) {
            [array insertObject:cityName atIndex:0];
            if (array.count > 3) {
                [array removeLastObject];
            }
        }else{
            [array exchangeObjectAtIndex:[array indexOfObject:cityName] withObjectAtIndex:0];
        }
        [[NSUserDefaults standardUserDefaults]setObject:array forKey:CommonlyUsedCity];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }else{
        NSMutableArray *array = [NSMutableArray arrayWithArray:@[cityName]];
        [[NSUserDefaults standardUserDefaults]setObject:array forKey:CommonlyUsedCity];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    self.searchVC.selectCityname = cityName;
    [TTXUserInfo shareUserInfos].locationCity = cityName;
    self.currentCity = cityName;
    [self.cityBtn setTitle:cityName forState:UIControlStateNormal];
    [self.tableView.mj_header beginRefreshing];
}



#pragma mark - 扫一扫
- (IBAction)scanBtn:(UIButton *)sender {
    
    //创建参数对象
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    //矩形区域中心上移，默认中心点为屏幕中心点
    style.centerUpOffset = 44;
    
    //扫码框周围4个角的类型,设置为外挂式
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    
    //扫码框周围4个角绘制的线条宽度
    style.photoframeLineW = 6;
    
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 24;
    
    //扫码框周围4个角的高度
    style.photoframeAngleH = 24;
    
    //扫码框内 动画类型 --线条上下移动
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //线条上下移动图片
    style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    
    //SubLBXScanViewController继承自LBXScanViewController
    //添加一些扫码或相册结果处理
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.style = style;
    
    vc.isQQSimulator = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 摇一摇
- (IBAction)shakeBtn:(UIButton *)sender {
    
    SharkItOffViewController *shartVC = [[SharkItOffViewController alloc]init];
    [self.navigationController pushViewController:shartVC animated:YES];
    
}

#pragma mark - UITalbeView

- (NSMutableArray *)highQualityArray
{
    if (!_highQualityArray) {
        _highQualityArray = [NSMutableArray array];
    }
    return _highQualityArray;
}
//获取优质商家的网络请求
- (void)detailReqest:(BOOL)isHeader andCity:(NSString *)city
{
    NSString *searchCity = [self.currentCity substringToIndex:2];
    NSDictionary *parms = @{@"city":searchCity,
                            @"pageNo":@(self.page),
                            @"pageSize":@(9),
                            @"longitude":NullToNumber(@([TTXUserInfo shareUserInfos].locationCoordinate.longitude)),
                            @"latitude":NullToNumber(@([TTXUserInfo shareUserInfos].locationCoordinate.latitude))};
    
    [HttpClient GET:@"mch/highQuality" parameters:parms success:^(AFHTTPRequestOperation *operation, id jsonObject) {
        self.tableView.scrollEnabled = YES;
        if (IsRequestTrue) {
            if (isHeader) {
                [self.highQualityArray removeAllObjects];
                [self.tableView.mj_header endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            NSArray *array = jsonObject[@"data"][@"data"];
            if (array.count > 0) {
                self.page ++;
            }
            for (NSDictionary *dic in array) {
                [self.highQualityArray addObject:[HomeBusinessList modelWithDic:dic]];
            }
            [self.tableView hiddenNoDataSouce];
//            [self.tableView judgeIsHaveDataSouce:self.highQualityArray];
            //判断数据源有无数据
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.isAlreadyRefrefsh = NO;
        self.tableView.scrollEnabled = NO;
        if (isHeader) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView showRereshBtnwithALerString:@"网络连接不好"];
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) {
//        HomeBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HomeBannerTableViewCell indentify]];
//        if (!cell) {
//            cell = [HomeBannerTableViewCell newCell];
//        }
//        cell.isAlreadyRefrefsh = self.isAlreadyRefrefsh;
//        return cell;
//    }
//    HomeBusinessListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HomeBusinessListTableViewCell indentify]];
//    if (!cell) {
//        cell = [HomeBusinessListTableViewCell newCell];
//    }
//    cell.dataModel = self.highQualityArray[indexPath.row - 1];
//    return cell;
    
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HomeTableViewCell indentify]];
    if (!cell) {
        cell = [HomeTableViewCell newCell];
    }
    cell.isAlreadyRefrefsh = self.isAlreadyRefrefsh;

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) {
//        if (self.isHasActiviy) {
//            return TWitdh *(360/750.) + 5 + TWitdh*(396/750.)+TWitdh*(190/750.) +4+TWitdh*(212/750.) + 80;
//        }else{
//            return TWitdh *(360/750.) + 5 + TWitdh*(396/750.) +4+TWitdh*(212/750.) + 80;
//        }
//    }
//    
//    return TWitdh*(95./320.);
    
    return THeight - 64- 49;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.highQualityArray.count + 1;
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    HomeBusinessList *model = self.highQualityArray[indexPath.row - 1];
    MerchantDetailViewController *merDVC = [[MerchantDetailViewController alloc]init];
    merDVC.merchantCode = model.code;
    [self.navigationController pushViewController:merDVC animated:YES];
    

}



#pragma mark - UITabBarDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
     if([viewController isMemberOfClass:[MineViewController class]]){
        if (![TTXUserInfo shareUserInfos].currentLogined) {
            //判断是否先登录
            UINavigationController *navc = [LoginViewController controller];
            [self presentViewController:navc animated:YES completion:NULL];
            return NO;
        }
    }
    return YES;
}

#pragma mark - UITextFiledDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.searchVC.isSerach = YES;
//    [self.navigationController pushViewController:self.searchVC animated:YES];
    [self.navigationController.view addSubview:self.searchVC.view];
    return NO;
}


#pragma mark = MerchantSearchViewDelegate

- (void)cancelSearch
{
    [self.searchVC.view removeFromSuperview];
}


- (void)sureSearch:(NSString *)keyWord city:(NSString *)cityName
{
    [self.searchVC.view removeFromSuperview];
    MerchantSearchResultViewController *resultVC = [[MerchantSearchResultViewController alloc]init];
    resultVC.currentIndustry = @"";
    resultVC.keyWord = keyWord;
    resultVC.currentCity = cityName;
    [self.navigationController pushViewController:resultVC animated:YES];
}





@end
