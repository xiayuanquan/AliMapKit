//
//  AliMapViewDrawPolylineController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import "AliMapViewDrawPolylineController.h"

@interface AliMapViewDrawPolylineController ()<MAMapViewDelegate>
@property (nonatomic, strong)MAMapView *mapView;
@end

@implementation AliMapViewDrawPolylineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    [_mapView setZoomLevel:12.f animated:YES];
    
    //把地图添加至view
    [self.view addSubview:_mapView];
    
    //构造折线数据对象和折线对象
    [self buildPolyline];
}


//构造折线数据对象和折线对象
-(void)buildPolyline{
 
    //构造折线数据对象(经纬度)
    CLLocationCoordinate2D commonPolylineCoords[4];
    commonPolylineCoords[0].latitude = 39.832136;
    commonPolylineCoords[0].longitude = 116.34095;
    
    commonPolylineCoords[1].latitude = 39.832136;
    commonPolylineCoords[1].longitude = 116.42095;
    
    commonPolylineCoords[2].latitude = 39.902136;
    commonPolylineCoords[2].longitude = 116.42095;
    
    commonPolylineCoords[3].latitude = 39.902136;
    commonPolylineCoords[3].longitude = 116.44095;
    
    //构造折线对象
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:4];
    
    //在地图上添加折线对象
    [_mapView addOverlay: commonPolyline];
}

#pragma mark <MAMapViewDelegate>
//实现<MAMapViewDelegate>协议中的mapView:viewForOverlay:回调函数，设置折线的样式
-(MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 8.f;
        polylineRenderer.strokeColor  = [UIColor colorWithRed:1 green:0 blue:1 alpha:0.6];
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;
        
        //设置纹理图片
        //注意：纹理图片必须是正方形，宽高是2的整数幂，如64*64，否则无效；若设置了纹理图片，设置线颜色、连接类型和端点类型将无效，目前仅支持设置折线纹理
        //[polylineRenderer loadStrokeTextureImage:[UIImage imageNamed:@"custom.png"]];
        
        return polylineRenderer;
    }
    return nil;
}

@end
