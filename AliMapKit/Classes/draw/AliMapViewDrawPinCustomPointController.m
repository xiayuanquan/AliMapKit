//
//  AliMapViewDrawPinCustomPointController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import "AliMapViewDrawPinCustomPointController.h"

@interface AliMapViewDrawPinCustomPointController ()<MAMapViewDelegate>
@property (nonatomic, strong)MAMapView *mapView;
@end

@implementation AliMapViewDrawPinCustomPointController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(39.915168,116.403875);
    _mapView.delegate = self;
    [_mapView setZoomLevel:14.f animated:YES];
    
    //把地图添加至view
    [self.view addSubview:_mapView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //创建大头针
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.915168,116.403875);
    pointAnnotation.title = @"天安门城楼";
    pointAnnotation.subtitle = @"北京天安门广场";
    
    //将大头针添加到地图中
    [_mapView addAnnotation:pointAnnotation];
    
    //默认选中气泡
    [self.mapView selectAnnotation:pointAnnotation animated:YES];
}

#pragma mark <MAMapViewDelegate>
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.image = [UIImage imageNamed:@"hema.png"];//设置标注图片
        annotationView.centerOffset = CGPointMake(0, -18);//设置中心点偏移，使得标注底部中间点成为经纬度对应点
        
        return annotationView;
    }
    return nil;
}

@end
