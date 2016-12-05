//
//  BussessMapViewController.m
//  天添薪
//
//  Created by ttx on 16/1/7.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BussessMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MANaviRoute.h"
#import "CommonUtility.h"
#import <MapKit/MapKit.h>


const NSString *RoutePlanningViewControllerStartTitle       = @"起点";
const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";
const NSInteger RoutePlanningPaddingEdge                    = 20;

@interface BussessMapViewController ()<MAMapViewDelegate,AMapSearchDelegate,UIActionSheetDelegate>

@property (nonatomic, strong)MAMapView *mapView;

@property (nonatomic, strong) AMapSearchAPI *search;

/* 路径规划类型 */
@property (nonatomic) AMapRoutePlanningType routePlanningType;

@property (nonatomic, strong) AMapRoute *route;

/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;

/* 路线方案个数. */
@property (nonatomic) NSInteger totalCourse;


/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;

//是否已经规划路线
@property (nonatomic,assign)BOOL isGuihua;


@end

@implementation BussessMapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviBar.title = @"商家地图";
    // Do any additional setup after loading the view from its nib.
    self.mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), THeight-64-85)];
    [self.view addSubview:self.mapView];
    
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.showsScale = YES;
    _mapView.showTraffic= NO;
    _mapView.zoomEnabled = YES;
    _mapView.zoomLevel = 13;
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    
    _search = [[AMapSearchAPI alloc]init];
    
//    self.startcoordinate        = CLLocationCoordinate2DMake(39.910267, 116.370888);
//    self.stopcoordinate  = CLLocationCoordinate2DMake(39.989872, 116.481956);
    
    [_mapView setCenterCoordinate:self.stopcoordinate animated:YES];
    [self addDefaultAnnotations];

    
//    [AMapSearchServices sharedServices].apiKey = MAP_APPKEY_APPSTORE;
    
    self.search = [[AMapSearchAPI alloc]init];
    self.search.delegate = self;
    
    [self.view sendSubviewToBack:self.mapView];
    
    [TTXUserInfo setjianpianColorwithView:self.naviBtn_view withWidth:CGRectGetWidth(self.naviBtn_view.bounds) withHeight:CGRectGetHeight(self.naviBtn_view.bounds)];
    self.naviBtn_view.layer.cornerRadius = CGRectGetHeight(self.naviBtn_view.bounds)/2;
    self.naviBtn_view.layer.masksToBounds = YES;
    
    self.name_label.text = self.dataModel.name;

    self.address_label.text = self.dataModel.address;

}


- (void)addDefaultAnnotations
{
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.startcoordinate;
    startAnnotation.title      = (NSString*)RoutePlanningViewControllerStartTitle;
//    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startcoordinate.latitude, self.startcoordinate.longitude];
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.stopcoordinate;
//    destinationAnnotation.title      = (NSString*)RoutePlanningViewControllerDestinationTitle;
    destinationAnnotation.title = self.dataModel.name;
//    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.stopcoordinate.latitude, self.stopcoordinate.longitude];
    [self.mapView addAnnotation:startAnnotation];
    [self.mapView addAnnotation:destinationAnnotation];
}


/* 驾车路径规划搜索. */
- (void)searchRoutePlanningDrive
{
    self.isGuihua = YES;
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    
    navi.requireExtension = YES;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startcoordinate.latitude
                                           longitude:self.startcoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.stopcoordinate.latitude
                                                longitude:self.stopcoordinate.longitude];
    
    [self.search AMapDrivingRouteSearch:navi];
}



-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
//        [_mapView setCenterCoordinate:userLocation.coordinate animated:YES];
        
        self.startcoordinate = userLocation.coordinate;
        //取出当前位置的坐标
        if (!self.isGuihua) {
            [self searchRoutePlanningDrive];
        }

        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}


#pragma mark - AMapSearchDelegate

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    
    self.route = response.route;
    [self updateTotal];
    self.currentCourse = 0;
    
//    [self updateCourseUI];
//    [self updateDetailUI];
    
    [self presentCurrentCourse];
}

/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    /* 公交路径规划. */
    if (self.routePlanningType == AMapRoutePlanningTypeBus)
    {
        self.naviRoute = [MANaviRoute naviRouteForTransit:self.route.transits[self.currentCourse]];
    }
    /* 步行，驾车路径规划. */
    else
    {
        MANaviAnnotationType type = self.routePlanningType == AMapRoutePlanningTypeDrive ? MANaviAnnotationTypeDrive : MANaviAnnotationTypeWalking;
        self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[self.currentCourse] withNaviType:type];
    }
    
    [self.naviRoute addToMapView:self.mapView];
    
    /* 缩放地图使其适应polylines的展示. */
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                        edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
                           animated:YES];
}

- (void)updateTotal
{
    NSUInteger total = 0;
    
    if (self.route != nil)
    {
        switch (self.routePlanningType)
        {
            case AMapRoutePlanningTypeDrive   :
            case AMapRoutePlanningTypeWalk    : total = self.route.paths.count;    break;
            case AMapRoutePlanningTypeBus     : total = self.route.transits.count; break;
            default: total = 0; break;
        }
    }
    
    self.totalCourse = total;
}



- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        
        if([[annotation title] isEqualToString:(NSString*)self.dataModel.name])
        {
            static NSString *pointReuseIndetifier = @"pointReuseIndetifier_stop";
            MAAnnotationView *stopannotationView = nil;
            stopannotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
            if (stopannotationView == nil) {
                stopannotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            }
            stopannotationView.image = [UIImage imageNamed:@"endPoint"];
            // 设置为 NO,用以调用自定义的 calloutView
            stopannotationView.canShowCallout = YES;
            // 设置中心点偏移,使得标注底部中间点成为经纬度对应点
//            stopannotationView.centerOffset = CGPointMake(0, -18);
            return stopannotationView;
        }

        
        
        static NSString *routePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:routePlanningCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:routePlanningCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        
        if ([annotation isKindOfClass:[MANaviAnnotation class]])
        {
//            switch (((MANaviAnnotation*)annotation).type)
//            {
//                case MANaviAnnotationTypeBus:
//                    poiAnnotationView.image = [UIImage imageNamed:@"bus"];
//                    break;
//                    
//                case MANaviAnnotationTypeDrive:
//                    poiAnnotationView.image = [UIImage imageNamed:@"car"];
//                    break;
//                    
//                case MANaviAnnotationTypeWalking:
//                    poiAnnotationView.image = [UIImage imageNamed:@"man"];
//                    break;
//                    
//                default:
//                    break;
//            }
        }
        else
        {
            /* 起点. */
            if ([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerStartTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];
            }
            /* 终点. */
            else if([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerDestinationTitle] && poiAnnotationView)
            {
                poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];
            }
            
        }
        
        return poiAnnotationView;
    }
    
    return nil;
}


- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        
        polylineRenderer.lineWidth   = 4;
        polylineRenderer.strokeColor = [UIColor blueColor];
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 4;
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        }
        else
        {
            polylineRenderer.strokeColor = self.naviRoute.routeColor;
        }
        
        return polylineRenderer;
    }
    
    return nil;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)location_btn:(UIButton *)sender {
    
    [self.mapView setCenterCoordinate:self.startcoordinate animated:YES];
}
- (IBAction)naviBtn:(UIButton *)sender {
    
    NSString *gaode;

    UIActionSheet *sheetView = [[UIActionSheet alloc]initWithTitle:@"请选择地图" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"使用自带地图导航" otherButtonTitles:nil];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        gaode = @"使用高德地图导航";
        [sheetView addButtonWithTitle:gaode];
    }else{
        gaode = nil;
    }
    
    [sheetView showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
//    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
//    NSString *type = @"path";
//    NSString *sourceApplication = @"THYY";
//    NSString *backScheme = @"THYYGaode";
//    //源id
//    NSString *sid = @"BGVIS1";
//    //起点名称
//    NSString *sname = @"";
//    //目的地id
//    NSString *did = @"BGVIS2";
//    //起点经纬度
//    NSString *lat = @"";
//    NSString *lon = @"";
//    //终点经纬度
//    NSString *dlat = [NSString stringWithFormat:@"%f",self.stopcoordinate.latitude];
//    NSString *dlon = [NSString stringWithFormat:@"%f",self.stopcoordinate.longitude];
//    //终点名称
//    NSString *dname = self.dataModel.name;
//    //线路类型
//    NSString *m = @"0";
//    //导航类型
//    NSString *t = [NSString stringWithFormat:@"%d",0];
//    NSString *dev = @"1";
//    
//    MANaviConfig * config = [[MANaviConfig alloc] init];
//    config.destination = self.stopcoordinate;
//    config.appScheme = backScheme;
//    config.appName = sourceApplication;
//    config.strategy = MADrivingStrategyShortest;
//    
//    if ([buttonTitle isEqualToString:@"使用自带地图导航"]) {
//        //当前的位置
//        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
//        //起点
//        //目的地的位置
//        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.stopcoordinate addressDictionary:nil]];
//        
//        toLocation.name = self.dataModel.name;
//        NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
//        NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
//        //打开苹果自身地图应用，并呈现特定的item
//        [MKMapItem openMapsWithItems:items launchOptions:options];
//        
//    }else if ([buttonTitle isEqualToString:@"使用高德地图导航"]){
//        NSString *str = [NSString stringWithFormat:@"iosamap://%@?sourceApplication=%@&sid=%@&slat=%@&slon=%@&sname=%@&did=%@&dlat=%@&dlon=%@&dname=%@&dev=%@&m=%@&t=%@",type,sourceApplication,sid,lat,lon,sname,did,dlat,dlon,dname,dev,m,t];
//        NSString *str1 = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str1]];
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView clearDisk];
    self.mapView = nil;
}


@end
