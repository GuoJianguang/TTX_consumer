//
//  BussessMapViewController.m
//  天添薪
//
//  Created by ttx on 16/1/7.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BussessMapViewController.h"
#import <MapKit/MapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "CommonUtility.h"
#import "MANaviRoute.h"



const NSString *RoutePlanningViewControllerStartTitle       = @"起点";
const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";
const NSInteger RoutePlanningPaddingEdge                    = 20;

@interface BussessMapViewController ()<UIActionSheetDelegate,MAMapViewDelegate,AMapSearchDelegate>

//@property (nonatomic, strong)MAMapView *mapView;

@property (nonatomic, strong) AMapSearchAPI *search;

/* 路径规划类型 */
//@property (nonatomic) AMapRoutePlanningType routePlanningType;

@property (nonatomic, strong) AMapRoute *route;

/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;

/* 路线方案个数. */
@property (nonatomic) NSInteger totalCourse;


/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;
@property (nonatomic, strong) MAPointAnnotation *startAnnotation;
@property (nonatomic, strong) MAPointAnnotation *destinationAnnotation;

//是否已经规划路线
@property (nonatomic,assign)BOOL isGuihua;


@end

@implementation BussessMapViewController

{
    MAMapView *_mapview;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviBar.title = @"商家地图";

//    [_mapview setCenterCoordinate:self.stopcoordinate animated:YES];
    self.stopcoordinate        = CLLocationCoordinate2DMake(45.793617, 126.649628);
    
    ///初始化地图
    if (_mapview == nil)
    {
        CGRect rect = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 85);
        _mapview = [[MAMapView alloc] initWithFrame:rect];
        [_mapview setDelegate:self];
        [self.view addSubview:_mapview];
    }
    
    [_mapview setUserTrackingMode:MAUserTrackingModeFollow animated:YES];

    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    ///把地图添加至view
    
    [TTXUserInfo setjianpianColorwithView:self.naviBtn_view withWidth:CGRectGetWidth(self.naviBtn_view.bounds) withHeight:CGRectGetHeight(self.naviBtn_view.bounds)];
    self.naviBtn_view.layer.cornerRadius = CGRectGetHeight(self.naviBtn_view.bounds)/2;
    self.naviBtn_view.layer.masksToBounds = YES;
    
    self.name_label.text = self.dataModel.name;

    self.address_label.text = self.dataModel.address;
    
    [self.view bringSubviewToFront:self.naviBar];
    [self.view bringSubviewToFront:self.naviView];
    
    [self addDefaultAnnotations];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -  导航按钮点击事件
- (IBAction)naviBtn:(UIButton *)sender
{
    
}

#pragma mark - 定位按钮点击事件
- (IBAction)location_btn:(UIButton *)sender
{
}


#pragma mark -  路径规划
- (void)searchRoutePlanningDrive
{
    self.isGuihua = YES;
//    self.startAnnotation.coordinate = self.startCoordinate;
//    self.destinationAnnotation.coordinate = self.destinationCoordinate;
    
    NSLog(@"startLat==%f  startlong==%f",self.startcoordinate.latitude,self.startcoordinate.longitude);
    NSLog(@"stopLat==%f  stoplong==%f",self.destinationAnnotation.coordinate.latitude,self.destinationAnnotation.coordinate.longitude);

    
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    navi.waypoints = @[[AMapGeoPoint locationWithLatitude:45.780563 longitude:126.651764]];
    navi.requireExtension = YES;
    //    navi.strategy = 5;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.stopcoordinate.latitude
                                                longitude:self.stopcoordinate.longitude];
    [self.search AMapDrivingRouteSearch:navi];

}


- (void)addDefaultAnnotations
{
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.startCoordinate;
    startAnnotation.title      = (NSString*)RoutePlanningViewControllerStartTitle;
    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startCoordinate.latitude, self.startCoordinate.longitude];
    self.startAnnotation = startAnnotation;
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.stopcoordinate;
    destinationAnnotation.title      = (NSString*)RoutePlanningViewControllerDestinationTitle;
    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.stopcoordinate.latitude, self.stopcoordinate.longitude];
    self.destinationAnnotation = destinationAnnotation;
    
    [_mapview addAnnotation:startAnnotation];
    [_mapview addAnnotation:destinationAnnotation];

}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    
    self.route = response.route;
    self.currentCourse = 0;
    if (response.count > 0)
    {
        [self presentCurrentCourse];
    }
}



/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    MANaviAnnotationType type = MANaviAnnotationTypeDrive;
    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[self.currentCourse] withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:self.startAnnotation.coordinate.latitude longitude:self.startAnnotation.coordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationAnnotation.coordinate.latitude longitude:self.destinationAnnotation.coordinate.longitude]];
    [self.naviRoute addToMapView:_mapview];
    
    /* 缩放地图使其适应polylines的展示. */
    [_mapview showOverlays:self.naviRoute.routePolylines edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge) animated:YES];
}

#pragma mark - MAMapViewDelegate


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
    }
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        polylineRenderer.lineWidth   = 8;
        polylineRenderer.lineDashPattern = @[@10, @15];
        polylineRenderer.strokeColor = [UIColor redColor];
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 8;
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        }
        else if (naviPolyline.type == MANaviAnnotationTypeRailway)
        {
            polylineRenderer.strokeColor = self.naviRoute.railwayColor;
        }
        else
        {
            polylineRenderer.strokeColor = self.naviRoute.routeColor;
        }
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MAMultiPolyline class]])
    {
        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
        
        polylineRenderer.lineWidth = 8;
        polylineRenderer.strokeColors = [self.naviRoute.multiPolylineColors copy];
        polylineRenderer.gradient = YES;
        
        return polylineRenderer;
    }
    
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *routePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[_mapview dequeueReusableAnnotationViewWithIdentifier:routePlanningCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:routePlanningCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.image = nil;
        
        if ([annotation isKindOfClass:[MANaviAnnotation class]])
        {
            switch (((MANaviAnnotation*)annotation).type)
            {
                case MANaviAnnotationTypeRailway:
                    poiAnnotationView.image = [UIImage imageNamed:@"railway_station"];
                    break;
                    
                case MANaviAnnotationTypeBus:
                    poiAnnotationView.image = [UIImage imageNamed:@"bus"];
                    break;
                    
                case MANaviAnnotationTypeDrive:
                    poiAnnotationView.image = [UIImage imageNamed:@"car"];
                    break;
                    
                case MANaviAnnotationTypeWalking:
                    poiAnnotationView.image = [UIImage imageNamed:@"man"];
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            /* 起点. */
            if ([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerStartTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];
            }
            /* 终点. */
            else if([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerDestinationTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];
            }
        }
        
        return poiAnnotationView;
    }
    
    return nil;
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapview clearDisk];
    _mapview = nil;
}


@end
