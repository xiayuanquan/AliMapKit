//
//  AliMapViewBackgroundPositionController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//  后台定位可持久记录位置信息，适用于记轨迹录。

#import "AliMapViewBackgroundPositionController.h"

@interface AliMapViewBackgroundPositionController ()<AMapLocationManagerDelegate>
@property (strong, nonatomic)AMapLocationManager *locationManager;//定位管理者
@property (strong, nonatomic)UIView  *containView;                //容器视图
@property (strong, nonatomic)UILabel *positionLabel;              //定位提示
@property (strong, nonatomic)UITextView *positionTextView;        //定位内容
@property (strong, nonatomic)NSMutableString *mutableStr;         //可变的字符串
@end

//======================================================================================//
//======================================================================================//
//==============================提示：尽量用真机测试，这样容易定位成功========================//
//==============================提示：或者用模拟器手动设置定位区，这样也能定位成功==============//
//======================================================================================//
//======================================================================================//

@implementation AliMapViewBackgroundPositionController

//懒加载
-(NSMutableString *)mutableStr{
    if (!_mutableStr) {
        _mutableStr = [NSMutableString string];
    }
    return _mutableStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //创建子视图
    [self setupAllSubViews];
    
    //创建定位管理者
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    //设置经度为百米
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    
    //逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    
    //设置允许后台定位参数，保持不会被系统挂起
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];//iOS9(含)以上系统需设置
    
    //开始持续定位(启动退出程序到后台，也会一直处于定位状态)
    [self.locationManager startUpdatingLocation];
}

#pragma mark - AMapLocationManagerDelegate
//在回调函数中，获取定位坐标，进行业务处理。
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}",location.coordinate.latitude,location.coordinate.longitude, location.horizontalAccuracy);
    [self showLocationInfomation:location];
    
    if (reGeocode)
    {
        NSLog(@"reGeocode:%@", reGeocode);
    }
}


//创建子视图
-(void)setupAllSubViews{
    
    //容器视图
    _containView = [[UIView alloc] init];
    _containView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_containView];
    [_containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-2*Cell_Border, 300));
        make.center.mas_equalTo(self.view);
    }];
    
    //定位标签
    _positionLabel = [[UILabel alloc] init];
    _positionLabel.text = @"在后台持续定位的信息如下";
    _positionLabel.backgroundColor = [UIColor orangeColor];
    _positionLabel.textColor = [UIColor blackColor];
    _positionLabel.textAlignment = NSTextAlignmentCenter;
    _positionLabel.font = [UIFont systemFontOfSize:15];
    [_containView addSubview:_positionLabel];
    [_positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-2*Cell_Border, 50));
        make.top.left.mas_equalTo(_containView).with.offset(0);
    }];
    
    
    //定位内容
    _positionTextView = [[UITextView alloc] init];
    _positionTextView.backgroundColor = [UIColor lightGrayColor];
    _positionTextView.textColor = [UIColor blackColor];
    _positionTextView.textAlignment = NSTextAlignmentCenter;
    _positionTextView.font = [UIFont systemFontOfSize:15];
    [_containView addSubview:_positionTextView];
    [_positionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-2*Cell_Border, 250));
        make.left.mas_equalTo(_containView).with.offset(0);
        make.top.mas_equalTo(_positionLabel).with.offset(50);
    }];
}

//显示定位信息
-(void)showLocationInfomation:(CLLocation *)location{
    
    [self.mutableStr appendFormat:@"经度：%lf---纬度：%lf\n",location.coordinate.longitude,location.coordinate.latitude];
    _positionTextView.text = self.mutableStr;
}
@end
