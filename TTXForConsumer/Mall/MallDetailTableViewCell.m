//
//  MallDetailTableViewCell.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/23.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "MallDetailTableViewCell.h"
#import "FlagshipCollectionViewCell.h"
#import "GoodsSearchRsultViewController.h"
#import "UIColor+Wonderful.h"
#import "SXMarquee.h"
#import "SXHeadLine.h"
#import "FlagShipViewController.h"

@implementation DiscountModel

+ (id)modelWithDic:(NSDictionary *)dic
{
    DiscountModel *model = [[DiscountModel alloc]init];
    model.disCountId = NullToSpace(dic[@"id"]);
    model.name = NullToSpace(dic[@"name"]);
    model.jumpWay = NullToSpace(dic[@"jumpWay"]);
    model.jumpValue = NullToSpace(dic[@"jumpValue"]);
    model.pic = NullToSpace(dic[@"pic"]);
    return model;
}


@end

@interface MallDetailTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,SwipeViewDelegate,SwipeViewDataSource>

@end

@implementation MallDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.swipeView.dataSource = self;
    self.swipeView.delegate = self;
    self.topLineLabel.textColor = MacoTitleColor;
}


- (void)setFlagShipArray:(NSMutableArray *)flagShipArray
{
    if (!_flagShipArray) {
        _flagShipArray = [NSMutableArray array];
    }
    [_flagShipArray removeAllObjects];
    [_flagShipArray addObjectsFromArray:flagShipArray];
    if (_flagShipArray.count > 3) {
        self.flagShipHeight.constant = TWitdh*(492/750.);
    }else{
        self.flagShipHeight.constant = TWitdh*(310/750.);
    }
    
    [self.collectionView reloadData];
}


- (void)setDisCountArray:(NSMutableArray *)disCountArray
{
    if (!_disCountArray) {
        _disCountArray = [NSMutableArray array];
    }
    [_disCountArray removeAllObjects];
    [_disCountArray addObjectsFromArray:disCountArray];
    self.pageView.numberOfPages = _disCountArray.count;
    [self.swipeView reloadData];
}

- (void)setTopLineArray:(NSMutableArray *)topLineArray
{
    if (!_topLineArray) {
        _topLineArray = [NSMutableArray array];
    }
    [_topLineArray removeAllObjects];
    [_topLineArray addObjectsFromArray:topLineArray];
    if (_topLineArray.count > 0) {
        self.topLineLabel.text = NullToSpace(_topLineArray[0][@"name"]);

    }
}


#pragma mark - 限时折扣

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return self.disCountArray.count;
}


- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIImageView *imageView = nil;
    if (nil == view) {
        view = [[UIView alloc] initWithFrame:swipeView.bounds];
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        imageView.bounds = CGRectMake(0, 0, TWitdh, self.swipeView.bounds.size.height);
        imageView.center = swipeView.center;
        imageView.tag = 10;
        [view addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        view.autoresizingMask = UIViewAutoresizingFlexibleHeight |
//        UIViewAutoresizingFlexibleWidth;
//        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
//        UIViewAutoresizingFlexibleHeight;
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
        [view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view).insets(insets);
        }];
        

    }else {
        imageView = (UIImageView*)[view viewWithTag:10];
    }
    view.backgroundColor = [UIColor redColor];

    DiscountModel *model = self.disCountArray[index];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:BannerLoadingErrorImage];

    return view;
}


- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{
    self.pageView.currentPage = swipeView.currentPage;
}


-(void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    DiscountModel *model = self.disCountArray[index];
}


#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if (self.sortDataSouceArray.count < 5) {
//        return self.sortDataSouceArray.count;
//    }
    return self.flagShipArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier =[FlagshipCollectionViewCell indentify];
    static BOOL nibri =NO;
    if(!nibri)
    {
        UINib *nib = [FlagshipCollectionViewCell newCell];
        [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
        nibri =YES;
    }
    FlagshipCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.dataModel = self.flagShipArray[indexPath.item];
    nibri=NO;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FlagShipDataModel *model = self.flagShipArray[indexPath.item];
    GoodsSearchRsultViewController *resultVC = [[GoodsSearchRsultViewController alloc]init];
    resultVC.venceId = model.flagShipId;
    resultVC.venceName = model.name;
    resultVC.searchName = @"";
    [self.viewController.navigationController pushViewController:resultVC animated:YES];
}


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.sortDataSouceArray.count < 5) {
//        return CGSizeMake(TWitdh/self.sortDataSouceArray.count, 50);
//    }
    return CGSizeMake((TWitdh- 16)/3., (TWitdh*(490/750.)-(TWitdh *(8/75.)))/2.);
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




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




- (IBAction)moreTopShip:(id)sender {
    FlagShipViewController *shipVC = [[FlagShipViewController alloc]init];
    shipVC.flagShipArray = self.flagShipArray;
    [self.viewController.navigationController pushViewController:shipVC animated:YES];
}
@end
