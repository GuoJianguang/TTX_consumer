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
#import "MerchantDetailViewController.h"
#import "MerchantSearchResultViewController.h"
#import "SortCollectionViewCell.h"
#import "GoodsSearchRsultViewController.h"
#import "OnLineMerchantCityViewController.h"
#import "NewIndustryCollectionViewCell.h"

@interface NewHomeTableViewCell()<SwipeViewDelegate,SwipeViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

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

@implementation NewHomeActivityModel

+ (id)modelWithDic:(NSDictionary *)dic
{
    NewHomeActivityModel *model = [[NewHomeActivityModel alloc]init];
    model.name = NullToSpace(dic[@"name"]);
    model.seqId = NullToSpace(dic[@"seqId"]);
    model.coverImg = NullToSpace(dic[@"coverImg"]);
    model.sort = NullToNumber(dic[@"sort"]);
    return model;
}
@end

@implementation NewHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.swipeView.dataSource = self;
    self.swipeView.delegate = self;
    self.industryCollectionView.delegate = self;
    self.industryCollectionView.dataSource = self;
    self.industryCollectionView.pagingEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setIsAlreadyRefrefsh:(BOOL)isAlreadyRefrefsh
{
    _isAlreadyRefrefsh = isAlreadyRefrefsh;
    [self getBannerRequest];
    [self getGoodsTypeRequest];
    
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
    [HttpClient POST:@"advert/index/list" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
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

//获取所有商品类型
- (void)getGoodsTypeRequest
{
    [HttpClient GET:@"shop/goodsType/get" parameters:nil success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            [self.sortDataSouceArray removeAllObjects];
            NSArray *array = jsonObject[@"data"];
            for (NSDictionary *dic in array) {
                GoodsSort *model = [GoodsSort modelWithDic:dic];
                [self.sortDataSouceArray addObject:model];
            }
            [self.industryCollectionView reloadData];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
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



#pragma mark - 行业分类
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
    
    NSString *identifier =[NewIndustryCollectionViewCell indentify];
    static BOOL nibri =NO;
    if(!nibri)
    {
        UINib *nib = [NewIndustryCollectionViewCell newCell];
        [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
        nibri =YES;
    }
    NewIndustryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (self.sortDataSouceArray.count > 0) {
        cell.goodsSortModel = self.sortDataSouceArray[indexPath.item];
    }
    nibri=NO;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    GoodsSort *model = self.sortDataSouceArray[indexPath.item];
//    [self.view removeFromSuperview];
//    GoodsSearchRsultViewController *resultVC = [[GoodsSearchRsultViewController alloc]init];
//    resultVC.typeId = model.sortId;
//    resultVC.searchName = @"";
//    [self.navigationController pushViewController:resultVC animated:YES];
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (self.sortDataSouceArray.count < 5) {
    //        return CGSizeMake(TWitdh/self.sortDataSouceArray.count, 50);
    //    }
    return CGSizeMake(TWitdh/4, TWitdh*(32/75.)/2.);
//    return CGSizeMake(TWitdh/4, TWitdh/3. *0.6);
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"33333");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

//    NSLog(@"44");
//    float x = scrollView.contentOffset.x/TWitdh;
//    int y = (int)x;
//    float z = x - y;
//    
//    if (z > 0.25) {
//        self.industryCollectionView.contentOffset = CGPointMake((y+ 1)*TWitdh, 0);
//    }else{
//        self.industryCollectionView.contentOffset = CGPointMake(y*TWitdh, 0);
//    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    float x = scrollView.contentOffset.x/TWitdh;
    int y = (int)x;
    float z = x - y;
    
    if (z > 0.25) {
        self.industryCollectionView.contentOffset = CGPointMake((y+ 1)*TWitdh, 0);
    }else{
        self.industryCollectionView.contentOffset = CGPointMake(y*TWitdh, 0);
    }
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    return CGPointMake(0, 0);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint orifinalTargetContentOffset = CGPointMake(targetContentOffset->x, targetContentOffset->y);
    float x = scrollView.contentOffset.x/TWitdh;
    int y = (int)x;
    float z = x - y;
    
    if (z > 0.25) {
        scrollView.contentOffset = CGPointMake((y+ 1)*TWitdh, 0);
    }else{
        scrollView.contentOffset = CGPointMake(y*TWitdh, 0);
    }
//    if (z > 0.4) {
//        *targetContentOffset = CGPointMake((y+ 1)*TWitdh, 0);
//    }else{
//        *targetContentOffset = CGPointMake(y*TWitdh, 0);
//
//    }
    //计算出想要其停止的位置
//    NSLog(@"%.3f",x);
}
@end
