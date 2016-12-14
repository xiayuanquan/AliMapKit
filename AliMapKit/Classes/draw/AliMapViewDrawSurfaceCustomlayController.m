//
//  AliMapViewDrawSurfaceCustomlayController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved
//  绘制自定义图层

#import "AliMapViewDrawSurfaceCustomlayController.h"

#define kTileOverlayRemoteServerTemplate @"http://cache1.arcgisonline.cn/arcgis/rest/services/ChinaCities_Community_BaseMap_ENG/BeiJing_Community_BaseMap_ENG/MapServer/tile/{z}/{y}/{x}"

#define kTileOverlayRemoteMinZ      4
#define kTileOverlayRemoteMaxZ      17

#define kTileOverlayLocalMinZ       11
#define kTileOverlayLocalMaxZ       13

@interface AliMapViewDrawSurfaceCustomlayController ()<MAMapViewDelegate>
@property (nonatomic, strong)MAMapView *mapView;
@end

@implementation AliMapViewDrawSurfaceCustomlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    [_mapView setZoomLevel:11.f animated:YES];
    
    //把地图添加至view
    [self.view addSubview:_mapView];
    
    //绘制自定义图层
    [self buildCustomOverlay];
}

//绘制自定义图层
-(void)buildCustomOverlay{
    
    MATileOverlay *tileOverlay = [[MATileOverlay alloc] initWithURLTemplate:kTileOverlayRemoteServerTemplate];
    
    /* minimumZ 是tileOverlay的可见最小Zoom值. */
    tileOverlay.minimumZ = kTileOverlayRemoteMinZ;
    /* minimumZ 是tileOverlay的可见最大Zoom值. */
    tileOverlay.maximumZ = kTileOverlayRemoteMaxZ;
    
    /* boundingMapRect 是用来 设定tileOverlay的可渲染区域. */
    tileOverlay.boundingMapRect = MAMapRectWorld;
    
    //添加
    [_mapView addOverlay:tileOverlay];
}

#pragma mark - <MAMapViewDelegate>
//实现MAMapViewDelegate的mapView:rendererForOverlay:函数，在overlay图层显示在地图View上。示例代码如下：
-(MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    
    if ([overlay isKindOfClass:[MATileOverlay class]])
    {
        MATileOverlayRenderer *tileOverlayRenderer = [[MATileOverlayRenderer alloc] initWithTileOverlay:overlay];
        return tileOverlayRenderer;
    }
    return nil;
}

@end
