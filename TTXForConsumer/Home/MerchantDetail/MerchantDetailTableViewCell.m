//
//  MerchantDetailTableViewCell.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/17.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "MerchantDetailTableViewCell.h"
#import "MerchantDetailViewController.h"
#import "VoucherCell.h"
#import "GoodsListTableViewCell.h"
#import "CommentTableViewCell.h"
#import "OnlinePayViewController.h"
#import "MerchantCommentListViewController.h"
#import "MchchantAllgoodsViewController.h"
#import "GoodsDetailNewViewController.h"
#import "BussessMapViewController.h"


@interface MerchantDetailTableViewCell()<UITableViewDataSource,UITableViewDelegate,SwipeViewDataSource,SwipeViewDelegate,UIActionSheetDelegate>

@end


@implementation MerchantDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.swipeView.dataSource = self;
    self.swipeView.delegate = self;
    
    self.goodsTableView.dataSource = self;
    self.goodsTableView.delegate = self;
    self.commentTableView.dataSource = self;
    self.commentTableView.delegate = self;
    
    self.onPayBtn.layer.cornerRadius = 5;
    self.onPayBtn.layer.masksToBounds = YES;
    
    self.introduceLabel.textColor = MacoDetailColor;
    self.mchantName.textColor = MacoTitleColor;
    self.phoneNum.textColor = MacoTitleColor;
    self.address.textColor = self.jisaoLabel.textColor = self.shangpingLabel.textColor = self.pinglunLabel.textColor =  MacoTitleColor;
    self.quanbulabel.textColor = self.gengduoLabel.textColor = MacoColor;
    

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
}



- (void)setDataModel:(BussessDetailModel *)dataModel
{
    _dataModel = dataModel;
    self.mchantName.text = _dataModel.name;
    self.pageControl.numberOfPages = _dataModel.slidePic.count;

    //电话
    self.phoneNum.text = _dataModel.phone;
    self.address.text = _dataModel.address;
    //介绍
    self.introduceLabel.text = _dataModel.desc;
    if ([_dataModel.desc isEqualToString:@""]) {
        self.showIntroduceView.hidden = YES;
        self.introduceHeight.constant = 0;
    }else{
        if ([self cellHeight:_dataModel.desc]+ 50 + 55 > 170) {
            self.introduceHeight.constant = 155;
            self.showAllIntroduce.hidden = NO;
        }else{
            self.showAllIntroduce.hidden = YES;
            self.introduceHeight.constant = [self cellHeight:_dataModel.desc] + 55 + 20;
        }
    }
    if (_dataModel.slidePic.count == 0) {
        self.pageControl.hidden = YES;
        _dataModel.slidePic = @[@"http://192.168.1.2/more.png"];
    }
    [self.swipeView reloadData];
//    [[AutoScroller shareAutoScroller]autoSwipeView:self.swipeView WithPageView:self.pageControl WithDataSouceArray:[NSMutableArray arrayWithArray:_dataModel.slidePic]];
}



#pragma mark -- Banner
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return self.dataModel.slidePic.count;;
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
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.dataModel.slidePic[index]] placeholderImage:BannerLoadingErrorImage];
    
    return view;
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{
//    self.pageView.currentIndicatorIndex = swipeView.currentPage;
    self.pageControl.currentPage = swipeView.currentPage;
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    //banner点击事件
    if (self.dataModel.slidePic.count ==0) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"暂时没有更多图片" duration:1.5];
        return;
    }
    [ImageViewer sharedImageViewer].controller = self.viewController;
    [[ImageViewer sharedImageViewer]showImageViewer:[NSMutableArray arrayWithArray:self.dataModel.slidePic] withIndex:index andView:self];
}

- (IBAction)showAllIntroduce:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
//        [(MerchantDetailViewController *)self.viewController refreshTableViewOfIntroduceView];
        self.introduceHeight.constant = [self cellHeight:_dataModel.desc] + 55 + 40;
        self.introduceLabel.numberOfLines = 0;
    }else{
        self.introduceLabel.numberOfLines = 4;
        self.introduceHeight.constant = 155;
    }
}

- (void)setCommentArray:(NSMutableArray *)commentArray
{
    _commentArray = commentArray;
    if (_commentArray.count ==0) {
        self.commentView.hidden = YES;
        return;
    }
    [self.commentTableView reloadData];
    CGFloat commentHeight = 0;
    for (BussessComment *comment in self.commentArray) {
        if (comment.replyFlag) {
            commentHeight += 120;
        }else{
            commentHeight += 70;
        }
    }
    self.commentViewHeight.constant = 38 + commentHeight;
}

-(void)setGoodsArray:(NSMutableArray *)goodsArray
{
    _goodsArray = goodsArray;
    if (_goodsArray.count == 0) {
        self.goodsViewHeight.constant = 0;
        self.goodsView.hidden = YES;
        self.commentTop.constant = 0;
        return;
    }
    self.goodsViewHeight.constant = 36 + 38 + 80*self.goodsArray.count;
    [self.goodsTableView reloadData];
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.goodsTableView) {
        return self.goodsArray.count;
    }
    return self.commentArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.goodsTableView) {
        GoodsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[GoodsListTableViewCell indentify]];
        if (!cell) {
            cell = [GoodsListTableViewCell newCell];
        }
        if (self.goodsArray.count > 0) {
            cell.dataModel = self.goodsArray[indexPath.row];
        }
        return cell;
    }
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CommentTableViewCell indentify]];
    if (!cell) {
        cell = [CommentTableViewCell newCell];
    }
    cell.replayLabel.numberOfLines = 2;
    cell.dataModel = self.commentArray[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.goodsTableView) {
        return 80;
    }
    BussessComment *comment = self.commentArray[indexPath.row];
    if (comment.replyFlag) {
        return 120;
    }
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.goodsTableView) {
        GoodsListModel *model = self.goodsArray[indexPath.row];
        GoodsDetailNewViewController *detailvC = [[GoodsDetailNewViewController alloc]init];
        detailvC.goodsID = model.goodsId;
        [self.viewController.navigationController pushViewController:detailvC animated:YES];
    }

    
}


#pragma mark - 在线支付
- (IBAction)onlinePay:(UIButton *)sender {
    OnlinePayViewController *onlineVC = [[OnlinePayViewController alloc]init];
    onlineVC.dataModel = self.dataModel;
    [self.viewController.navigationController pushViewController:onlineVC animated:YES];
    
}
- (IBAction)checkAllComment:(UIButton *)sender {
    MerchantCommentListViewController *allCommentVC = [[MerchantCommentListViewController alloc]init];
    allCommentVC.code = self.dataModel.code;
    [self.viewController.navigationController pushViewController:allCommentVC animated:YES];
}

#pragma mark- 查看所有商品
- (IBAction)checkAllgoodsBtn:(UIButton *)sender {
    
    MchchantAllgoodsViewController *allgoodsVC =[[MchchantAllgoodsViewController alloc]init];
    allgoodsVC.mchChantCode = self.dataModel.code;
    [self.viewController.navigationController pushViewController:allgoodsVC animated:YES];
}

- (IBAction)address:(UIButton *)sender {
    
    BussessMapViewController *mapVC = [[BussessMapViewController alloc]init];
    
    CLLocationCoordinate2D d;
    d.latitude = [self.dataModel.latitude floatValue];
    d.longitude = [self.dataModel.longitude floatValue];
    
    if (d.longitude == 0 || d.latitude == 0) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"该商户暂时没有位置信息" duration:1.5];
        return;
    }
    mapVC.stopcoordinate = d;
    mapVC.dataModel = self.dataModel;
    [self.viewController.navigationController pushViewController:mapVC animated:YES];
}


#pragma mark - 计算cell的高度
- (CGFloat)cellHeight:(NSString *)textSting
{
    CGSize size = [textSting boundingRectWithSize:CGSizeMake(TWitdh  - 30, 0) font:[UIFont systemFontOfSize:13]];
    return size.height;
}


#pragma mark - 拨打电话
- (IBAction)phoneBtn:(UIButton *)sender {
    
    if ([self.dataModel.phone containsString:@","]) {
       NSArray *arry =   [self.dataModel.phone componentsSeparatedByString:@","];
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"拨打商家电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
        for (int i = 0; i < arry.count; i ++) {
            [sheet addButtonWithTitle:arry[i]];
        }
        [sheet showInView:self.viewController.view];
    }else{
        //只有一个电话号码
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.dataModel.phone];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.viewController.view addSubview:callWebview];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",[actionSheet buttonTitleAtIndex:buttonIndex]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


@end
