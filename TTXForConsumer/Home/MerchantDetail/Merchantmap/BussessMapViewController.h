//
//  BussessMapViewController.h
//  天添薪
//
//  Created by ttx on 16/1/7.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "BaseViewController.h"
#import "BussessDetailModel.h"
#import <MAMapKit/MAMapKit.h>




@interface BussessMapViewController : BaseViewController

@property (nonatomic, strong)BussessDetailModel *dataModel;

//@property (nonatomic, strong) MAMapView *mapView;


//起点
@property (nonatomic, assign) CLLocationCoordinate2D startcoordinate;
//终点
@property (nonatomic, assign) CLLocationCoordinate2D stopcoordinate;



@property (weak, nonatomic) IBOutlet UIView *naviView;

@property (weak, nonatomic) IBOutlet UIButton *location_btn;

- (IBAction)location_btn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *name_label;

@property (weak, nonatomic) IBOutlet UILabel *address_label;

@property (weak, nonatomic) IBOutlet UIView *naviBtn_view;

@property (weak, nonatomic) IBOutlet UIButton *naviBtn;
- (IBAction)naviBtn:(UIButton *)sender;

@end
