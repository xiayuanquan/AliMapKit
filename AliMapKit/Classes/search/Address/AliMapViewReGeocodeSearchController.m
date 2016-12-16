//
//  AliMapViewReGeocodeSearchController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//  地址反编码查询

#import "AliMapViewReGeocodeSearchController.h"

@interface AliMapViewReGeocodeSearchController ()<AMapSearchDelegate>
@property (nonatomic, strong)AMapSearchAPI *POISearchManager;     //POI检索引擎
@property (strong, nonatomic)UILabel *currentLngLatLabel;         //当前经纬度
@property (strong, nonatomic)UITextView *currentReGeocodeView;    //当前经纬度反编码后的信息
@property (strong, nonatomic)NSMutableString *stringM;            //存储编码信息
@end

@implementation AliMapViewReGeocodeSearchController

-(NSMutableString *)stringM{
    if (!_stringM) {
        _stringM = [NSMutableString string];
    }
    return _stringM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建子控件
    [self createSubViews];
   
    //创建POI检索引擎
    _POISearchManager = [[AMapSearchAPI alloc] init];
    _POISearchManager.delegate = self;
    
    //创建地理反编码请求
    AMapReGeocodeSearchRequest *regeoSearchRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoSearchRequest.location = [AMapGeoPoint locationWithLatitude:39.915168 longitude:116.403875];
    
    //发起请求,开始POI的地理反编码检索
    [_POISearchManager AMapReGoecodeSearch:regeoSearchRequest];
    [XYQProgressHUD showMessage:@"正在地理反编码"];
}

//检索失败
-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}


//收集地理反编码检索到的目标
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    [XYQProgressHUD hideHUD];
    [XYQProgressHUD showSuccess:@"地理反编码成功"];
    [self showGeocodeInformation:response.regeocode];
}

//创建子控件
-(void)createSubViews{
    
    //当前经纬度
    _currentLngLatLabel = [[UILabel alloc] init];
    _currentLngLatLabel.textColor = [UIColor blackColor];
    _currentLngLatLabel.text = @"当前经纬度：<116.403875 ，39.915168> ";
    _currentLngLatLabel.textAlignment = 1;
    _currentLngLatLabel.numberOfLines = 0;
    _currentLngLatLabel.font = [UIFont systemFontOfSize:14];
    _currentLngLatLabel.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.2];
    [_currentLngLatLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH-4*Cell_Border, MAXFLOAT)];
    [self.view addSubview:_currentLngLatLabel];
    [_currentLngLatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-4*Cell_Border, 50));
        make.top.mas_equalTo(self.view).with.mas_offset(100);
        make.centerX.mas_equalTo(self.view);
    }];
    
    //当前经纬度反编码后的信息
    _currentReGeocodeView = [[UITextView alloc] init];
    _currentReGeocodeView.textColor = [UIColor blackColor];
    _currentReGeocodeView.textAlignment = 0;
    _currentReGeocodeView.font = [UIFont systemFontOfSize:14];
    _currentReGeocodeView.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.2];
    [self.view addSubview:_currentReGeocodeView];
    [_currentReGeocodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-4*Cell_Border, 400));
        make.topMargin.mas_equalTo(_currentLngLatLabel).with.mas_offset(50);
        make.centerX.mas_equalTo(self.view);
    }];
}

//显示反编码后信息(信息量太大，暂时只给出那么几个，可以自己点进去看看)
-(void)showGeocodeInformation:(AMapReGeocode *)regeocode{
    
    NSString *formattedAddress = [NSString stringWithFormat:@"格式化地址:%@\n\n",regeocode.formattedAddress];
    NSString *province = [NSString stringWithFormat:@"所在省/直辖市:%@\n\n",regeocode.addressComponent.province];
    NSString *city     = [NSString stringWithFormat:@"城市名:%@\n\n",regeocode.addressComponent.city];
    NSString *citycode = [NSString stringWithFormat:@"城市编码:%@\n\n",regeocode.addressComponent.citycode];
    NSString *district = [NSString stringWithFormat:@"区域名称:%@\n\n",regeocode.addressComponent.district];
    NSString *adcode   = [NSString stringWithFormat:@"乡镇街道:%@\n\n",regeocode.addressComponent.adcode];
    NSString *township = [NSString stringWithFormat:@"社区:%@\n\n",regeocode.addressComponent.township];
    NSString *neighborhood = [NSString stringWithFormat:@"楼:%@\n\n",regeocode.addressComponent.neighborhood];
    [self.stringM appendString:@"显示地理反编码后的信息如下所示：\n\n"];
    [self.stringM appendString:formattedAddress];
    [self.stringM appendString:province];
    [self.stringM appendString:city];
    [self.stringM appendString:citycode];
    [self.stringM appendString:district];
    [self.stringM appendString:adcode];
    [self.stringM appendString:township];
    [self.stringM appendString:neighborhood];
    _currentReGeocodeView.text = self.stringM;
}


@end
