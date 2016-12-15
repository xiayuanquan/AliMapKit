//
//  AliMapViewSearchByDistrictController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//  行政区划分查询

#import "AliMapViewDistrictSearchController.h"

@interface AliMapViewDistrictSearchController ()<MAMapViewDelegate,AMapSearchDelegate>
@property (nonatomic, strong)AMapSearchAPI *POISearchManager;     //POI检索引擎
@property (nonatomic, strong)MAMapView *mapView;                  //地图
@property (nonatomic, strong)NSMutableArray *locations;           //全部的经纬度
@end

@implementation AliMapViewDistrictSearchController

//懒加载
-(NSMutableArray *)locations{
    if (!_locations) {
        _locations = [NSMutableArray array];
    }
    return _locations;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    [_mapView setZoomLevel:12.0f animated:YES];
    [self.view addSubview:_mapView];
    
    //创建POI检索引擎
    _POISearchManager = [[AMapSearchAPI alloc] init];
    _POISearchManager.delegate = self;
  
    //创建行政区查询请求
    AMapDistrictSearchRequest *districtSearchRequest = [[AMapDistrictSearchRequest alloc] init];
    districtSearchRequest.keywords           =  @"东城区";
    districtSearchRequest.requireExtension   =  YES;
    districtSearchRequest.showBusinessArea   =  YES;
    
    //发起请求,开始POI的行政区检索
    [_POISearchManager AMapDistrictSearch:districtSearchRequest];
}

#pragma mark - <AMapSearchDelegate>
//检索失败
-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}


//收集检索到的行政区目标
- (void)onDistrictSearchDone:(AMapDistrictSearchRequest *)request response:(AMapDistrictSearchResponse *)response{
    if (response.count==0) return;
    
    [response.districts enumerateObjectsUsingBlock:^(AMapDistrict * _Nonnull district, NSUInteger idx, BOOL * _Nonnull stop) {
        [self drawDistrictOverLayr:district.polylines];
        [self AddPinAnnotation:district];
    }];
}

//绘制行政区边界
-(void)drawDistrictOverLayr:(NSArray<NSString *> *)polylines{
    
    //获取所有的边界坐标
    [polylines enumerateObjectsUsingBlock:^(NSString * _Nonnull coordinateLngLatObj, NSUInteger idx, BOOL * _Nonnull stop) {
        //截取(目前所有的经纬度是一个连接的整字符串)
        NSArray *all = [coordinateLngLatObj componentsSeparatedByString:@";"];
        [all enumerateObjectsUsingBlock:^(NSString *LngLatObj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            //再一次截取(将单个经纬度字符串截取出来)
            CLLocationDegrees lng =[[[LngLatObj componentsSeparatedByString:@","]firstObject] doubleValue];
            CLLocationDegrees lat = [[[LngLatObj componentsSeparatedByString:@","]lastObject] doubleValue];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
            [self.locations addObject:location];
        }];
    }];
    
    //构造折线数据对象(经纬度)
    CLLocationCoordinate2D commonPolylineCoords[self.locations.count];
    for (int i=0; i<self.locations.count; i++) {
        CLLocation *location = self.locations[i];
        commonPolylineCoords[i].latitude  = location.coordinate.latitude;
        commonPolylineCoords[i].longitude = location.coordinate.longitude;
    }
    
    //构造折线对象
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:self.locations.count];

    //在地图上添加折线对象
    [_mapView addOverlay:commonPolyline];
    
}

//显示行政区中心，并显示大头针
-(void)AddPinAnnotation:(AMapDistrict *)district{
    
    //创建大头针
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(district.center.latitude,district.center.longitude);
    pointAnnotation.title = district.name;
    pointAnnotation.subtitle = district.adcode;
    
    //将大头针添加到地图中
    [_mapView addAnnotation:pointAnnotation];
    
    //默认选中气泡
    [_mapView selectAnnotation:pointAnnotation animated:YES];
}


#pragma mark <MAMapViewDelegate>
//实现<MAMapViewDelegate>协议中的mapView:viewForOverlay:回调函数，设置折线的样式
-(MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 8.f;
        polylineRenderer.strokeColor  = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.6];
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;
    
        return polylineRenderer;
    }
    return nil;
}
//实现<MAMapViewDelegate>协议中的mapView:viewForAnnotation:回调函数，设置大头针标注图
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES; //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;  //设置标注动画显示，默认为NO
        annotationView.draggable = YES;     //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}
@end
