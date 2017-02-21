//
//  MerchantCommentLIstVIew.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/21.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "MerchantCommentLIstVIew.h"
#import "CommentTableViewCell.h"
#import "MerchantCommentListViewController.h"

@interface MerchantCommentLIstVIew()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MerchantCommentLIstVIew



- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.backgroundColor = [UIColor clearColor];
    self.quanbulabel.textColor = MacoColor;
    self.alerLabel.textColor = MacoDetailColor;

}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"MerchantCommentLIstVIew" owner:nil options:nil][0];
        self.quanbulabel.textColor = MacoColor;
        
    }
    return self;
}


- (void)setCommentArray:(NSMutableArray *)commentArray
{
    _commentArray = commentArray;
    
    if (_commentArray.count == 0) {
        self.alerLabel.hidden = NO;
        self.moreBtn.enabled = NO;
    }else{
        self.alerLabel.hidden = YES;
        self.moreBtn.enabled = YES;
    }
    self.quanbulabel.hidden = self.rightImage.hidden= !self.alerLabel.hidden;
    [self.tableView reloadData];
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

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

    BussessComment *comment = self.commentArray[indexPath.row];
    if (comment.replyFlag) {
        return 120;
    }
    return 70;
}

//查看全部评论
- (IBAction)checkAllComment:(UIButton *)sender
{
    MerchantCommentListViewController *allCommentVC = [[MerchantCommentListViewController alloc]init];
    allCommentVC.code = self.mchCode;
    [self.viewController.navigationController pushViewController:allCommentVC animated:YES];

}
@end
