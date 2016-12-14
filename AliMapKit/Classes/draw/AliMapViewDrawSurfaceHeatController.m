//
//  AliMapViewDrawSurfaceHeatController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserveded.
//  

#import "AliMapViewDrawSurfaceHeatController.h"

@interface AliMapViewDrawSurfaceHeatController ()<MAMapViewDelegate>
@property (nonatomic, strong)MAMapView *mapView;
@end

@implementation AliMapViewDrawSurfaceHeatController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    [_mapView setZoomLevel:11.f animated:YES];
    
    //把地图添加至view
    [self.view addSubview:_mapView];
    
    //构造热力图图层
    [self buildHeatOverLay];
}


//构造热力图图层
-(void)buildHeatOverLay{
 
    //构造热力图图层对象
    MAHeatMapTileOverlay  *heatMapTileOverlay = [[MAHeatMapTileOverlay alloc] init];
    
    //构造热力图数据，从locations.json中读取经纬度
    NSMutableArray* data = [NSMutableArray array];
    
    NSData *jsdata = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"heatMapData" ofType:@"json"]];
    
    @autoreleasepool {
        
        if (jsdata)
        {
            NSArray *dicArray = [NSJSONSerialization JSONObjectWithData:jsdata options:NSJSONReadingAllowFragments error:nil];
            
            for (NSDictionary *dic in dicArray)
            {
                MAHeatMapNode *node = [[MAHeatMapNode alloc] init];
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = [dic[@"lat"] doubleValue];
                coordinate.longitude = [dic[@"lng"] doubleValue];
                node.coordinate = coordinate;
                
                node.intensity = 1;//设置权重
                [data addObject:node];
            }
        }
        
        heatMapTileOverlay.data = data;
        
        //构造渐变色对象
        MAHeatMapGradient *gradient = [[MAHeatMapGradient alloc] initWithColor:@[[UIColor blueColor],[UIColor greenColor], [UIColor redColor]] andWithStartPoints:@[@(0.2),@(0.5),@(0.9)]];
        heatMapTileOverlay.gradient = gradient;
        
        //将热力图添加到地图上
        [_mapView addOverlay: heatMapTileOverlay];
    }
}

#pragma mark - <MAMapViewDelegate>
//实现MAMapViewDelegate的mapView:rendererForOverlay:函数，在热力图显示在地图View上。示例代码如下：
-(MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    
    if ([overlay isKindOfClass:[MATileOverlay class]])
    {
        MATileOverlayRenderer *tileOverlayView = [[MATileOverlayRenderer alloc] initWithTileOverlay:overlay];
        return tileOverlayView;
    }
    return nil;
}

@end
