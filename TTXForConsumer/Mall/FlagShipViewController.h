//
//  FlagShipViewController.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/27.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "BaseViewController.h"

@interface FlagShipViewController : BaseViewController


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (nonatomic, strong)NSMutableArray *flagShipArray;

@end
