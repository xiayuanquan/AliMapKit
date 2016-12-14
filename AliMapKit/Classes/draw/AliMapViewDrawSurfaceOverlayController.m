//
//  AliMapViewDrawSurfaceOverlayController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserveded.
//  绘制overlay图层

#import "AliMapViewDrawSurfaceOverlayController.h"

@interface AliMapViewDrawSurfaceOverlayController ()<MAMapViewDelegate>
@property (nonatomic, strong)MAMapView *mapView;
@end

@implementation AliMapViewDrawSurfaceOverlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    [_mapView setZoomLevel:11.f animated:YES];
    
    //把地图添加至view
    [self.view addSubview:_mapView];
    
    //构建overlay图层
    [self buildGroundOverlay];
}

//构建overlay图层
-(void)buildGroundOverlay{
    
    //设置从北到南的区域
    MACoordinateBounds coordinateBounds = MACoordinateBoundsMake(CLLocationCoordinate2DMake
                                                                 (39.939577, 116.388331),CLLocationCoordinate2DMake(39.935029, 116.384377));
    //给此区域添加图片图层
    MAGroundOverlay *groundOverlay = [MAGroundOverlay groundOverlayWithBounds:coordinateBounds icon:[UIImage imageNamed:@"GWF"]];
    
    [_mapView addOverlay:groundOverlay];
    
    //设置可见区域为图层区域
    _mapView.visibleMapRect = groundOverlay.boundingMapRect;
}

#pragma mark - <MAMapViewDelegate>
//实现MAMapViewDelegate的mapView:rendererForOverlay:函数，在overlay图层显示在地图View上。示例代码如下：
-(MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    
    if ([overlay isKindOfClass:[MAGroundOverlay class]])
    {
        MAGroundOverlayRenderer *groundOverlayRenderer = [[MAGroundOverlayRenderer alloc] initWithGroundOverlay:overlay];
        return groundOverlayRenderer;
    }
    return nil;
}

@end
