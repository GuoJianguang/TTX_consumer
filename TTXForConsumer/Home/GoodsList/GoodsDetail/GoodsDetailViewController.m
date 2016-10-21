//
//  GoodsDetailViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/27.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "GoodsIntroduceViewController.h"
#import "UIScrollView+JYPaging.h"
#import "GoodsDetailIntroduceView.h"
#import "Watch.h"



@interface GoodsDetailViewController ()<UIScrollViewDelegate,SwipeViewDelegate,SwipeViewDataSource>

@property (nonatomic, strong)SwipeView *swipeView;
@property (nonatomic, strong)TTXPageContrl *pageControl;
@property (strong, nonatomic) HomeImageSwitchIndicatorView *pageView;



@property (strong, nonatomic) GoodsDetailIntroduceView *detailView;

@property (nonatomic, strong)NSMutableArray *imageHeightArray;
@property (nonatomic, assign)NSInteger imageCount;
@property (nonatomic, assign)CGFloat imageArrayHeight;

@property (nonatomic, strong)GoodsIntroduceViewController *detailVC;

@property (nonatomic, strong)UIButton *backBtn;


@property (nonatomic, strong)Watch *dataModel;

@end

@implementation GoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.alpha = 0;
    
    self.detailVC = [[GoodsIntroduceViewController alloc] init];
    self.detailVC.scrollView.scrollEnabled = NO;
    [self addChildViewController:self.detailVC];
    
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate = self;
    [self.scrollView addSubview:self.swipeView];
    [self.swipeView addSubview:self.pageControl];
    [self.scrollView addSubview:self.detailView];
    [self.view bringSubviewToFront:self.naviBar];
    
    //获取商品详情
    [self getGoodsDetail:self.goodsID];
    
    //添加返回按钮
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 30, 40, 40)];
    [self.view addSubview:self.backBtn];
    self.backBtn.layer.cornerRadius = 20;
    self.backBtn.layer.masksToBounds = YES;
    [self.backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"icon_mall_back_float"] forState:UIControlStateNormal];
    
    [self.view bringSubviewToFront:self.buyBtnView];
    self.buyBtn.backgroundColor = MacoColor;
    self.buyBtn.layer.cornerRadius = 35/2.;
    self.buyBtn.layer.masksToBounds = YES;
}

- (TTXPageContrl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[TTXPageContrl alloc]init];
        _pageControl.frame = CGRectMake(0, THeight*(528/1334.) - 40, TWitdh, 37);
    }
    return _pageControl;
}

- (ChooseTypeView *)choosetypeView
{
    if (!_choosetypeView) {
        _choosetypeView = [[ChooseTypeView alloc]init];
        _choosetypeView.frame = CGRectMake(0, 0, TWitdh, THeight);
    }
    return _choosetypeView;
}


#pragma mark - 数据源
- (Watch *)dataModel
{
    if (!_dataModel) {
        _dataModel = [[Watch alloc]init];
    }
    return _dataModel;
}

#pragma mark - 返回按钮点击事件

- (void)backBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.naviBar.alpha = scrollView.contentOffset.y/(scrollView.contentSize.height-64);
    self.backBtn.alpha = 1-self.naviBar.alpha;
}

#pragma mark - 商品详情的网络请求
- (void)getGoodsDetail:(NSString *)goodsCode
{
    NSDictionary *prams = @{@"id":goodsCode};
    [HttpClient GET:@"shop/goodsInfo/get" parameters:prams success:^(AFHTTPRequestOperation *operation, id jsonObject) {
        [SVProgressHUD dismiss];
        if (IsRequestTrue) {
            self.dataModel = [Watch modelWithDic:jsonObject[@"data"]];
            [self calculateDetailImageHeight:jsonObject[@"data"][@"picDesc"]];
            CGFloat detailViewHeight = [self cellHeight:self.dataModel.name] + 125 + 15;
            self.detailView.frame = CGRectMake(0, THeight*(528/1334.), TWitdh, detailViewHeight);
            self.scrollView.contentSize = CGSizeMake(TWitdh, detailViewHeight +THeight*(528/1334.) );
            
            if (self.detailVC.view != nil) {
                _scrollView.secondScrollView = self.detailVC.scrollView;
            }
            self.detailView.dataModel = self.dataModel;
            self.detailVC.dataModel = self.dataModel;
            
            self.pageControl.numberOfPages =  self.dataModel.slideImage.count;
            self.pageControl.currentPage = 0;
            [self.swipeView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark - 计算详情图片的高度

- (NSMutableArray *)imageHeightArray
{
    if (!_imageHeightArray) {
        _imageHeightArray = [NSMutableArray array];
    }
    return _imageHeightArray;
}
- (void)calculateDetailImageHeight:(NSArray *)array
{
    [self.imageHeightArray removeAllObjects];
    for (NSDictionary *obj in array) {
        NSNumber *height = @((TWitdh) *([NullToNumber(obj[@"height"]) floatValue] /[NullToNumber(obj[@"width"]) floatValue]));
        
        if (isnan([height floatValue])) {
            [self.imageHeightArray addObject:@(TWitdh/2.)];
        }else{
            [self.imageHeightArray addObject:height];
        }
        self.imageCount++;
        if (self.imageCount == array.count) {
            for (NSNumber *num in self.imageHeightArray) {
                self.imageArrayHeight +=[num floatValue];
            }
            [self.detailVC drawDetailImage:self.imageHeightArray andImagArray:array andHeight:self.imageArrayHeight];
            [SVProgressHUD dismiss];
        }
    }
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, TWitdh, THeight - 60)];
//        _scrollView.contentSize = CGSizeMake(0, TWitdh/1.5 + 150);
//        _scrollView.backgroundColor = [UIColor cyanColor];
    }
    return _scrollView;
}

- (SwipeView *)swipeView
{
    if (!_swipeView) {
        _swipeView = [[SwipeView alloc]initWithFrame:CGRectMake(0, 0, TWitdh, THeight*(528/1334.))];
        _swipeView.delegate = self;
        _swipeView.dataSource = self;
    }
    return _swipeView;
}


- (HomeImageSwitchIndicatorView *)pageView
{
    if (!_pageView) {
        _pageView = [[HomeImageSwitchIndicatorView alloc]initWithFrame:CGRectMake(100, THeight*(528/1334.) - 20, TWitdh - 200, 3)];
    }
    return _pageView;
}

- (GoodsDetailIntroduceView *)detailView
{
    if (!_detailView) {
        _detailView = [[GoodsDetailIntroduceView alloc]init];
//        _detailView.frame = CGRectMake(0, THeight*(528/1334.), TWitdh, 150);
    }
    return _detailView;
}

#pragma mark - Swipeview

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return self.dataModel.slideImage.count;

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
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.dataModel.slideImage[index]] placeholderImage:BannerLoadingErrorImage options:SDWebImageRefreshCached];
    return view;
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{
    self.pageControl.currentPage = swipeView.currentPage;
    self.pageView.currentIndicatorIndex = swipeView.currentPage;
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    //banner点击事件
    //banner点击事件
    if (self.dataModel.slideImage.count ==0) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"暂时没有更多图片" duration:1.5];
        return;
    }
    [ImageViewer sharedImageViewer].controller = self;
    [[ImageViewer sharedImageViewer]showImageViewer:[NSMutableArray arrayWithArray:self.dataModel.slideImage] withIndex:index andView:self.swipeView];
}

#pragma mark - 点击购买商品的按钮

- (IBAction)buyBtn:(UIButton *)sender {
    
    self.choosetypeView.dataModel = self.dataModel;
    [self.view addSubview:self.choosetypeView];
    
}


#pragma mark - 计算cell的高度
- (CGFloat)cellHeight:(NSString *)textSting
{
    CGSize size = [textSting boundingRectWithSize:CGSizeMake(TWitdh  - 24, 0) font:[UIFont systemFontOfSize:15]];
    return size.height;
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
