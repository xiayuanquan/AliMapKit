//
//  AliMapViewSinglePositionController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//  单次定位

#import "AliMapViewSinglePositionController.h"

@interface AliMapViewSinglePositionController ()
@property (strong, nonatomic)AMapLocationManager *locationManager;//定位管理者
@property (strong, nonatomic)UIView  *containView;       //容器视图
@property (strong, nonatomic)UILabel *lngLabel;          //经度标签
@property (strong, nonatomic)UILabel *lngValueLabel;     //经度值标签
@property (strong, nonatomic)UILabel *latLabel;          //纬度标签
@property (strong, nonatomic)UILabel *latValueLabel;     //纬度值标签
@property (strong, nonatomic)UILabel *provinceLabel;     //省份标签
@property (strong, nonatomic)UILabel *provinceValueLabel;//省份值标签
@property (strong, nonatomic)UILabel *cityLabel;         //城市标签
@property (strong, nonatomic)UILabel *cityValueLabel;    //城市值标签
@property (strong, nonatomic)UILabel *districtLabel;     //区镇标签
@property (strong, nonatomic)UILabel *districtValueLabel;//省区镇值标签
@end

@implementation AliMapViewSinglePositionController

//======================================================================================//
//======================================================================================//
//==============================提示：尽量用真机测试，这样容易定位成功========================//
//==============================提示：或者用模拟器手动设置定位区，这样也能定位成功==============//
//======================================================================================//
//======================================================================================//

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建子视图
    [self setupAllSubViews];
    
    //创建定位管理者
    self.locationManager = [[AMapLocationManager alloc] init];
    [self setLocationManagerForHundredMeters];
    
    //一次获取定位信息（带反编码）
    [XYQProgressHUD showMessage:@"正在定位"];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        [XYQProgressHUD hideHUD];
        if (error){
            [XYQProgressHUD showError:@"定位失败"];
            if(error.code == AMapLocationErrorLocateFailed) return;
        }
        if (location && regeocode){
            [XYQProgressHUD showSuccess:@"定位成功"];
            [self showLocationInfomation:location ReGeocode:regeocode];
        }
    }];
}

//设置百米精确度
-(void)setLocationManagerForHundredMeters{
 
    //1.带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //2.定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    
    //3.逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
}

//设置十米精确度
-(void)setLocationManagerForAccuracyBest{
 
    //1.带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //2定位超时时间，最低2s，此处设置为10s
    self.locationManager.locationTimeout =10;
    
    //3.逆地理请求超时时间，最低2s，此处设置为10s
    self.locationManager.reGeocodeTimeout = 10;
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
    
    //经度标签
    _lngLabel = [[UILabel alloc] init];
    _lngLabel.text = @"经度:";
    _lngLabel.backgroundColor = [UIColor orangeColor];
    _lngLabel.textColor = [UIColor blackColor];
    _lngLabel.font = [UIFont systemFontOfSize:15];
    [_containView addSubview:_lngLabel];
    [_lngLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 50));
        make.left.mas_equalTo(_containView).with.offset(0);
        make.top.mas_equalTo(_containView).with.offset(5);
    }];
    _lngValueLabel = [[UILabel alloc] init];
    _lngValueLabel.textAlignment = NSTextAlignmentCenter;
    _lngValueLabel.textColor = [UIColor blackColor];
    _lngValueLabel.font = [UIFont systemFontOfSize:15];
    _lngValueLabel.backgroundColor = [UIColor lightGrayColor];
    [_containView addSubview:_lngValueLabel];
    [_lngValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-2*Cell_Border-40, 50));
        make.left.mas_equalTo(_lngLabel).with.offset(40);
        make.top.mas_equalTo(_containView).with.offset(5);
    }];
    
    //纬度标签
    _latLabel = [[UILabel alloc] init];
    _latLabel.text = @"纬度:";
    _latLabel.backgroundColor = [UIColor orangeColor];
    _latLabel.textColor = [UIColor blackColor];
    _latLabel.font = [UIFont systemFontOfSize:15];
    [_containView addSubview:_latLabel];
    [_latLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 50));
        make.left.mas_equalTo(_containView).with.offset(0);
        make.top.mas_equalTo(_lngLabel).with.offset(60);
    }];
    _latValueLabel = [[UILabel alloc] init];
    _latValueLabel.textColor = [UIColor blackColor];
    _latValueLabel.textAlignment = NSTextAlignmentCenter;
    _latValueLabel.font = [UIFont systemFontOfSize:15];
    _latValueLabel.backgroundColor = [UIColor lightGrayColor];
    [_containView addSubview:_latValueLabel];
    [_latValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-2*Cell_Border-40, 50));
        make.left.mas_equalTo(_lngLabel).with.offset(40);
        make.top.mas_equalTo(_lngValueLabel).with.offset(60);
    }];
    
    
    //省份标签
    _provinceLabel = [[UILabel alloc] init];
    _provinceLabel.text = @"省份:";
    _provinceLabel.backgroundColor = [UIColor orangeColor];
    _provinceLabel.textColor = [UIColor blackColor];
    _provinceLabel.font = [UIFont systemFontOfSize:15];
    [_containView addSubview:_provinceLabel];
    [_provinceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 50));
        make.left.mas_equalTo(_containView).with.offset(0);
        make.top.mas_equalTo(_latLabel).with.offset(60);
    }];
    _provinceValueLabel = [[UILabel alloc] init];
    _provinceValueLabel.textColor = [UIColor blackColor];
    _provinceValueLabel.textAlignment = NSTextAlignmentCenter;
    _provinceValueLabel.font = [UIFont systemFontOfSize:15];
    _provinceValueLabel.backgroundColor = [UIColor lightGrayColor];
    [_containView addSubview:_provinceValueLabel];
    [_provinceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-2*Cell_Border-40, 50));
        make.left.mas_equalTo(_provinceLabel).with.offset(40);
        make.top.mas_equalTo(_latValueLabel).with.offset(60);
    }];
    
    //城市标签
    _cityLabel = [[UILabel alloc] init];
    _cityLabel.text = @"城市:";
    _cityLabel.backgroundColor = [UIColor orangeColor];
    _cityLabel.textColor = [UIColor blackColor];
    _cityLabel.font = [UIFont systemFontOfSize:15];
    [_containView addSubview:_cityLabel];
    [_cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 50));
        make.left.mas_equalTo(_containView).with.offset(0);
        make.top.mas_equalTo(_provinceLabel).with.offset(60);
    }];
    _cityValueLabel = [[UILabel alloc] init];
    _cityValueLabel.textColor = [UIColor blackColor];
    _cityValueLabel.textAlignment = NSTextAlignmentCenter;
    _cityValueLabel.font = [UIFont systemFontOfSize:15];
    _cityValueLabel.backgroundColor = [UIColor lightGrayColor];
    [_containView addSubview:_cityValueLabel];
    [_cityValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-2*Cell_Border-40, 50));
        make.left.mas_equalTo(_provinceLabel).with.offset(40);
        make.top.mas_equalTo(_provinceValueLabel).with.offset(60);
    }];
    
    //区镇标签
    _districtLabel = [[UILabel alloc] init];
    _districtLabel.text = @"区镇:";
    _districtLabel.backgroundColor = [UIColor orangeColor];
    _districtLabel.textColor = [UIColor blackColor];
    _districtLabel.font = [UIFont systemFontOfSize:15];
    [_containView addSubview:_districtLabel];
    [_districtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 50));
        make.left.mas_equalTo(_containView).with.offset(0);
        make.top.mas_equalTo(_cityLabel).with.offset(60);
    }];
    _districtValueLabel = [[UILabel alloc] init];
    _districtValueLabel.textColor = [UIColor blackColor];
    _districtValueLabel.textAlignment = NSTextAlignmentCenter;
    _districtValueLabel.font = [UIFont systemFontOfSize:15];
    _districtValueLabel.backgroundColor = [UIColor lightGrayColor];
    [_containView addSubview:_districtValueLabel];
    [_districtValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-2*Cell_Border-40, 50));
        make.left.mas_equalTo(_provinceLabel).with.offset(40);
        make.top.mas_equalTo(_cityValueLabel).with.offset(60);
    }];
}

//显示定位信息
-(void)showLocationInfomation:(CLLocation *)location ReGeocode:(AMapLocationReGeocode *)regeocode{
    
    _lngValueLabel.text = [NSString stringWithFormat:@"%lf",location.coordinate.longitude];
    _latValueLabel.text = [NSString stringWithFormat:@"%lf",location.coordinate.latitude];
    _provinceValueLabel.text = regeocode.province;
    _cityValueLabel.text = regeocode.city;
    _districtValueLabel.text = regeocode.district;
}

@end
