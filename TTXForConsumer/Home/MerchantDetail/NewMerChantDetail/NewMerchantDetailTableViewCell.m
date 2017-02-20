//
//  NewMerchantDetailTableViewCell.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/20.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "NewMerchantDetailTableViewCell.h"
#import "MerchantIntroduceView.h"
#import "MerchantProductListView.h"

@interface NewMerchantDetailTableViewCell()<SwipeViewDelegate,SwipeViewDataSource,SortButtonSwitchViewDelegate>

@property (nonatomic, strong)MerchantIntroduceView *introduceView;
@property (nonatomic, strong)MerchantProductListView *goodsListView;

@end
@implementation NewMerchantDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.swipeView.delegate = self;
    self.swipeView.dataSource = self;
    
    self.itemSwipeView.delegate = self;
    self.itemSwipeView.dataSource = self;
    
    self.sortView.titleArray = @[@"商家简介",@"相关产品",@"评价"];
    self.sortView.delegate = self;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (MerchantIntroduceView *)introduceView
{
    if (!_introduceView) {
        _introduceView = [[MerchantIntroduceView alloc]init];
    }
    return _introduceView;
}


- (MerchantProductListView *)goodsListView
{
    if (!_goodsListView) {
        _goodsListView = [[MerchantProductListView alloc]init];
    }
    return _goodsListView;
}


- (void)setDataModel:(BussessDetailModel *)dataModel
{
    _dataModel = dataModel;
    self.mchantName.text = _dataModel.name;
    self.goodsListView.mchCode = _dataModel.code;
    self.pageControl.numberOfPages = _dataModel.slidePic.count;
    if (_dataModel.slidePic.count == 0) {
        self.pageControl.hidden = YES;
        _dataModel.slidePic = @[@"http://192.168.1.2/more.png"];
    }
    [self.swipeView reloadData];
    
}

-(void)setGoodsArray:(NSMutableArray *)goodsArray
{
    _goodsArray = goodsArray;
    self.goodsListView.goodsArray = _goodsArray;
    [self.itemSwipeView reloadData];
}

#pragma mark -- Banner
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    if (swipeView == self.swipeView) {
        return self.dataModel.slidePic.count;;
    }
    return 3;

}
- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (swipeView == self.swipeView) {
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
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.dataModel.slidePic[index]] placeholderImage:BannerLoadingErrorImage];
        
        return view;
    }else{
        swipeView.backgroundColor = [UIColor clearColor];
        if (nil == view) {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, swipeView.frame.size.width, swipeView.frame.size.height)];
            view.autoresizingMask =  UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight ;
            
        }
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        switch (index) {
            case 0:
            {

                [view addSubview:self.introduceView];
                self.introduceView.dataModel = self.dataModel;
                [self.introduceView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(view).insets(insets);
                }];
                
            }
                break;
            case 1:
            {
                view.backgroundColor = [UIColor clearColor];
                [view addSubview:self.goodsListView];
                CGFloat goodsListViewHeight = 38 + 80*self.goodsArray.count;

                [self.goodsListView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(view).offset(0);
                    make.trailing.equalTo(view).offset(0);
                    make.top.equalTo(view).offset(0);
                    make.height.equalTo(@(goodsListViewHeight));
                }];
            }
                break;
            case 2:
            {
                view.backgroundColor = [UIColor redColor];
            }
                break;
                
            default:
                break;
        }
        return view;

    }

}



- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{
    if (self.swipeView == swipeView) {
        self.pageControl.currentPage = swipeView.currentPage;

    }else{
        [self.sortView selectItem:swipeView.currentPage];
    }
}


- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    //banner点击事件
    if ((swipeView != self.swipeView)) {
        return;
    }
    if (self.dataModel.slidePic.count ==0) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"暂时没有更多图片" duration:1.5];
        return;
    }
    [ImageViewer sharedImageViewer].controller = self.viewController;
    [[ImageViewer sharedImageViewer]showImageViewer:[NSMutableArray arrayWithArray:self.dataModel.slidePic] withIndex:index andView:self];
}

#pragma mark - SortButtonSwitchViewDelegate
- (void)sortBtnDselect:(SortButtonSwitchView *)sortView withSortId:(NSString *)sortId
{
    [self.itemSwipeView scrollToPage:[sortId integerValue] -1 duration:0.5];
}


@end
