//
//  OnlineMerCityTableViewCell.h
//  TTXForConsumer
//
//  Created by Guo on 16/10/18.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlineMerCityTableViewCell : BaseTableViewCell

@property (nonatomic, strong)NSMutableArray *venceArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)allGoodsBtn:(id)sender;

@end
