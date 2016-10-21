//
//  HomeTableViewCell.m
//  TTXForConsumer
//
//  Created by Guo on 16/10/18.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "MerchantListViewController.h"
#import "GoodsListViewController.h"
#import "HomeViewController.h"
#import "GoodsDetailNewViewController.h"
#import "MerchantDetailViewController.h"
#import "MerchantSearchResultViewController.h"
#import "SortCollectionViewCell.h"
#import "GoodsSearchRsultViewController.h"
#import "OnLineMerchantCityViewController.h"


@interface BaseTableViewCell()<SwipeViewDelegate,SwipeViewDataSource>

@end

@implementation HomeModel

+ (id)modelWithDic:(NSDictionary *)dic
{
    HomeModel *model = [[HomeModel alloc]init];
    model.bannerId = NullToSpace(dic[@"id"]);
    model.jumpWay = NullToSpace(dic[@"jumpWay"]);
    model.jumpValue = NullToSpace(dic[@"jumpValue"]);
    model.pic = NullToSpace(dic[@"pic"]);
    return model;
}
@end

@implementation HomeActivityModel

+ (id)modelWithDic:(NSDictionary *)dic
{
    HomeActivityModel *model = [[HomeActivityModel alloc]init];
    model.name = NullToSpace(dic[@"name"]);
    model.seqId = NullToSpace(dic[@"seqId"]);
    model.coverImg = NullToSpace(dic[@"coverImg"]);
    model.sort = NullToNumber(dic[@"sort"]);
    return model;
}

@end

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.swipeView.dataSource = self;
    self.swipeView.delegate = self;

}

- (void)setIsAlreadyRefrefsh:(BOOL)isAlreadyRefrefsh
{
    _isAlreadyRefrefsh = isAlreadyRefrefsh;
    [self getBannerRequest];
    [self getActivityRequest];
    
}

#pragma mark - 懒加载

- (NSMutableArray *)bannerArray
{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

#pragma mark - banner数据请求
- (void)getBannerRequest
{
    NSString *searchCity = [[TTXUserInfo shareUserInfos].locationCity substringToIndex:2];
    NSDictionary *parms = @{@"city":searchCity};
    [HttpClient GET:@"advert/index/list" parameters:parms success:^(AFHTTPRequestOperation *operation, id jsonObject) {
        if (IsRequestTrue) {
            [self.bannerArray removeAllObjects];
            NSArray *array = jsonObject[@"data"];
            for (NSDictionary *dic in array) {
                HomeModel *model = [HomeModel modelWithDic:dic];
                [self.bannerArray addObject:model];
            }
            [self.swipeView reloadData];
            [[AutoScroller shareAutoScroller]autoSwipeView:self.swipeView WithPageView:self.pageView WithDataSouceArray:self.bannerArray];
        }
        self.pageView.numberOfPages = self.bannerArray.count;
        [self.swipeView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)getActivityRequest
{
    [HttpClient POST:@"activity/index" parameters:nil success:^(AFHTTPRequestOperation *operation, id jsonObject) {
        if (IsRequestTrue) {
            HomeActivityModel *model = [HomeActivityModel modelWithDic:jsonObject[@"data"]];
            self.seqId = model.seqId;
            [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:model.coverImg] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                if (finished) {
                    [self.button1 setBackgroundImage:image forState:UIControlStateNormal];
                }else{
                    [self.button1 setBackgroundImage:BannerLoadingErrorImage forState:UIControlStateNormal];

                }
            }];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

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
    HomeModel *model = self.bannerArray[index];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:BannerLoadingErrorImage];
    
    return view;
}


- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{
    self.pageView.currentPage = swipeView.currentPage;
}


#pragma mark - banner
-(void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    HomeModel *model = self.bannerArray[index];
    switch ([model.jumpWay integerValue]) {
        case 1://跳转app商户详情
        {
            MerchantDetailViewController *merchantDvc = [[MerchantDetailViewController alloc]init];
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
#pragma mark - 点击事件
- (IBAction)button1:(UIButton *)sender {
    if (self.seqId) {
        GoodsSearchRsultViewController *resultVC = [[GoodsSearchRsultViewController alloc]init];
        resultVC.venceId = @"";
        resultVC.venceName = @"活动";
        resultVC.activityId = self.seqId;
        resultVC.searchName = @"";
        [self.viewController.navigationController pushViewController:resultVC animated:YES];
    }else{
        [[JAlertViewHelper shareAlterHelper]showTint:@"暂时没有活动，敬请期待！" duration:2.];
    }
}

- (IBAction)button2:(UIButton *)sender {
    MerchantListViewController *listVC = [[MerchantListViewController alloc]init];
    listVC.currentCity = ((HomeViewController *)self.viewController).currentCity;
    [self.viewController.navigationController pushViewController:listVC animated:YES];
    
}
- (IBAction)button3:(UIButton *)sender {
    OnLineMerchantCityViewController *onlineVC = [[OnLineMerchantCityViewController alloc]init];
    [self.viewController.navigationController pushViewController:onlineVC animated:YES];
}
@end
