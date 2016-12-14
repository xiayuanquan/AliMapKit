//
//  AliMapViewDrawCircleController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved
//

#import "AliMapViewDrawSurfaceCircleController.h"

@interface AliMapViewDrawSurfaceCircleController ()<MAMapViewDelegate>
@property (nonatomic, strong)MAMapView *mapView;
@end

@implementation AliMapViewDrawSurfaceCircleController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    //初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(39.952136, 116.50095);
    [_mapView setZoomLevel:11.f animated:YES];
    
    //把地图添加至view
    [self.view addSubview:_mapView];
    
    //构造圆
    [self buildSurfaceCircle];
}


//绘制圆
-(void)buildSurfaceCircle{
    
    //构造圆
    MACircle *circle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(39.952136, 116.50095) radius:5000];
    
    //在地图上添加圆
    [_mapView addOverlay: circle];
}


#pragma mark - <MAMapViewDelegate>
//实现<MAMapViewDelegate>协议中的mapView:rendererForOverlay:回调函数，设置圆的样式。示例代码如下：
-(MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay{
    
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleView = [[MACircleRenderer alloc] initWithCircle:overlay];
        circleView.lineWidth = 5.f;
        circleView.strokeColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8];
        circleView.fillColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:0.8];
        circleView.lineDash = YES;//YES表示虚线绘制，NO表示实线绘制
        return circleView;
    }
    return nil;
}


@end
