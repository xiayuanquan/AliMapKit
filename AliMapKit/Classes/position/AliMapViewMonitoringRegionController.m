//
//  AliMapViewMonitoringRegionController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.erved.
//  地理围栏是一个（或多个）圆形的地理边界作为虚拟围栏，当设备进入、离开该区域时，可以接收到消息通知

#import "AliMapViewMonitoringRegionController.h"

@interface AliMapViewMonitoringRegionController ()<MAMapViewDelegate,AMapLocationManagerDelegate>
@property (nonatomic, strong)MAMapView *mapView;     //地图
@property (nonatomic, strong)NSMutableArray *regions;//添加围栏的数组
@property (nonatomic, strong)AMapLocationManager *locationManager;//定位管理者
@property (nonatomic, strong) AMapLocationCircleRegion *cirRegion200;//半径为200的围栏
@property (nonatomic, strong) AMapLocationCircleRegion *cirRegion300;//半径为300的围栏
@end

//======================================================================================//
//======================================================================================//
//==============================提示：尽量用真机测试，这样容易定位成功========================//
//==============================提示：或者用模拟器手动设置定位区，这样也能定位成功==============//
//======================================================================================//
//======================================================================================//

@implementation AliMapViewMonitoringRegionController

//懒加载
-(NSMutableArray *)regions{
    if (!_regions) {
        _regions = [NSMutableArray array];
    }
    return _regions;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建定位管理者
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    //初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    
    //设置属性
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.915168,116.403875)];
    [_mapView setZoomLevel:17.5 animated:YES];
    
    //把地图添加至view
    [self.view addSubview:_mapView];
    
    //添加地理围栏
    [self addMonitoringForRegion];
}

//添加地理围栏
-(void)addMonitoringForRegion{
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(39.915168,116.403875);
    _cirRegion200 = [[AMapLocationCircleRegion alloc] initWithCenter:coordinate
                                                                                       radius:200.0
                                                                                   identifier:@"circleRegion200"];
    
    _cirRegion300 = [[AMapLocationCircleRegion alloc] initWithCenter:coordinate
                                                                                       radius:300.0
                                                                                   identifier:@"circleRegion300"];
    
    //添加地理围栏
    [self.locationManager startMonitoringForRegion:_cirRegion200];
    [self.locationManager startMonitoringForRegion:_cirRegion300];
    
    //保存地理围栏
    [self.regions addObject:_cirRegion200];
    [self.regions addObject:_cirRegion300];
    
    //添加Overlay
    MACircle *circle200 = [MACircle circleWithCenterCoordinate:coordinate radius:200.0];
    MACircle *circle300 = [MACircle circleWithCenterCoordinate:coordinate radius:300.0];
    [self.mapView addOverlay:circle300];
    [self.mapView addOverlay:circle200];
   
    
    //设置可见
    [_mapView setVisibleMapRect:circle300.boundingMapRect];
}


#pragma mark - AMapLocationManagerDelegate
//监测围栏的进入和出去
- (void)amapLocationManager:(AMapLocationManager *)manager didEnterRegion:(AMapLocationRegion *)region
{
    NSLog(@"进入围栏:%@", region);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didExitRegion:(AMapLocationRegion *)region
{
    NSLog(@"走出围栏:%@", region);
}

//设置图层
-(MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
    
    if ([overlay isKindOfClass:[MACircle class]]) {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        MACircle *circle = (MACircle *)overlay;
        if (circle.radius==300) {
            circleRenderer.fillColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
        }else{
            circleRenderer.fillColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.5];
        }
        return circleRenderer;
    }
    return nil;
}

//点击地图获取信息，此处模拟是否进入围栏、走出围栏(上面的两个代理方法需要实地走动才能监测到)
-(void)mapView:(MAMapView *)mapView didTouchPois:(NSArray *)pois{
    
    MATouchPoi *touch = (MATouchPoi *)[pois lastObject];
    if (!touch.name) return;//必须点击有效地区才会触发该方法
    NSLog(@"%@-----%lf----%lf",touch.name,touch.coordinate.longitude,touch.coordinate.latitude);
    
    //判断是否在此区域内
    BOOL isOrNotInnerForCirRegion200 = [_cirRegion200 containsCoordinate:touch.coordinate];
    BOOL isOrNotInnerForCirRegion300 = [_cirRegion300 containsCoordinate:touch.coordinate];
    
    if (isOrNotInnerForCirRegion200) {
        NSLog(@"进入cirRegion200-----进入cirRegion300的围栏了");
    }
    else if (!isOrNotInnerForCirRegion200 && isOrNotInnerForCirRegion300){
        NSLog(@"走出cirRegion200-----进入cirRegion300的围栏了");
    }
    else if (!isOrNotInnerForCirRegion200 && !isOrNotInnerForCirRegion300){
        NSLog(@"走出cirRegion200-----走出cirRegion300的围栏了");
    }
}

@end
