//
//  HomeBannerTableViewCell.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/16.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "HomeBannerTableViewCell.h"
#import "MerchantListViewController.h"
#import "GoodsListViewController.h"
#import "HomeViewController.h"
#import "GoodsDetailNewViewController.h"
#import "NewMerchantDetailViewController.h"
#import "MerchantSearchResultViewController.h"
#import "SortCollectionViewCell.h"
#import "GoodsSearchRsultViewController.h"



@implementation HomenBannerModel

+ (id)modelWithDic:(NSDictionary *)dic
{
    HomenBannerModel *model = [[HomenBannerModel alloc]init];
    model.bannerId = NullToSpace(dic[@"id"]);
    model.jumpWay = NullToSpace(dic[@"jumpWay"]);
    model.jumpValue = NullToSpace(dic[@"jumpValue"]);
    model.pic = NullToSpace(dic[@"pic"]);
    return model;
}

@end

@implementation ActivityModel

+ (id)modelWithDic:(NSDictionary *)dic
{
    ActivityModel *model = [[ActivityModel alloc]init];
    model.name = NullToSpace(dic[@"name"]);
    model.seqId = NullToSpace(dic[@"seqId"]);
    model.coverImg = NullToSpace(dic[@"coverImg"]);
    model.sort = NullToNumber(dic[@"sort"]);
    return model;
}

@end


@interface HomeBannerTableViewCell()<SwipeViewDataSource,SwipeViewDelegate>

//banner的数据源
@property (nonatomic, strong)NSMutableArray *bannerArray;
//活动数据源
@property (nonatomic, strong)NSMutableArray *activityArray;
//特卖类别数据源
@property (nonatomic, strong)NSMutableArray *sortDatasouceArray;

@end

@implementation HomeBannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.swipeView.dataSource = self;
    self.swipeView.delegate = self;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.activityImage1.layer.masksToBounds = YES;
//    self.activityImage1.contentMode
    self.activityImage2.layer.masksToBounds = YES;
    self.activityImage3.layer.masksToBounds = YES;
    self.activityImage4.layer.masksToBounds = YES;
    self.activityImage5.layer.masksToBounds = YES;
    self.moremchLabel.textColor = MacoColor;
    self.moreGoodsLabel.textColor = MacoColor;
}

- (void)setIsAlreadyRefrefsh:(BOOL)isAlreadyRefrefsh
{
    _isAlreadyRefrefsh = isAlreadyRefrefsh;
    [self getBannerRequest];
    [self getActicityRequest];
    [self getGoodsTypeRequest];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark - 懒加载
- (NSMutableArray *)bannerArray
{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

- (NSMutableArray *)activityArray
{
    if (!_activityArray) {
        _activityArray = [NSMutableArray array];
    }
    return _activityArray;
}

- (NSMutableArray *)sortDatasouceArray
{
    if (!_sortDatasouceArray) {
        _sortDatasouceArray = [NSMutableArray array];
    }
    return _sortDatasouceArray;
}

#pragma mark - banner数据请求
- (void)getBannerRequest
{
    NSString *searchCity = [[TTXUserInfo shareUserInfos].locationCity substringToIndex:2];
    NSDictionary *parms = @{@"city":searchCity};
    [HttpClient GET:@"advert/index/list" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            [self.bannerArray removeAllObjects];
            NSArray *array = jsonObject[@"data"];
            for (NSDictionary *dic in array) {
                HomenBannerModel *model = [HomenBannerModel modelWithDic:dic];
                [self.bannerArray addObject:model];
            }
            [self.swipeView reloadData];
            [[AutoScroller shareAutoScroller]autoSwipeView:self.swipeView WithPageView:self.pageView WithDataSouceArray:self.bannerArray];
        }
        self.pageView.numberOfPages = self.bannerArray.count;
        [self.swipeView reloadData];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

#pragma mark - 活动的数据请求
- (void)getActicityRequest
{
    NSString *searchCity = [[TTXUserInfo shareUserInfos].locationCity substringToIndex:2];
    NSDictionary *parms = @{@"city":searchCity};
    [HttpClient GET:@"activity/index/list" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            [self.activityArray removeAllObjects];
            NSArray *array = jsonObject[@"data"];
            for (NSDictionary *dic in array) {
                [self.activityArray addObject:[ActivityModel modelWithDic:dic]];
            }
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sort" ascending:YES];
            self.activityArray = [NSMutableArray arrayWithArray:[self.activityArray sortedArrayUsingDescriptors:@[sort]]];
            if (self.activityArray.count< 4) {
                return;
            }
//            [self.activityArray removeLastObject];
            ActivityModel *model1 = self.activityArray[0];
            ActivityModel *model2 = self.activityArray[1];
            ActivityModel *model3 = self.activityArray[2];
            ActivityModel *model4 = self.activityArray[3];
            [self.contentView bringSubviewToFront:self.fiveView];
            [self.activityImage1 sd_setImageWithURL:[NSURL URLWithString:model1.coverImg] placeholderImage:LoadingErrorImage options:SDWebImageRefreshCached];
            [self.activityImage2 sd_setImageWithURL:[NSURL URLWithString:model2.coverImg] placeholderImage:LoadingErrorImage options:SDWebImageRefreshCached];
            [self.activityImage3 sd_setImageWithURL:[NSURL URLWithString:model3.coverImg] placeholderImage:LoadingErrorImage options:SDWebImageRefreshCached];
            [self.activityImage4 sd_setImageWithURL:[NSURL URLWithString:model4.coverImg] placeholderImage:LoadingErrorImage options:SDWebImageRefreshCached];
            if (self.activityArray.count >  4) {
                ActivityModel *model5 = self.activityArray[4];
                [self.activityImage5 sd_setImageWithURL:[NSURL URLWithString:model5.coverImg] placeholderImage:LoadingErrorImage options:SDWebImageRefreshCached];
                self.fiveTop.constant = 3 + TWitdh/4.;
                self.fiveActivityHeight.constant = TWitdh*(190/750.);
                self.fiveView.hidden = NO;
            }else{
                self.fiveTop.constant = 3;
                self.fiveActivityHeight.constant = 0;
                self.fiveView.hidden = YES;
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
#pragma mark - 活动点击事件

- (IBAction)activity1Btn:(UIButton *)sender {
    if (self.activityArray.count < 4 ) {
        return;
    }
    MerchantSearchResultViewController *resultVC = [[MerchantSearchResultViewController alloc]init];
    ActivityModel *model = self.activityArray[0];
    resultVC.currentCity =  [TTXUserInfo shareUserInfos].locationCity;
    resultVC.seqId = model.seqId;
    [self.viewController.navigationController pushViewController:resultVC animated:YES];
}
- (IBAction)activity2Btn:(UIButton *)sender {
    if (self.activityArray.count < 4 ) {
        return;
    }
    MerchantSearchResultViewController *resultVC = [[MerchantSearchResultViewController alloc]init];
    ActivityModel *model = self.activityArray[1];
    resultVC.currentCity =  [TTXUserInfo shareUserInfos].locationCity;
    resultVC.seqId = model.seqId;
    [self.viewController.navigationController pushViewController:resultVC animated:YES];
}
- (IBAction)activity3Btn:(UIButton *)sender {
    if (self.activityArray.count < 4 ) {
        return;
    }
    MerchantSearchResultViewController *resultVC = [[MerchantSearchResultViewController alloc]init];
    ActivityModel *model = self.activityArray[2];
    resultVC.currentCity =  [TTXUserInfo shareUserInfos].locationCity;
    resultVC.seqId = model.seqId;
    [self.viewController.navigationController pushViewController:resultVC animated:YES];
}
- (IBAction)activity4Btn:(UIButton *)sender {
    if (self.activityArray.count < 4 ) {
        return;
    }
    MerchantSearchResultViewController *resultVC = [[MerchantSearchResultViewController alloc]init];
    ActivityModel *model = self.activityArray[3];
    resultVC.currentCity =  [TTXUserInfo shareUserInfos].locationCity;
    resultVC.seqId = model.seqId;
    [self.viewController.navigationController pushViewController:resultVC animated:YES];
}
- (IBAction)activity5Btn:(UIButton *)sender {
    if (self.activityArray.count < 4 ) {
        return;
    }
    MerchantSearchResultViewController *resultVC = [[MerchantSearchResultViewController alloc]init];
    ActivityModel *model = self.activityArray[4];
    resultVC.currentCity =  [TTXUserInfo shareUserInfos].locationCity;
    resultVC.seqId = model.seqId;
    [self.viewController.navigationController pushViewController:resultVC animated:YES];
}

#pragma mark - 天添薪特卖
//获取所有商品类型
- (void)getGoodsTypeRequest
{
    [HttpClient GET:@"shop/goodsType/get" parameters:nil success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            [self.sortDatasouceArray removeAllObjects];
            NSArray *array = jsonObject[@"data"];
            for (NSDictionary *dic in array) {
                GoodsSort *model = [GoodsSort modelWithDic:dic];
                [self.sortDatasouceArray addObject:model];
            }
            if (self.sortDatasouceArray.count< 3) {
                return;
            }
            GoodsSort *model1 = self.sortDatasouceArray[0];
            self.specialLabel1.text = model1.name;
            [self.specialImage1 sd_setImageWithURL:[NSURL URLWithString:model1.pic] placeholderImage:LoadingErrorImage options:SDWebImageRefreshCached];
            self.specialImage1.contentMode = UIViewContentModeScaleAspectFill;
            self.specialImage1.layer.masksToBounds = YES;
            GoodsSort *model2 = self.sortDatasouceArray[1];
            [self.specialImage2 sd_setImageWithURL:[NSURL URLWithString:model2.pic] placeholderImage:LoadingErrorImage options:SDWebImageRefreshCached];
            self.specialLabel2.text = model2.name;
            self.specialImage2.contentMode = UIViewContentModeScaleAspectFill;
            self.specialImage2.layer.masksToBounds = YES;
            GoodsSort *model3 = self.sortDatasouceArray[2];
            [self.specialImage3 sd_setImageWithURL:[NSURL URLWithString:model3.pic] placeholderImage:LoadingErrorImage options:SDWebImageRefreshCached];
            self.specialImage3.contentMode = UIViewContentModeScaleAspectFill;
            self.specialImage3.layer.masksToBounds = YES;
            self.specialLabel3.text = model3.name;
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

- (IBAction)special1Btn:(UIButton *)sender {
    GoodsSort *model = self.sortDatasouceArray[0];
    GoodsSearchRsultViewController *resultVC = [[GoodsSearchRsultViewController alloc]init];
    resultVC.typeId = model.sortId;
    resultVC.searchName = @"";
    [self.viewController.navigationController pushViewController:resultVC animated:YES];
}
- (IBAction)special2Btn:(UIButton *)sender {
    
    GoodsSort *model = self.sortDatasouceArray[1];
    GoodsSearchRsultViewController *resultVC = [[GoodsSearchRsultViewController alloc]init];
    resultVC.typeId = model.sortId;
    resultVC.searchName = @"";
    [self.viewController.navigationController pushViewController:resultVC animated:YES];
}

- (IBAction)special3Btn:(UIButton *)sender {
    GoodsSort *model = self.sortDatasouceArray[2];
    GoodsSearchRsultViewController *resultVC = [[GoodsSearchRsultViewController alloc]init];
    resultVC.typeId = model.sortId;
    resultVC.searchName = @"";
    [self.viewController.navigationController pushViewController:resultVC animated:YES];
}

#pragma mark -- Banner
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return self.bannerArray.count;
}


- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIImageView *imageView = nil;
    if (nil == view) {
        view = [[UIView alloc] initWithFrame:swipeView.bounds];
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.bounds = CGRectMake(0, 0, TWitdh, self.swipeView.bounds.size.height);
        imageView.center = swipeView.center;
        imageView.tag = 10;
        [view addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        view.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
    }else {
        imageView = (UIImageView*)[view viewWithTag:10];
    }
    HomenBannerModel *model = self.bannerArray[index];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:BannerLoadingErrorImage];
    
    return view;
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{
    self.pageView.currentPage = swipeView.currentPage;
}

-(void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    
    HomenBannerModel *model = self.bannerArray[index];
    switch ([model.jumpWay integerValue]) {
        case 1://跳转app商户详情
        {
            NewMerchantDetailViewController *merchantDvc = [[NewMerchantDetailViewController alloc]init];
            merchantDvc.merchantCode = model.jumpValue;
            [self.viewController.navigationController pushViewController:merchantDvc animated:YES];

        }
            break;
        case 2://跳转app产品详情
        {
            GoodsDetailNewViewController *goodsDVC = [[GoodsDetailNewViewController alloc]init];
            goodsDVC.goodsID = model.jumpValue;
            [self.viewController.navigationController pushViewController:goodsDVC animated:YES];
        }
            break;
        case 3://跳转网页
        {
            BaseHtmlViewController *htmlVC = [[BaseHtmlViewController alloc]init];
            htmlVC.htmlUrl = model.jumpValue;
            htmlVC.htmlTitle = @"广告";
            [self.viewController.navigationController pushViewController:htmlVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}


- (IBAction)recommendedMort:(id)sender {
    MerchantListViewController *listVC = [[MerchantListViewController alloc]init];
    listVC.currentCity = ((HomeViewController *)self.viewController).currentCity;
    [self.viewController.navigationController pushViewController:listVC animated:YES];
    
}
- (IBAction)temaiBtn:(UIButton *)sender {
    
    GoodsListViewController *goodslistVC = [[GoodsListViewController alloc]init];
    [self.viewController.navigationController pushViewController:goodslistVC animated:YES];

}

@end
