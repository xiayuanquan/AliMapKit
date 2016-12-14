//
//  AliMapViewLocationDataAvailableController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.erved.
//  判断目标经纬度是否在大陆或以外地区

#import "AliMapViewLocationDataAvailableController.h"

@interface AliMapViewLocationDataAvailableController ()<MAMapViewDelegate>
@property (nonatomic, strong)MAMapView *mapView;     //地图
@end

@implementation AliMapViewLocationDataAvailableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    
    //设置缩放级别
    [_mapView setZoomLevel:3 animated:YES];
    
    //把地图添加至view
    [self.view addSubview:_mapView];
}

//点击地图获取信息，此处模拟判断目标经纬度是否在大陆或以外地区
-(void)mapView:(MAMapView *)mapView didTouchPois:(NSArray *)pois{
    
    MATouchPoi *touch = (MATouchPoi *)[pois lastObject];
    if (!touch.name) return;//必须点击有效地区才会触发该方法
    NSLog(@"%@-----%lf----%lf",touch.name,touch.coordinate.longitude,touch.coordinate.latitude);
    
    //返回是否在大陆或以外地区，返回YES为大陆地区，NO为非大陆。
    BOOL flag= AMapLocationDataAvailableForCoordinate(touch.coordinate);
    if (flag) {
        NSLog(@"大陆地区");
    }else{
        NSLog(@"非大陆地区");
    }
}

@end
