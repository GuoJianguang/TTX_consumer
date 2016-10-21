//
//  GoodsIntroduceViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/27.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "GoodsIntroduceViewController.h"
#import "GoodsMoreIntroduceView.h"
#import "MchAllCommentViewController.h"
#import "Watch.h"

@interface GoodsIntroduceViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong)GoodsMoreIntroduceView *goodsMoreView;

@property (nonatomic, strong)UIView *imageSuperView;



@end

@implementation GoodsIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = MacoGrayColor;
    self.scrollView.delegate = self;
//    [self.scrollView addSubview:self.goodsMoreView];
    [self.scrollView addSubview:self.imageSuperView];

}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view layoutIfNeeded];
    [self.goodsMoreView layoutIfNeeded];
    [self scrollViewDidScroll:self.scrollView];
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, TWitdh, THeight)];
        _scrollView.contentSize = CGSizeMake(0, THeight*2);
    }
    return _scrollView;
}
- (GoodsMoreIntroduceView *)goodsMoreView
{
    if (!_goodsMoreView) {
        _goodsMoreView = [[GoodsMoreIntroduceView alloc]init];
        _goodsMoreView.frame = CGRectMake(0, 20, TWitdh, 44);
    }
    [_goodsMoreView layoutIfNeeded];
    return _goodsMoreView;
}

- (void)setDataModel:(Watch *)dataModel
{
    _dataModel = dataModel;
    UIView *view  = [[UIView alloc]init];
    view.tag = 100;
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, TWitdh, 44);
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
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, TWitdh - lineView.frame.origin.x, 44)];
    [button addTarget:self action:@selector(checkAllComment:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.scrollView viewWithTag:100].frame = CGRectMake(0, scrollView.contentOffset.y, TWitdh ,44 );
}


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

- (void)drawDetailImage:(NSArray *)heightArray andImagArray:(NSArray *)imageArray andHeight:(CGFloat)totalHeight
{
    self.scrollView.contentSize = CGSizeMake(TWitdh, totalHeight + 60 + 54);
    self.imageSuperView.backgroundColor = [UIColor redColor];
    self.imageSuperView.frame = CGRectMake(0, 54, TWitdh, totalHeight);
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
