//
//  HomeViewController.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/16.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController



@property (weak, nonatomic) IBOutlet UIView *naviGaitonView;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
- (IBAction)cityBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
- (IBAction)scanBtn:(UIButton *)sender;

- (IBAction)shakeBtn:(UIButton *)sender;



@property (weak, nonatomic) IBOutlet UITableView *tableView;

//当前城市
@property (nonatomic, strong)NSString *currentCity;


@end
