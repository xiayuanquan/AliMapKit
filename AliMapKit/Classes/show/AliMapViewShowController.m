//
//  AliMapViewShowController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import "AliMapViewShowController.h"

@interface AliMapViewShowController ()<MAMapViewDelegate>
@property (nonatomic, strong)MAMapView *mapView;
@property (nonatomic, strong)UISegmentedControl *segementControl;
@end

@implementation AliMapViewShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置导航栏
    [self setupNavigationBar];
    
    //初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    
    //配置属性
    _mapView.showsLabels = YES;//显示底部标图
    _mapView.showsScale  = YES; //显示比例尺
    _mapView.showTraffic = YES;//显示交通
    _mapView.showsCompass= YES;//显示指南针
    _mapView.zoomEnabled = YES;//开启缩放手势
    _mapView.scrollEnabled = YES;//开启滑动手势
    _mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x, 80);    //设置比例尺位置
    _mapView.compassOrigin= CGPointMake(_mapView.compassOrigin.x, 80);//设置指南针位置
    _mapView.logoCenter = CGPointMake(55, SCREEN_HEGHT-30);//调整地图logol位置
    [_mapView setZoomLevel:17.5 animated:YES];//设置缩放级别
    
    ///把地图添加至view
    [self.view addSubview:_mapView];
    
    //3秒后截图
    [self performSelector:@selector(takeSnapshot) withObject:nil afterDelay:3.0f];
}

//设置导航栏
-(void)setupNavigationBar{
    _segementControl = [[UISegmentedControl alloc]initWithItems:@[@"普通地图",@"卫星地图",@"夜间视图",@"导航视图",@"公交视图"]];
    _segementControl.frame = CGRectMake(0, 0, 250, 40);
    _segementControl.selectedSegmentIndex = 0;
    [_segementControl addTarget:self action:@selector(segementControlValueChange:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segementControl;
}

// 切换地图类型
-(void)segementControlValueChange:(UISegmentedControl *)control{
    _mapView.mapType = control.selectedSegmentIndex;
}


#pragma mark - MAMapViewDelegate
#pragma mark - 代理方法很多，根据需求选择

// 地图开始加载
-(void)mapViewWillStartLoadingMap:(MAMapView *)mapView{
    NSLog(@"%s",__func__);
}

//加载地图结束
-(void)mapViewDidFinishLoadingMap:(MAMapView *)mapView{
    NSLog(@"%s",__func__);
}

//地图加载失败
- (void)mapViewDidFailLoadingMap:(MAMapView *)mapView withError:(NSError *)error{
    NSLog(@"%s---%@",__func__,error);
}



#pragma mark - 地图截频功能
//地图截频
-(void)takeSnapshot{
    __block UIImage *screenshotImage = nil;
    __block NSInteger resState = 0;
    [self.mapView takeSnapshotInRect:self.view.frame withCompletionBlock:^(UIImage *resultImage, NSInteger state) {
        screenshotImage = resultImage;
        resState = state; // state表示地图此时是否完整，0-不完整，1-完整
    }];
    NSLog(@"%@",screenshotImage);
}

@end
