//
//  AliMapViewCustomNavDeriveController.m
//  AliMapKit
//
//  Created by FanLei on 16/12/16.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import "AliMapViewCustomNavDeriveController.h"
#import "UIImage+Extension.h"

@interface AliMapViewCustomNavDeriveController ()<AMapNaviDriveManagerDelegate>
@property (strong ,nonatomic)AMapNaviDriveView *driveView;       //导航界面
@property (strong ,nonatomic)AMapNaviDriveManager *driveManager; //导航管理者
@end

@implementation AliMapViewCustomNavDeriveController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDriveView];
    [self initDriveManager];
}

- (void)initDriveView
{
    if (!self.driveView){
        //初始化导航界面
        self.driveView = [[AMapNaviDriveView alloc] initWithFrame:CGRectMake(0,64,SCREEN_WIDTH,SCREEN_HEGHT-64)];
        self.driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        //可以将导航界面的界面元素进行隐藏，然后通过自定义的控件展示导航信息
        [self.driveView setShowUIElements:NO];
        
        
        //显示交通状况、箭头、指南针、摄像头(这些全部都可以自定义)
        [self.driveView setShowTrafficLayer:YES];
        [self.driveView setShowTurnArrow:YES];
        [self.driveView setShowCompass:YES];
        [self.driveView setShowCamera:YES];
        
        
        //自定义实时交通路线Polyline的样式
        [self.driveView setLineWidth:8];
        [self.driveView setStatusTextures:@{
                            @(AMapNaviRouteStatusUnknow): [UIImage imageNamed:@"custtexture_no.png"],
                            @(AMapNaviRouteStatusSmooth): [UIImage imageNamed:@"custtexture_green.png"],
                            @(AMapNaviRouteStatusSlow): [UIImage imageNamed:@"custtexture_slow.png"],
                            @(AMapNaviRouteStatusJam): [UIImage imageNamed:@"custtexture.png"],
                            @(AMapNaviRouteStatusSeriousJam): [UIImage imageNamed:@"custtexture_bad.png"]}];

        
        //设置自定义的Car图标和CarCompass图标
        [self.driveView setCarImage:[UIImage imageNamed:@"animatedCar_1.png"]];
        
        
        
        //改变地图的追踪模式
        if (self.driveView.trackingMode == AMapNaviViewTrackingModeCarNorth)
        {
            self.driveView.trackingMode = AMapNaviViewTrackingModeMapNorth;//地图指北
        }
        else if (self.driveView.trackingMode == AMapNaviViewTrackingModeMapNorth)
        {
            self.driveView.trackingMode = AMapNaviViewTrackingModeCarNorth;//车头指北
        }
        
        [self.view addSubview:self.driveView];
    }
}

- (void)initDriveManager
{
    if (!self.driveManager){
        
        //初始化导航管理者
        self.driveManager = [[AMapNaviDriveManager alloc] init];
        [self.driveManager setDelegate:self];
        
        
        //设置驾车出行路线规划
        AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:40.22 longitude:116.23];//昌平区
        AMapNaviPoint *endPoint   = [AMapNaviPoint locationWithLatitude:39.85 longitude:116.28];//丰台区
        [self.driveManager calculateDriveRouteWithStartPoints:@[startPoint]
                                                    endPoints:@[endPoint]
                                                    wayPoints:nil
                                              drivingStrategy:17];
        //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
        [self.driveManager addDataRepresentative:self.driveView];
    }
}


#pragma mark - AMapNaviDriveManagerDelegate
//驾车路径规划成功后的回调函数
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    //算路成功后进行模拟导航
    [self.driveManager startEmulatorNavi];
    [self.driveManager setEmulatorNaviSpeed:80];
}

@end
