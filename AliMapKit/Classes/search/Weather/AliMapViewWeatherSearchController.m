//
//  AliMapViewWeatherSearchController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//  天气查询

#import "AliMapViewWeatherSearchController.h"

@interface AliMapViewWeatherSearchController ()<AMapSearchDelegate>
@property (nonatomic, strong)AMapSearchAPI *POISearchManager;     //POI检索引擎
@property (nonatomic, strong)UILabel *cityLable;         //城市
@property (nonatomic, strong)UILabel *weatherLabel;      //天气
@property (nonatomic, strong)UILabel *tempetureLabel;    //度数
@property (nonatomic, strong)UILabel *windDirectionLable;//风向
@property (nonatomic, strong)UILabel *windPowerLable;    //风力
@property (nonatomic, strong)UILabel *humidityLabel;     //空气湿度
//@property (nonatomic, strong)
@end

@implementation AliMapViewWeatherSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:68/255.0 green:121/255.0 blue:202/255.0 alpha:1.0];
    //创建子控件
    [self createSubViews];
    
    //创建POI检索引擎
    _POISearchManager = [[AMapSearchAPI alloc] init];
    _POISearchManager.delegate = self;
    
    //创建天气查询请求
    AMapWeatherSearchRequest *weatherSearchRequest = [[AMapWeatherSearchRequest alloc] init];
    weatherSearchRequest.city = @"广州";
    weatherSearchRequest.type = AMapWeatherTypeLive; //AMapWeatherTypeLive为实时天气；AMapWeatherTypeForecast为预报天气
    
    //发起请求,开始POI的天气查询检索
    [_POISearchManager AMapWeatherSearch:weatherSearchRequest];
}


#pragma mark - <AMapSearchDelegate>
//检索失败
-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}

//收集检索到的天气目标
- (void)onWeatherSearchDone:(AMapWeatherSearchRequest *)request response:(AMapWeatherSearchResponse *)response{
   
    //实时天气
    [response.lives enumerateObjectsUsingBlock:^(AMapLocalWeatherLive * _Nonnull weatherLiveObj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self setValueForAllWeatherLabel:weatherLiveObj];
    }];
    
    //预测天气
    [response.forecasts enumerateObjectsUsingBlock:^(AMapLocalWeatherForecast * _Nonnull weatherForecastObj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weatherForecastObj.casts enumerateObjectsUsingBlock:^(AMapLocalDayWeatherForecast * _Nonnull ForecastObj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"%@--星期%@--%@°/%@°",ForecastObj.date,ForecastObj.week,ForecastObj.dayTemp,ForecastObj.nightTemp);
        }];
    }];
}

//创建子控件
-(void)createSubViews{
    
    //城市
    _cityLable = [[UILabel alloc] init];
    _cityLable.backgroundColor = [UIColor clearColor];
    _cityLable.textColor = [UIColor whiteColor];
    _cityLable.font = [UIFont systemFontOfSize:40];
    _cityLable.textAlignment = 1;
    [self.view addSubview:_cityLable];
    [_cityLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 80));
        make.top.mas_equalTo(self.view).with.offset(64);
        make.centerX.mas_equalTo(self.view);
    }];
    
    //天气
    _weatherLabel = [[UILabel alloc] init];
    _weatherLabel.backgroundColor = [UIColor clearColor];
    _weatherLabel.textColor = [UIColor whiteColor];
    _weatherLabel.font = [UIFont systemFontOfSize:40];
    _weatherLabel.textAlignment = 1;
    [self.view addSubview:_weatherLabel];
    [_weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 80));
        make.topMargin.mas_equalTo(_cityLable).with.offset(80);
        make.centerX.mas_equalTo(self.view);
    }];
    
    //度数
    _tempetureLabel = [[UILabel alloc] init];
    _tempetureLabel.backgroundColor = [UIColor clearColor];
    _tempetureLabel.textColor = [UIColor whiteColor];
    _tempetureLabel.font = [UIFont systemFontOfSize:100];
    _tempetureLabel.textAlignment = 1;
    [self.view addSubview:_tempetureLabel];
    [_tempetureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 200));
        make.top.mas_equalTo(_weatherLabel).with.offset(80);
        make.centerX.mas_equalTo(self.view);
    }];
    
    //风向
    _windDirectionLable = [[UILabel alloc] init];
    _windDirectionLable.backgroundColor = [UIColor clearColor];
    _windDirectionLable.textColor = [UIColor whiteColor];
    _windDirectionLable.font = [UIFont systemFontOfSize:22];
    _windDirectionLable.textAlignment = 2;
    [self.view addSubview:_windDirectionLable];
    [_windDirectionLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2-40, 60));
        make.top.mas_equalTo(_tempetureLabel).with.offset(200);
        make.left.mas_equalTo(self.view).with.offset(0);
    }];
    
    //风力
    _windPowerLable = [[UILabel alloc] init];
    _windPowerLable.backgroundColor = [UIColor clearColor];
    _windPowerLable.textColor = [UIColor whiteColor];
    _windPowerLable.font = [UIFont systemFontOfSize:22];
    _windPowerLable.textAlignment = 1;
    [self.view addSubview:_windPowerLable];
    [_windPowerLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-(SCREEN_WIDTH/2-40)*2, 60));
        make.top.mas_equalTo(_tempetureLabel).with.offset(200);
        make.left.mas_equalTo(_windDirectionLable).with.offset(SCREEN_WIDTH/2-40);
    }];
    
    //空气湿度
    _humidityLabel = [[UILabel alloc] init];
    _humidityLabel.backgroundColor = [UIColor clearColor];
    _humidityLabel.textColor = [UIColor whiteColor];
    _humidityLabel.font = [UIFont systemFontOfSize:22];
    _humidityLabel.textAlignment = 0;
    [self.view addSubview:_humidityLabel];
    [_humidityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2-40, 60));
        make.top.mas_equalTo(_tempetureLabel).with.offset(200);
        make.left.mas_equalTo(_windPowerLable).with.offset(SCREEN_WIDTH-(SCREEN_WIDTH/2-40)*2);
    }];
}

//设置实时天气标签的值
-(void)setValueForAllWeatherLabel:(AMapLocalWeatherLive * _Nonnull) weatherLiveObj{
    
//    NSLog(@"城市名:  %@",weatherLiveObj.city);
//    NSLog(@"天气现象:%@",weatherLiveObj.weather);
//    NSLog(@"实时温度:%@",weatherLiveObj.temperature);
//    NSLog(@"风向:   %@",weatherLiveObj.windDirection);
//    NSLog(@"风力:   %@",weatherLiveObj.windPower);
//    NSLog(@"空气湿度:%@",weatherLiveObj.humidity);
    
    _cityLable.text = weatherLiveObj.city;
    _weatherLabel.text = weatherLiveObj.weather;
    _tempetureLabel.text = [NSString stringWithFormat:@"%@°",weatherLiveObj.temperature];
    _windDirectionLable.text = [NSString stringWithFormat:@"%@风",weatherLiveObj.windDirection];
    _windPowerLable.text = [NSString stringWithFormat:@"%@级",weatherLiveObj.windPower];
    _humidityLabel.text = [NSString stringWithFormat:@"湿度%@%%",weatherLiveObj.humidity];
    
}

@end
