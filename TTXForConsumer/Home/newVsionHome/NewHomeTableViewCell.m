//
//  NewHomeTableViewCell.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/13.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "NewHomeTableViewCell.h"
#import "MerchantListViewController.h"
#import "GoodsListViewController.h"
#import "HomeViewController.h"
#import "GoodsDetailNewViewController.h"
#import "MerchantSearchResultViewController.h"
#import "SortCollectionViewCell.h"
#import "GoodsSearchRsultViewController.h"
#import "OnLineMerchantCityViewController.h"
#import "NewIndustryCollectionViewCell.h"
#import "NewMerchantDetailViewController.h"

@interface NewHomeTableViewCell()<SwipeViewDelegate,SwipeViewDataSource>

@end

@implementation NewHomeModel

+ (id)modelWithDic:(NSDictionary *)dic
{
    NewHomeModel *model = [[NewHomeModel alloc]init];
    model.bannerId = NullToSpace(dic[@"id"]);
    model.jumpWay = NullToSpace(dic[@"jumpWay"]);
    model.jumpValue = NullToSpace(dic[@"jumpValue"]);
    model.pic = NullToSpace(dic[@"pic"]);
    model.name = NullToSpace(dic[@"name"]);
    return model;
}
@end


@implementation NewHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.swipeView.dataSource = self;
    self.swipeView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setIsAlreadyRefrefsh:(BOOL)isAlreadyRefrefsh
{
    _isAlreadyRefrefsh = isAlreadyRefrefsh;
    [self getBannerRequest];
}
#pragma mark - 懒加载

- (NSMutableArray *)sortDataSouceArray
{
    if (!_sortDataSouceArray) {
        _sortDataSouceArray = [NSMutableArray array];
    }
    return _sortDataSouceArray;
}
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
    [HttpClient GET:@"advert/index/list" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            [self.bannerArray removeAllObjects];
            NSArray *array = jsonObject[@"data"];
            for (NSDictionary *dic in array) {
                NewHomeModel *model = [NewHomeModel modelWithDic:dic];
                model.isJump = YES;
                [self.bannerArray addObject:model];
            }
            [self.swipeView reloadData];
            [[AutoScroller shareAutoScroller]autoSwipeView:self.swipeView WithPageView:self.pageView WithDataSouceArray:self.bannerArray];
        }
        self.pageView.hidden = NO;
        self.pageView.numberOfPages = self.bannerArray.count;
        [self.swipeView reloadData];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self.bannerArray removeAllObjects];
        NewHomeModel *model = [[NewHomeModel alloc]init];
        model.pic = @"";
        model.isJump = NO;
        [self.bannerArray addObject:model];
        self.pageView.hidden = YES;
        [self.swipeView reloadData];
        
    }];
}



#pragma mark - banner

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
    NewHomeModel *model = self.bannerArray[index];
    //    [imageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:BannerLoadingErrorImage options:SDWebImageAllowInvalidSSLCertificates];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:BannerLoadingErrorImage];
    //    [imageView sd_setImageWithURL:[NSURL URLWithString:model.pic] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    
    //    }];
    return view;
}


- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{
    self.pageView.currentPage = swipeView.currentPage;
}


-(void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    NewHomeModel *model = self.bannerArray[index];
    if (!model.isJump) {
        return;
    }
    switch ([model.jumpWay integerValue]) {
        case 1://跳转app商户详情
        {
            NewMerchantDetailViewController *merchantDVC = [[NewMerchantDetailViewController alloc]init];
            merchantDVC.merchantCode = model.jumpValue;
            [self.viewController.navigationController pushViewController:merchantDVC animated:YES];
            
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
            if ([htmlVC.htmlUrl containsString:@"E50BA6517F660E7CA4A40EFD4508217E"]) {
                if (![TTXUserInfo shareUserInfos].currentLogined) {
                    //判断是否先登录
                    UINavigationController *navc = [LoginViewController controller];
                    [self.viewController presentViewController:navc animated:YES completion:NULL];
                    return;
                }
                htmlVC.htmlUrl = [NSString stringWithFormat:@"%@&token=%@",model.jumpValue,[TTXUserInfo shareUserInfos].token];
            }
            htmlVC.htmlTitle = model.name;
            [self.viewController.navigationController pushViewController:htmlVC animated:YES];
            
        }
            break;
        default:
            break;
    }
}



@end
