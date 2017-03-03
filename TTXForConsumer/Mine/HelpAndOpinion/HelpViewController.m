//
//  HelpViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/24.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "HelpViewController.h"
#import "OpinionViewController.h"
#import "HelpTableViewCell.h"


@interface HelpViewController ()<BasenavigationDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>

@property (nonatomic, strong)NSMutableArray *dataSouceArray;

@end

@implementation HelpViewController
{
    BOOL  isOpen;
    NSInteger temp;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.taleView.backgroundColor = [UIColor clearColor];
    self.naviBar.title = @"帮助与反馈";
    self.naviBar.hiddenDetailBtn = NO;
    self.naviBar.detailTitle = @"联系客服";
    self.naviBar.delegate = self;
    isOpen = NO;
    
    self.opinionBtn.layer.cornerRadius = 35/2.;
    self.opinionBtn.backgroundColor = MacoColor;
    self.opinionBtn.layer.masksToBounds = YES;
    __weak HelpViewController *weak_self = self;
    self.taleView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weak_self getRequest];
    }];
    [self.taleView addNoDatasouceWithCallback:^{
        [weak_self.taleView.mj_header beginRefreshing];
    } andAlertSting:@"暂时没有帮助与反馈信息" andErrorImage:@"pic_2" andRefreshBtnHiden:YES];
    [self.taleView.mj_header beginRefreshing];
}


#pragma mark - 网络数据请求、
- (void)getRequest
{
    [HttpClient POST:@"user/question/common/get" parameters:nil success:^(NSURLSessionDataTask *operation, id jsonObject) {
        [self.taleView.mj_header endRefreshing];
        if (IsRequestTrue) {
            NSArray *array = jsonObject[@"data"];
            [self.dataSouceArray removeAllObjects];
            for (NSDictionary *dic in array) {
                [self.dataSouceArray addObject:[HelpModel modelWithDic:dic]];
            }
            [self.taleView judgeIsHaveDataSouce:self.dataSouceArray];
            [self.taleView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self.taleView.mj_header endRefreshing];
        
    }];
}

- (NSMutableArray *)dataSouceArray
{
    if (!_dataSouceArray) {
        _dataSouceArray = [NSMutableArray array];
    }
    return _dataSouceArray;
}
#pragma mark - UITalbeView


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HelpTableViewCell indentify]];
    if (!cell) {
        cell = [HelpTableViewCell newCell];
    }
    cell.dataModel = self.dataSouceArray[indexPath.row];
    if (temp == indexPath.row && isOpen) {
        cell.detailView.hidden = NO;
        cell.markImage.image = [UIImage imageNamed:@"icon_mine_retract"];
    }else{
        cell.detailView.hidden = YES;;
        cell.markImage.image = [UIImage imageNamed:@"icon_enter"];

    }
    if (indexPath.row == self.dataSouceArray.count-1) {
        cell.fengeView.hidden= YES;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSouceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isOpen) {
        if (indexPath.row == temp) {
            return  [self cellQuestionrHeight:self.dataSouceArray[indexPath.row]] + [self cellHeight:self.dataSouceArray[indexPath.row]];
        }
    }
    return [self cellQuestionrHeight:self.dataSouceArray[indexPath.row]];
}

- (CGFloat)cellQuestionrHeight:(HelpModel *)model
{
    CGSize size = [model.question boundingRectWithSize:CGSizeMake(TWitdh  - 62, 0) font:[UIFont systemFontOfSize:15]] ;
    return size.height + 20;
}


- (CGFloat)cellHeight:(HelpModel *)model
{
    CGSize size = [model.answer boundingRectWithSize:CGSizeMake(TWitdh  - 24, 0) font:[UIFont systemFontOfSize:13]] ;
    return size.height + 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    HelpTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
 
    for (HelpTableViewCell *obj in tableView.visibleCells) {
        obj.detailView.hidden = YES;
        obj.markImage.image = [UIImage imageNamed:@"icon_enter"];
    }
    isOpen = !isOpen;
    if (temp != indexPath.row) {
        isOpen = YES;
    }
    temp = indexPath.row;
    NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
    NSArray * indexPaths = [NSArray arrayWithObjects:indexPath1, nil];
    [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}



- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HelpTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    [UIView animateWithDuration:0.2 animations:^{
//        cell.markImage.transform=CGAffineTransformMakeRotation(0);
//    }];
}

#pragma mark - 联系客服
- (void)detailBtnClick
{
//    UIWebView *webView = (UIWebView*)[self.view viewWithTag:1000];
//    if (!webView) {
//        webView = [[UIWebView alloc]init];
//    }
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"4001028997"]]]];
//    [self.view addSubview:webView];
//    NSArray *arry =  @[@"02862908389",@"02862908390",@"02862908391",@"02862908392"];
    NSArray *arry =  @[@"4001619619"];

    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"拨打客服电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
    for (int i = 0; i < arry.count; i ++) {
        [sheet addButtonWithTitle:arry[i]];
    }
    [sheet showInView:self.view];
}


- (IBAction)opinionBtn:(UIButton *)sender {
    OpinionViewController *opinionVC = [[OpinionViewController alloc]init];
    [self.navigationController pushViewController:opinionVC animated:YES];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",[actionSheet buttonTitleAtIndex:buttonIndex]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
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
