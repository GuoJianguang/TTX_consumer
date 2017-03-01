//
//  DiscoveryViewController.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/16.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "DiscoveryHomeTableViewCell.h"
#import "DiscoveryDetailViewController.h"
#import "GoodsDetailNewViewController.h"
#import "NewMerchantDetailViewController.h"
#import "DiscoverSecondActivityViewController.h"
#import "DisCountViewController.h"


@interface DiscoveryViewController ()<SwipeViewDelegate,SwipeViewDataSource>

@property (nonatomic, strong)NSMutableArray *datasouceArray;

@end

@implementation DiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviBar.title = @"发现";
    self.naviBar.hiddenBackBtn = YES;
    self.firstLabel.textColor = self.secondLabel.textColor = MacoTitleColor;
    [self getRequest];
    
}


- (NSMutableArray *)datasouceArray
{
    if (!_datasouceArray) {
        _datasouceArray = [NSMutableArray array];
    }
    return _datasouceArray;
}



#pragma mark - 网络请求

- (void)getRequest{
    [HttpClient POST:@"find/advert/list" parameters:nil success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            [self.datasouceArray removeAllObjects];
            NSArray *array = jsonObject[@"data"];
            if (array.count == 0) {
                self.pageContrlView.hidden = YES;
                self.swipeView.hidden = YES;
                return;
            }
            self.pageContrlView.hidden = NO;
            self.swipeView.hidden = NO;
            for (NSDictionary *dic in array) {
                [self.datasouceArray addObject:[DiscoverHome modelWithDic:dic]];
            }
            [[AutoScroller shareAutoScroller]autoSwipeView:self.swipeView WithPageView:self.pageContrlView WithDataSouceArray:self.datasouceArray];
            self.pageContrlView.numberOfPages = self.datasouceArray.count;
            [self.swipeView reloadData];
        }

    } failure:^(NSURLSessionDataTask *operation, NSError *error) {

        self.pageContrlView.hidden = YES;
        self.swipeView.hidden = YES;
    }];

}
- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{
    self.pageContrlView.currentPage = swipeView.currentPage;
}



#pragma mark - swipeView

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return self.datasouceArray.count;
}


- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIImageView *imageView = nil;
    if (nil == view) {
        view = [[UIView alloc] initWithFrame:swipeView.bounds];
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.frame = CGRectMake(0, 0, TWitdh, self.swipeView.bounds.size.height);
//        imageView.center = swipeView.center;
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
    view.backgroundColor = [UIColor cyanColor];
    DiscoverHome *model = self.datasouceArray[index];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:BannerLoadingErrorImage];

    return view;
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    DiscoverHome *model = self.datasouceArray[index];
    switch ([model.jumpWay integerValue]) {
        case 1:
        {
            NewMerchantDetailViewController *merchantDVC = [[NewMerchantDetailViewController alloc]init];
            merchantDVC.merchantCode = model.jumpValue;
            [self.navigationController pushViewController:merchantDVC animated:YES];
            
        }
            break;
        case 2:
        {
            GoodsDetailNewViewController *goodsDVC = [[GoodsDetailNewViewController alloc]init];
            goodsDVC.goodsID = model.jumpValue;
            [self.navigationController pushViewController:goodsDVC animated:YES];
        }
            break;
        case 3:
        {
            
            BaseHtmlViewController *htmlVC = [[BaseHtmlViewController alloc]init];
            htmlVC.htmlUrl = model.jumpValue;
            if ([htmlVC.htmlUrl containsString:@"E50BA6517F660E7CA4A40EFD4508217E"]) {
                if (![TTXUserInfo shareUserInfos].currentLogined) {
                    //判断是否先登录
                    UINavigationController *navc = [LoginViewController controller];
                    [self presentViewController:navc animated:YES completion:NULL];
                    return;
                }
                htmlVC.htmlUrl = [NSString stringWithFormat:@"%@&token=%@",model.jumpValue,[TTXUserInfo shareUserInfos].token];
            }
            htmlVC.htmlTitle = model.name;
            [self.navigationController pushViewController:htmlVC animated:YES];
            
        }
            break;
        case 4:{// 抽奖活动
            DiscoveryDetailViewController *discoveryDV = [[DiscoveryDetailViewController alloc]init];
            discoveryDV.model = self.datasouceArray[index];
            [self.navigationController pushViewController:discoveryDV animated:YES];
        }
            
            break;
        case 5:{//限时折扣
                DisCountViewController *discountVC = [[DisCountViewController alloc]init];
                [self.navigationController pushViewController:discountVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }

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

- (IBAction)firstBtn:(id)sender {
    DiscoveryDetailViewController *discoveryDV = [[DiscoveryDetailViewController alloc]init];
    [self.navigationController pushViewController:discoveryDV animated:YES];
    
}

- (IBAction)secondBtn:(id)sender {
    DiscoverSecondActivityViewController *actibityVC = [[DiscoverSecondActivityViewController alloc]init];
    [self.navigationController pushViewController:actibityVC animated:YES];
}
@end
