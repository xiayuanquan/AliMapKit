//
//  AliMapViewDrawCustomAnnotationController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import "AliMapViewDrawCustomAnnotationController.h"
#import "AliMapViewCustomCalloutView.h"
#import "AliMapViewCustomAnnotationView.h"
#import "AliMapViewCustomPinAnnotationView.h"

@interface AliMapViewDrawCustomAnnotationController ()<MAMapViewDelegate>
@property (nonatomic, strong)MAMapView *mapView;
@property (nonatomic, strong)UISegmentedControl *segementControl;
@property (nonatomic, strong)MAPointAnnotation *pointAnnotation;
@property (nonatomic, strong)AliMapViewCustomAnnotationView *annotationView;      //纯自定义大头针标注视图
@property (nonatomic, strong)AliMapViewCustomPinAnnotationView *annotationPinView;//继承默认大头针标注视图
@end

@implementation AliMapViewDrawCustomAnnotationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置导航栏
    [self setupNavigationBar];
    
    //初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(39.915168,116.403875);
    [_mapView setZoomLevel:14.f animated:YES];
    
    //把地图添加至view
    [self.view addSubview:_mapView];
}

//设置导航栏
-(void)setupNavigationBar{
    _segementControl = [[UISegmentedControl alloc]initWithItems:@[@"纯自定义大头针标注",@"继承默认大头针标注"]];
    _segementControl.frame = CGRectMake(0, 0, 250, 40);
    _segementControl.selectedSegmentIndex = 0;
    [_segementControl addTarget:self action:@selector(segementControlValueChange:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segementControl;
}

// 切换大头针标注
-(void)segementControlValueChange:(UISegmentedControl *)control{
    [_mapView removeAnnotation:self.pointAnnotation];//先移除旧的大头针标注视图
    [_mapView reloadMap];//重新加载地图
    [self createPointAnnotation];//再创建新的大头针标注视图
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self createPointAnnotation];
}

//创建大头针
-(void)createPointAnnotation{
    
    //创建大头针
    self.pointAnnotation = [[MAPointAnnotation alloc] init];
    self.pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.915168,116.403875);
    self.pointAnnotation.title = @"天安门城楼";
    self.pointAnnotation.subtitle = @"北京天安门广场";
    
    //将大头针添加到地图中
    [_mapView addAnnotation:self.pointAnnotation];
    
    //默认选中气泡
    [self.mapView selectAnnotation:self.pointAnnotation animated:YES];
}


#pragma mark <MAMapViewDelegate>
//获取标注视图
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        if (_segementControl.selectedSegmentIndex==0) {
           return [self fullCustomAnnotationViewWithMapView:mapView viewForAnnotation:annotation];
        }
        return [self NotfullCustomAnnotationViewWithMapView:mapView viewForAnnotation:annotation];
    }
    return nil;
}


//使用纯定义大头针标注视图
-(AliMapViewCustomAnnotationView *)fullCustomAnnotationViewWithMapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    static NSString *reuseIndetifier = @"annotationReuseIndetifier";
    AliMapViewCustomAnnotationView *annotationView = (AliMapViewCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
    if (annotationView == nil)
    {
        annotationView = [[AliMapViewCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
    }
    annotationView.image = [UIImage imageNamed:@"location"];
    
    //设置为NO，用以调用自定义的calloutView
    annotationView.canShowCallout = NO;
    
    //设置中心点偏移，使得标注底部中间点成为经纬度对应点
    annotationView.centerOffset = CGPointMake(0, -18);
    
    return annotationView;
}


//使用继承默认大头针标注视图
-(AliMapViewCustomPinAnnotationView *)NotfullCustomAnnotationViewWithMapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    static NSString *reuseIndetifier = @"annotationReuseIndetifier";
    AliMapViewCustomPinAnnotationView *annotationView = (AliMapViewCustomPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
    if (annotationView == nil)
    {
        annotationView = [[AliMapViewCustomPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
    }
    //设置为NO，用以调用自定义的calloutView
    annotationView.canShowCallout = NO;
    
    //设置中心点偏移，使得标注底部中间点成为经纬度对应点
    annotationView.centerOffset = CGPointMake(0, -18);
    
    return annotationView;
}

@end
