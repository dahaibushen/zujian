//
//  ViewController.m
//  Location-Geofence-Demo
//
//  Created by eidan on 16/12/22.
//  Copyright © 2016年 autonavi. All rights reserved.
//

#import "MapViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>

@interface MapViewController ()<MAMapViewDelegate,AMapGeoFenceManagerDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapGeoFenceManager *geoFenceManager;  //地理围栏管理类ggit

@property (nonatomic, strong) CLLocation *userLocation;  //获得自己的位置，方便demo添加围栏进行测试，

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initMapView];
    
    [self configGeoFenceManager];

    [self initUI];
}
-(void)initUI{
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(40, 20, 40, 40);
    [btn setTitle:@"画图" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:9];
    [btn addTarget:self action:@selector(mapClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor orangeColor];
    
    UIButton *btn1 = [UIButton new];
    btn1.frame = CGRectMake(100, 20, 40, 40);
    btn1.titleLabel.font = [UIFont systemFontOfSize:9];
    [btn1 setTitle:@"点坐标" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(oneLocationMapClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    btn1.backgroundColor = [UIColor orangeColor];
}

//初始化地图
- (void)initMapView {
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 125, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 125)];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    [self.view sendSubviewToBack:self.mapView];
}

//初始化地理围栏manager
- (void)configGeoFenceManager {
    self.geoFenceManager = [[AMapGeoFenceManager alloc] init];
    self.geoFenceManager.delegate = self;
//    self.geoFenceManager.allowsBackgroundLocationUpdates = YES;  //允许后台定位
}

//添加地理围栏对应的Overlay，方便查看。地图上显示圆
- (MACircle *)showCircleInMap:(CLLocationCoordinate2D )coordinate radius:(NSInteger)radius {
    MACircle *circleOverlay = [MACircle circleWithCenterCoordinate:coordinate radius:radius];
    [self.mapView addOverlay:circleOverlay];
    return circleOverlay;
}

//地图上显示多边形
- (MAPolygon *)showPolygonInMap:(CLLocationCoordinate2D *)coordinates count:(NSInteger)count {
    MAPolygon *polygonOverlay = [MAPolygon polygonWithCoordinates:coordinates count:count];
    [self.mapView addOverlay:polygonOverlay];
    return polygonOverlay;
}

// 清除上一次按钮点击创建的围栏
- (void)doClear {
    [self.mapView removeOverlays:self.mapView.overlays];  //把之前添加的Overlay都移除掉
    [self.geoFenceManager removeAllGeoFenceRegions];  //移除所有已经添加的围栏，如果有正在请求的围栏也会丢弃
}

#pragma mark - Xib btns click

//添加圆形围栏按钮点击
- (void)addGeoFenceCircleRegion{
    
    [self doClear];
    self.geoFenceManager.activeAction = AMapGeoFenceActiveActionInside | AMapGeoFenceActiveActionOutside | AMapGeoFenceActiveActionStayed; //监听进入、退出、停留事件
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(39.998919, 116.467841); //北京望京地铁站
    if (self.userLocation) {
//        coordinate = self.userLocation.coordinate;
    }
    [self.geoFenceManager addCircleRegionForMonitoringWithCenter:coordinate radius:300 customID:@"Product_Detail_Favorite_Pressed"];
}

-(void)mapClick:(UIButton*)btn{
    //画多边形
    [self addGeoFencePolygonRegion];
    //查找周边
//    [self addGeoFencePOIAroundRegion];
}
-(void)oneLocationMapClick:(UIButton*)btn{
    [self addGeoFenceCircleRegion];
}

//添加多边形围栏按钮点击:北京朝阳公园
- (void)addGeoFencePolygonRegion{
    
    NSString * coordianteString = @"114.381001,30.512584;114.378082,30.496759;114.410526,30.495132;114.420139,30.509626;114.40057,30.526041";
    
    
    NSArray *array = [coordianteString componentsSeparatedByString:@";"];
    
    CLLocationCoordinate2D *coorArr = malloc(sizeof(CLLocationCoordinate2D) * array.count);
    
    for (int i = 0; i < array.count; i++) {
        NSArray *temp = [[array objectAtIndex:i] componentsSeparatedByString:@","];
        coorArr[i] = CLLocationCoordinate2DMake([temp[1] doubleValue], [temp[0] doubleValue]);
    }
    
    [self doClear];
    self.geoFenceManager.activeAction = AMapGeoFenceActiveActionInside | AMapGeoFenceActiveActionOutside | AMapGeoFenceActiveActionStayed; //监听进入、退出、停留事件
    
    [self.geoFenceManager addPolygonRegionForMonitoringWithCoordinates:coorArr count:array.count customID:@"polygon_1"];
    
    free(coorArr);  //malloc，使用后，记得free
    coorArr = NULL;
}

//添加POI关键词围栏按钮点击:北京地区麦当劳
- (IBAction)addGeoFencePOIKeywordRegion:(id)sender {
    
    [self doClear];
    self.geoFenceManager.activeAction = AMapGeoFenceActiveActionInside | AMapGeoFenceActiveActionStayed; //监听进入、停留事件
    
    [self.geoFenceManager addKeywordPOIRegionForMonitoringWithKeyword:@"麦当劳" POIType:@"快餐厅" city:@"北京" size:2 customID:@"poi_keyword"];
}

//添加POI周边围栏按钮点击：周边肯德基围栏
- (void)addGeoFencePOIAroundRegion{
    
    [self doClear];
    self.geoFenceManager.activeAction = AMapGeoFenceActiveActionInside | AMapGeoFenceActiveActionStayed; //监听进入、停留事件
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(39.908692, 116.397477); //天安门
    if (self.userLocation) {
        coordinate = self.userLocation.coordinate;
    }
    [self.geoFenceManager addAroundPOIRegionForMonitoringWithLocationPoint:coordinate aroundRadius:5000 keyword:@"肯德基" POIType:@"快餐厅" size:2 customID:@"poi_around"];
}

//添加行政区域围栏按钮点击:北京市西城区
- (IBAction)addGeoFenceDistrictRegion:(id)sender {
    
    [self doClear];
    self.geoFenceManager.activeAction = AMapGeoFenceActiveActionInside | AMapGeoFenceActiveActionStayed; //监听进入、停留事件
    
    [self.geoFenceManager addDistrictRegionForMonitoringWithDistrictName:@"西城区" customID:@"district_1"];
}

#pragma mark - AMapGeoFenceManagerDelegate

//添加地理围栏完成后的回调，成功与失败都会调用
- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didAddRegionForMonitoringFinished:(NSArray<AMapGeoFenceRegion *> *)regions customID:(NSString *)customID error:(NSError *)error {
    if ([customID hasPrefix:@"circle"]) {
        if (error) {
            NSLog(@"======= circle error %@",error);
        } else {  //围栏添加后，在地图上的显示，只是为了更方便的演示，并不是必须的.
            
            AMapGeoFenceCircleRegion *circleRegion = (AMapGeoFenceCircleRegion *)regions.firstObject;  //一次添加一个圆形围栏，只会返回一个
            MACircle *circleOverlay = [self showCircleInMap:circleRegion.center radius:circleRegion.radius];
            [self.mapView setVisibleMapRect:circleOverlay.boundingMapRect edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:NO];   //设置地图的可见范围，让地图缩放和平移到合适的位置
            
        }
    } else if ([customID isEqualToString:@"polygon_1"]){
        if (error) {
            NSLog(@"=======polygon error %@",error);
        } else {  //围栏添加后，在地图上的显示，只是为了更方便的演示，并不是必须的.
            
            AMapGeoFencePolygonRegion *polygonRegion = (AMapGeoFencePolygonRegion *)regions.firstObject;
            MAPolygon *polygonOverlay = [self showPolygonInMap:polygonRegion.coordinates count:polygonRegion.count];
            [self.mapView setVisibleMapRect:polygonOverlay.boundingMapRect edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:NO];
            
        }
    } else if ([customID isEqualToString:@"poi_keyword"]){
        if (error) {
            NSLog(@"======== poi_keyword error %@",error);
        } else {  //围栏添加后，在地图上的显示，只是为了更方便的演示，并不是必须的.
            
            for (AMapGeoFencePOIRegion *region in regions) {
                [self showCircleInMap:region.center radius:region.radius];
            }
            
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(39.908692, 116.397477); //天安门
            self.mapView.centerCoordinate = coordinate;
            self.mapView.zoomLevel = 11;
            
        }
    } else if ([customID isEqualToString:@"poi_around"]){
        if (error) {
            NSLog(@"======== poi_around error %@",error);
        } else {  //围栏添加后，在地图上的显示，只是为了更方便的演示，并不是必须的.
            
            for (AMapGeoFencePOIRegion *region in regions) {
                [self showCircleInMap:region.center radius:region.radius];
            }
            
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(39.908692, 116.397477); //天安门
            self.mapView.centerCoordinate = self.userLocation ? self.userLocation.coordinate : coordinate;
            self.mapView.zoomLevel = 13;
        }
    } else if ([customID isEqualToString:@"district_1"]){
        if (error) {
            NSLog(@"======== district1 error %@",error);
        } else { //围栏添加后，在地图上的显示，只是为了更方便的演示，并不是必须的.
            
            for (AMapGeoFenceDistrictRegion *region in regions) {
                
                for (NSArray *arealocation in region.polylinePoints) {
                    
                    CLLocationCoordinate2D *coorArr = malloc(sizeof(CLLocationCoordinate2D) * arealocation.count);
                    
                    for (int i = 0; i < arealocation.count; i++) {
                        AMapLocationPoint *point = [arealocation objectAtIndex:i];
                        coorArr[i] = CLLocationCoordinate2DMake(point.latitude, point.longitude);
                    }
                    
                    MAPolygon *polygonOverlay = [self showPolygonInMap:coorArr count:arealocation.count];
                    [self.mapView setVisibleMapRect:polygonOverlay.boundingMapRect edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:NO];
                    
                    free(coorArr);  //malloc，使用后，记得free
                    coorArr = NULL;
                    
                }
                
            }
        }
    }
}

//地理围栏状态改变时回调，当围栏状态的值发生改变，定位失败都会调用
- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didGeoFencesStatusChangedForRegion:(AMapGeoFenceRegion *)region customID:(NSString *)customID error:(NSError *)error {
    if (error) {
        NSLog(@"status changed error %@",error);
    }else{
        NSLog(@"status changed %@",[region description]);
    }
}


#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    self.userLocation = userLocation.location;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolygon class]]) {
        MAPolygonRenderer *polylineRenderer = [[MAPolygonRenderer alloc] initWithPolygon:overlay];
        polylineRenderer.lineWidth = 1.0f;
        polylineRenderer.strokeColor = [UIColor orangeColor];
        
        return polylineRenderer;
    } else if ([overlay isKindOfClass:[MACircle class]]) {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        circleRenderer.lineWidth = 1.0f;
        circleRenderer.strokeColor = [UIColor purpleColor];
        
        return circleRenderer;
    }
    return nil;
}

- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout               = YES;
        annotationView.animatesDrop                 = YES;
        annotationView.draggable                    = NO;
        annotationView.rightCalloutAccessoryView    = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return annotationView;
    }
    
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
