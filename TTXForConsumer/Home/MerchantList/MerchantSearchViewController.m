//
//  MerchantSearchViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/7/1.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "MerchantSearchViewController.h"
#import "IndustryCollectionViewCell.h"
#import "LocationManager.h"
#import "CityListViewController.h"
#import "MerchantSearchResultViewController.h"



@interface MerchantSearchViewController ()<CityListViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong)NSMutableArray *sortDataSouceArray;


@end

@implementation MerchantSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviBar.hidden = YES;
    // Do any additional setup after loading the view from its nib.
    self.searchView.layer.cornerRadius = 15.;
    self.searchView.layer.masksToBounds = YES;
    self.searchView.layer.borderWidth = 1;
    self.searchView.layer.borderColor = MacolayerColor.CGColor;
    self.selectCityLabel.textColor = MacoColor;
    
    self.cityLabel.text = [NSString stringWithFormat:@"当前城市：%@",[TTXUserInfo shareUserInfos].locationCity];
    self.serchTF.delegate = self;
    self.selectCityname = [TTXUserInfo shareUserInfos].locationCity;
    [self sortRequest];
    
//    [self loadDataUseLocation];
}

- (NSString *)selectCityname
{
    if (!_selectCityname) {
        _selectCityname = [NSString stringWithFormat:@""];
    }
    return _selectCityname;
}

- (void)setIsSerach:(BOOL)isSerach
{
    _isSerach = isSerach;
    self.collectionView.hidden = _isSerach;
    self.cityView.hidden = _isSerach;
}

//-(void) loadDataUseLocation {
//    NSString *currentCity = [LocationManager sharedLocationManager].currentCity;
//    __weak typeof(MerchantSearchViewController *) weak_self = self;
//    
//    if (!currentCity) {
//        [[LocationManager sharedLocationManager] startLocationWithGDManager];
//        [LocationManager sharedLocationManager].finishLocation = ^(NSString *city,NSString *areaName,NSError *error ,BOOL success){
//            if (city) {
//                if ([self myContainsString:city and:@"市"]) {
//                    city =  [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
//                }
//                weak_self.cityLabel.text  = [NSString stringWithFormat:@"定位：%@",city];
//            }else{
//                weak_self.cityLabel.text= @"定位：成都";
//            }
//        };
//    }else {
//                weak_self.cityLabel.text= @"定位：成都";
//    }
//}

- (BOOL)myContainsString:(NSString*)string and:(NSString *)otherString {
    NSRange range = [string rangeOfString:otherString];
    return range.length != 0;
}

#pragma mark - 商家类别的请求
- (void)sortRequest
{
    
    [HttpClient GET:@"mch/trades" parameters:nil success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            [self.sortDataSouceArray removeAllObjects];
            NSArray *array = jsonObject[@"data"];
            for (NSDictionary *dic in array) {
                [self.sortDataSouceArray addObject:[SortModel modelWithDic:dic]];
            }
            [self.collectionView reloadData];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
#pragma mark- 懒加载

- (NSMutableArray *)sortDataSouceArray
{
    if (!_sortDataSouceArray) {
        _sortDataSouceArray = [NSMutableArray array];
    }
    return _sortDataSouceArray;
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
        cell.dataModel = self.sortDataSouceArray[indexPath.item];
    }
    nibri=NO;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SortModel *model = self.sortDataSouceArray[indexPath.item];

    MerchantSearchResultViewController *resultVC = [[MerchantSearchResultViewController alloc]init];
    resultVC.currentIndustry = model.name;
    resultVC.keyWord = @"";
    resultVC.currentCity = self.selectCityname;
    self.cityLabel.text = [NSString stringWithFormat:@"当前城市：%@",[TTXUserInfo shareUserInfos].locationCity];
    self.selectCityname = [TTXUserInfo shareUserInfos].locationCity;
    [self.navigationController pushViewController:resultVC animated:YES];
    [self.view removeFromSuperview];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtn:(UIButton *)sender {
    self.cityLabel.text = [NSString stringWithFormat:@"当前城市：%@",[TTXUserInfo shareUserInfos].locationCity];
    self.selectCityname = [TTXUserInfo shareUserInfos].locationCity;
    if ([self.delegate respondsToSelector:@selector(cancelSearch)]) {
        [self.delegate cancelSearch];
    }
}

#pragma mark - 取消搜索的按钮
- (IBAction)cancelBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cancelSearch)]) {
        [self.delegate cancelSearch];
    }
}


#pragma mark -城市选择器
- (IBAction)selectCity:(id)sender {
    CityListViewController *cityListView = [[CityListViewController alloc]init];
    cityListView.delegate = self;
    //热门城市列表
    cityListView.arrayHotCity = [NSMutableArray arrayWithObjects:@"成都",@"重庆",@"昆明",@"德阳",@"资阳", nil];
    //历史选择城市列表
    NSMutableArray *historicalCity = [[NSUserDefaults standardUserDefaults]objectForKey:CommonlyUsedCity];
    cityListView.arrayHistoricalCity = historicalCity;
    //定位城市列表
    cityListView.arrayLocatingCity   = [NSMutableArray arrayWithObjects:self.selectCityname, nil];
    
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
    self.selectCityname = cityName;
    self.cityLabel.text = [NSString stringWithFormat:@"已选择城市：%@",cityName];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.collectionView.hidden = YES;
    self.cityView.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(sureSearch:city:)]) {
        [self.delegate sureSearch:textField.text city:self.selectCityname];
    }
    textField.text = @"";

    return YES;
}


@end
