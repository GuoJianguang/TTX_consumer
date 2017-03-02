//
//  GoodsDetailNewViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/7/8.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "GoodsDetailNewViewController.h"
#import "GoodsDetailIntroduceView.h"
#import "Watch.h"
#import "CountDown.h"
#import "MchAllCommentViewController.h"


@interface GoodsDetailNewViewController ()<UIScrollViewDelegate,SwipeViewDelegate,SwipeViewDataSource>

@property (nonatomic, strong)SwipeView *swipeView;
@property (nonatomic, strong)TTXPageContrl *pageControl;
@property (strong, nonatomic) HomeImageSwitchIndicatorView *pageView;
@property (strong, nonatomic) GoodsDetailIntroduceView *detailView;

@property (nonatomic, strong)NSMutableArray *imageHeightArray;
@property (nonatomic, assign)NSInteger imageCount;
@property (nonatomic, assign)CGFloat imageArrayHeight;

@property (strong, nonatomic)  CountDown *countDown;

@property (nonatomic, strong)UIButton *backBtn;


@property (nonatomic, strong)Watch *dataModel;

@property (nonatomic, strong)UIView *imageSuperView;

//用于记录高度
@property (nonatomic, assign)CGFloat naviGationHeight;

@property (nonatomic, strong)UILabel *showDisCountTimeLabel;

@property (nonatomic, strong)UILabel *disCountLabel;


@property (nonatomic, assign)NSTimeInterval tempTime;

@end

@implementation GoodsDetailNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviBar.alpha = 0;

    
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate = self;
    
    [self.scrollView addSubview:self.swipeView];
    [self.swipeView addSubview:self.pageControl];
    if (self.isDisCount) {
        UIView *disCountView = [[UIView alloc]init];
        disCountView.backgroundColor = [UIColor colorFromHexString:@"f3b59d"];
        disCountView.frame = CGRectMake(0, THeight*(528/1334.), TWitdh, TWitdh *(78/750.));
        [self.scrollView addSubview:disCountView];
        [self setDiscontView:disCountView];
    }
    [self.view bringSubviewToFront:self.naviBar];
    //获取商品详情
    self.tempTime = 0;
    //添加返回按钮
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, 22, 40, 40)];
    [self.view addSubview:self.backBtn];
    self.backBtn.layer.cornerRadius = 20;
    self.backBtn.layer.masksToBounds = YES;
    [self.backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"icon_mall_back_float"] forState:UIControlStateNormal];
    
    [self.view bringSubviewToFront:self.buyBtnView];
    self.buyBtn.backgroundColor = MacoColor;
    self.buyBtn.layer.cornerRadius = 35/2.;
    self.buyBtn.layer.masksToBounds = YES;
    
    self.naviGationHeight = 0;
    
    [self.scrollView noDataSouce];
    
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getGoodsDetail:self.goodsID];
    }];

    [self.scrollView.mj_header beginRefreshing];
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

- (UILabel *)disCountLabel
{
    if (!_disCountLabel) {
        _disCountLabel = [[UILabel alloc]init];
    }
    return _disCountLabel;
}

#pragma mark - 限时折扣设置
- (void)setDiscontView:(UIView *)disContView
{
    
    self.disCountLabel.frame = CGRectMake(12, (TWitdh *(78/750.) -TWitdh*(44/750.))/2., TWitdh *(154/750.), TWitdh*(44/750.));
    self.disCountLabel.text = @"限时抢购中";
    self.disCountLabel.font = [UIFont systemFontOfSize:12];
    self.disCountLabel.backgroundColor = MacoColor;
    self.disCountLabel.layer.cornerRadius = 5;
    self.disCountLabel.layer.masksToBounds = YES;
    self.disCountLabel.textAlignment = NSTextAlignmentCenter;
    self.disCountLabel.adjustsFontSizeToFitWidth = YES;
    self.disCountLabel.textColor = [UIColor whiteColor];
    [disContView addSubview:self.disCountLabel];
    
    if (!self.showDisCountTimeLabel) {
        self.showDisCountTimeLabel = [[UILabel alloc]init];
    }
    self.showDisCountTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.disCountLabel.frame)+ 20, (TWitdh *(78/750.) -TWitdh*(44/750.))/2., TWitdh - CGRectGetWidth(self.disCountLabel.frame) - 20 - 25, TWitdh*(44/750.));
    self.showDisCountTimeLabel.textColor = MacoTitleColor;
    self.showDisCountTimeLabel.font = [UIFont systemFontOfSize:11];
    self.showDisCountTimeLabel.textAlignment = NSTextAlignmentRight;
    [disContView addSubview:self.showDisCountTimeLabel];
}


#pragma mark - 返回按钮点击事件

- (void)backBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 商品详情的网络请求



- (void)getGoodsDetail:(NSString *)goodsCode
{
    NSDictionary *prams = @{@"id":goodsCode};
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeGradient];
    [HttpClient GET:@"shop/goodsInfo/get" parameters:prams success:^(NSURLSessionDataTask *operation, id jsonObject) {
        [self.scrollView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
        if (IsRequestTrue) {
            [self.scrollView addSubview:self.detailView];
            self.dataModel = [Watch modelWithDic:jsonObject[@"data"]];
            CGFloat detailViewHeight = [self cellHeight:self.dataModel.name] + 123;
            self.detailView.dataModel = self.dataModel;
            self.pageControl.numberOfPages =  self.dataModel.slideImage.count;
            self.pageControl.currentPage = 0;
            [self.swipeView reloadData];
            if (self.isDisCount) {
                self.detailView.frame = CGRectMake(0, THeight*(528/1334.) + TWitdh*(78/750.), TWitdh, detailViewHeight);
                self.naviGationHeight = detailViewHeight + THeight*(528/1334.) + TWitdh*(78/750.);
                 [self addFengeView:detailViewHeight +THeight*(528/1334.)+ TWitdh*(78/750.) withImageArray:jsonObject[@"data"][@"picDesc"] withDetaiViewheight:detailViewHeight];
            }else{
                self.detailView.frame = CGRectMake(0, THeight*(528/1334.), TWitdh, detailViewHeight);
                self.naviGationHeight = detailViewHeight + THeight*(528/1334.);

                 [self addFengeView:detailViewHeight +THeight*(528/1334.) withImageArray:jsonObject[@"data"][@"picDesc"] withDetaiViewheight:detailViewHeight];
            }
            //倒计时
            if (self.isDisCount) {
                __weak GoodsDetailNewViewController *weak_self = self;
                NSUInteger endtime = [NullToNumber(jsonObject[@"data"][@"endTime"]) longLongValue];
                NSTimeInterval endinterval= endtime/ 1000.0;
                NSUInteger nowTime = [NullToNumber(jsonObject[@"data"][@"nowTime"]) longLongValue];
                NSUInteger startTime = [NullToNumber(jsonObject[@"data"][@"startTime"]) longLongValue];

                NSTimeInterval nowinterval= nowTime/ 1000.0;
                NSDate *enddate = [NSDate dateWithTimeIntervalSince1970:endinterval];
                NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:nowinterval];
                NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
                [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                self.tempTime =[enddate timeIntervalSinceDate:nowDate];
                if (startTime > nowTime) {
                    self.disCountLabel.text = self.showDisCountTimeLabel.text = @"活动未开始";
                    [self.buyBtn setBackgroundColor:MacoIntrodouceColor];
                    self.buyBtn.enabled = NO;
                    [self.buyBtn setTitle:@"活动未开始" forState:UIControlStateNormal];
                    self.buyBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
                    return;
                }
                [self.countDown countDownWithPER_SECBlock:^{
                    [weak_self getNowTimeWithStringEndTime];
                    self.tempTime --;
                    
                }];
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self.scrollView.mj_header endRefreshing];
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
- (void)calculateDetailImageHeight:(NSArray *)array withDetailViewHeight:(CGFloat)detailViewHeight
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
            [self drawDetailImage:self.imageHeightArray andImagArray:array andHeight:self.imageArrayHeight withDetailHeight:detailViewHeight];
            [SVProgressHUD dismiss];
        }
    }
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, TWitdh, THeight - 60)];
    }
    return _scrollView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y  + 64 > self.naviGationHeight) {
        [self.scrollView viewWithTag:100].frame = CGRectMake(0, scrollView.contentOffset.y  + 64, TWitdh ,44 );
    }else{
        [self.scrollView viewWithTag:100].frame = CGRectMake(0, self.naviGationHeight, TWitdh ,44 );
    }
    
    if ((scrollView.contentOffset.y + 64) /(THeight*(528/1334.)) < 1.) {
        self.naviBar.alpha = scrollView.contentOffset.y/(THeight*(528/1334.));
        self.backBtn.alpha = 1-self.naviBar.alpha;
    }else{
        self.naviBar.alpha = 1.;
        self.backBtn.alpha = 0.;
    }
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
        _pageView = [[HomeImageSwitchIndicatorView alloc]initWithFrame:CGRectMake(100, THeight*(528/1334.) - 10, TWitdh - 200, 3)];
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


#pragma mark - 加介绍商品评论销量的view
- (void)addFengeView:(CGFloat)viewY withImageArray:(NSArray *)imageArray  withDetaiViewheight:(CGFloat)detailHeight;
{
    UIView *view  = [[UIView alloc]init];
    view.tag = 100;
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, viewY, TWitdh, 44);
    [self.scrollView addSubview:view];
    UILabel *commentLabel = [[UILabel alloc]init];
    commentLabel.text = [NSString stringWithFormat:@"累计评论（%@）",_dataModel.totalCommentCount];
    commentLabel.frame =CGRectMake(12,8, 200, 44-16);
    commentLabel.textColor = MacoDetailColor;
    commentLabel.font = [UIFont systemFontOfSize:13];
    [view addSubview:commentLabel];
    
    UILabel *kucunLabel = [[UILabel alloc]init];
    kucunLabel.textColor = MacoDetailColor;
    kucunLabel.font = [UIFont systemFontOfSize:13];
    if (_dataModel.inventoryFlag) {
        kucunLabel.text = @"库存：有货";
    }else{
        kucunLabel.text = @"库存：无货";
    }
    kucunLabel.frame =CGRectMake(TWitdh - 92 ,8, 80, 44-16);
    [view addSubview:kucunLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(TWitdh - 92 - 18, 15, 1, 44- 30)];
    lineView.backgroundColor = MacoIntrodouceColor;
    [view addSubview:lineView];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(lineView.frame.origin.x - 30, 7, 30, 30)];
    imageview.image = [UIImage imageNamed:@"icon_enter"];
    [view addSubview:imageview];
    
    UILabel *saleLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageview.frame.origin.x - 200, 8, 200, 44-16)];
    saleLabel.text = [NSString stringWithFormat:@"销量：%@笔",_dataModel.salenum];
    saleLabel.textAlignment = NSTextAlignmentRight;
    saleLabel.textColor = MacoDetailColor;
    saleLabel.font = [UIFont systemFontOfSize:13];
    [view addSubview:saleLabel];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,lineView.frame.origin.x, 44)];
    [button addTarget:self action:@selector(checkAllComment:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    
    UIView *dowmlineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, TWitdh, 1)];
    dowmlineView.backgroundColor = MacolayerColor;
    [view addSubview:dowmlineView];
    
    [self calculateDetailImageHeight:imageArray withDetailViewHeight:detailHeight];
    
    
}

#pragma mark - 查看评论
- (void)checkAllComment:(UIButton *)buuton{
    
    MchAllCommentViewController *commentVC = [[MchAllCommentViewController alloc]init];
    commentVC.mchId = self.dataModel.mch_id;
    [self.navigationController pushViewController:commentVC animated:YES];
    
}
#pragma mark- 铺满图片

- (UIView *)imageSuperView
{
    if (!_imageSuperView) {
        _imageSuperView  = [[UIView alloc]init];
        _imageSuperView.frame = CGRectMake(0, 54, TWitdh, 0);
    }
    return _imageSuperView;
}

- (void)drawDetailImage:(NSArray *)heightArray andImagArray:(NSArray *)imageArray andHeight:(CGFloat)totalHeight withDetailHeight:(CGFloat)detailViewHeight
{
    [self.scrollView addSubview:self.imageSuperView];
    [self.scrollView bringSubviewToFront:[self.scrollView viewWithTag:100]];
    self.imageSuperView.frame = CGRectMake(0, THeight*(528/1334.)+ detailViewHeight+ 44+ 10, TWitdh, totalHeight);
    CGFloat y = 0;
    for (int i =0; i < heightArray.count ; i ++) {
        if (i ==0) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, TWitdh, [heightArray[i] floatValue])];
            [imageView sd_setImageWithURL:[NSURL URLWithString:NullToSpace(imageArray[i][@"url"])] placeholderImage:LoadingErrorImage];
            [self.imageSuperView addSubview:imageView];
        }else{
            y += [heightArray[i -1] floatValue];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, y, TWitdh, [heightArray[i] floatValue])];
            [imageView sd_setImageWithURL:[NSURL URLWithString:NullToSpace(imageArray[i][@"url"])] placeholderImage:LoadingErrorImage];
            [self.imageSuperView addSubview:imageView];
        }
    }
    UIView *dowmlineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TWitdh, 1)];
    dowmlineView.backgroundColor = MacolayerColor;
    [self.imageSuperView addSubview:dowmlineView];
    self.scrollView.contentSize = CGSizeMake(TWitdh, THeight*(528/1334.)+ detailViewHeight+ 44+ 10 + totalHeight);
}



- (void)setOrderViewSureBtn:(BOOL)isCanBuy
{
    if (isCanBuy) {
        self.choosetypeView.buyBtn.enabled = YES;
        self.choosetypeView.buyBtn.backgroundColor = MacoColor;
        [self.choosetypeView.buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        return;
    }
    [self.choosetypeView.buyBtn setBackgroundColor:MacoIntrodouceColor];
    self.choosetypeView.buyBtn.enabled = NO;
    [self.choosetypeView.buyBtn setTitle:@"暂时没有此规格的商品" forState:UIControlStateNormal];
    self.choosetypeView.buyBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
}


#pragma mark - 倒计时计数
- (CountDown *)countDown
{
    if (!_countDown) {
        _countDown = [[CountDown alloc]init];
    }
    return _countDown;
}


-( void)getNowTimeWithStringEndTime{

    
    int days = (int)(self.tempTime/(3600*24));
    int hours = (int)((self.tempTime-days*24*3600)/3600);
    int minutes = (int)(self.tempTime-days*24*3600-hours*3600)/60;
    int seconds = self.tempTime-days*24*3600-hours*3600-minutes*60;
    
    NSString *dayStr;NSString *hoursStr;NSString *minutesStr;NSString *secondsStr;
    //天
    dayStr = [NSString stringWithFormat:@"%d",days];
    //小时
    hoursStr = [NSString stringWithFormat:@"%d",hours];
    //分钟
    if(minutes<10)
        minutesStr = [NSString stringWithFormat:@"0%d",minutes];
    else
        minutesStr = [NSString stringWithFormat:@"%d",minutes];
    //秒
    
    
    if(seconds < 10)
        secondsStr = [NSString stringWithFormat:@"0%d", seconds];
    else
        secondsStr = [NSString stringWithFormat:@"%d",seconds];
    if (hours<=0&&minutes<=0&&seconds<=0) {
        [self.countDown destoryTimer];
        self.disCountLabel.text = @"活动已结束";
        [self.buyBtn setBackgroundColor:MacoIntrodouceColor];
        self.buyBtn.enabled = NO;
        [self.buyBtn setTitle:@"活动结束" forState:UIControlStateNormal];
        self.buyBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.showDisCountTimeLabel.text = @"活动已结束";
        return;
    }
    self.disCountLabel.text = @"限时抢购中";

    if (days) {
        self.showDisCountTimeLabel.text = [NSString stringWithFormat:@"还剩%@天%@小时%@分%@秒结束", dayStr,hoursStr, minutesStr,secondsStr];
        return;
    }
    self.showDisCountTimeLabel.text = [NSString stringWithFormat:@"还剩%@小时%@分%@秒结束",hoursStr , minutesStr,secondsStr];
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
