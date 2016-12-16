//
//  AliMapViewGeocodeSearchController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//  地址编码查询

#import "AliMapViewGeocodeSearchController.h"

@interface AliMapViewGeocodeSearchController ()<AMapSearchDelegate>
@property (nonatomic, strong)AMapSearchAPI *POISearchManager;     //POI检索引擎
@property (strong, nonatomic)UILabel *currentAddressLabel;        //当前地址
@property (strong, nonatomic)UITextView *currentGeocodeView;      //当前地址编码后的信息
@property (strong, nonatomic)NSMutableString *stringM;            //存储编码信息
@end

@implementation AliMapViewGeocodeSearchController

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
    
    //创建地理编码请求
    AMapGeocodeSearchRequest *geoSearchRequest = [[AMapGeocodeSearchRequest alloc] init];
    geoSearchRequest.address = @"北京市朝阳区阜通东大街6号";
    
    //发起请求,开始POI的地理编码检索
    [_POISearchManager AMapGeocodeSearch:geoSearchRequest];
    [XYQProgressHUD showMessage:@"正在地理编码"];
}

//检索失败
-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}


//收集地理编码检索到的目标
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    [XYQProgressHUD hideHUD];
    if (response.geocodes.count == 0)  return;
    [XYQProgressHUD showSuccess:@"地理编码成功"];
    [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode * _Nonnull geo, NSUInteger idx, BOOL * _Nonnull stop) {
        [self showGeocodeInformation:geo];
    }];
}


//创建子控件
-(void)createSubViews{
    
    //当前地址
    _currentAddressLabel = [[UILabel alloc] init];
    _currentAddressLabel.textColor = [UIColor blackColor];
    _currentAddressLabel.text = @"当前地址：北京市朝阳区阜通东大街6号";
    _currentAddressLabel.textAlignment = 1;
    _currentAddressLabel.numberOfLines = 0;
    _currentAddressLabel.font = [UIFont systemFontOfSize:14];
    _currentAddressLabel.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.2];
    [_currentAddressLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH-4*Cell_Border, MAXFLOAT)];
    [self.view addSubview:_currentAddressLabel];
    [_currentAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-4*Cell_Border, 50));
        make.top.mas_equalTo(self.view).with.mas_offset(100);
        make.centerX.mas_equalTo(self.view);
    }];
    
    //当前地址编码后的信息
    _currentGeocodeView = [[UITextView alloc] init];
    _currentGeocodeView.textColor = [UIColor blackColor];
    _currentGeocodeView.textAlignment = 0;
    _currentGeocodeView.font = [UIFont systemFontOfSize:14];
    _currentGeocodeView.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.2];
    [self.view addSubview:_currentGeocodeView];
    [_currentGeocodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-4*Cell_Border, 400));
        make.topMargin.mas_equalTo(_currentAddressLabel).with.mas_offset(50);
        make.centerX.mas_equalTo(self.view);
    }];
}

//显示编码信息
-(void)showGeocodeInformation:(AMapGeocode * _Nonnull) geo{
    
    NSString *formattedAddress = [NSString stringWithFormat:@"格式化地址:%@\n\n",geo.formattedAddress];
    NSString *province = [NSString stringWithFormat:@"所在省/直辖市:%@\n\n",geo.province];
    NSString *city     = [NSString stringWithFormat:@"城市名:%@\n\n",geo.city];
    NSString *citycode = [NSString stringWithFormat:@"城市编码:%@\n\n",geo.citycode];
    NSString *district = [NSString stringWithFormat:@"区域名称:%@\n\n",geo.district];
    NSString *adcode   = [NSString stringWithFormat:@"乡镇街道:%@\n\n",geo.adcode];
    NSString *township = [NSString stringWithFormat:@"社区:%@\n\n",geo.township];
    NSString *neighborhood = [NSString stringWithFormat:@"楼:%@\n\n",geo.neighborhood];
    NSString *location = [NSString stringWithFormat:@"坐标点:%@\n",geo.location];
    [self.stringM appendString:@"显示地理编码后的信息如下所示：\n\n"];
    [self.stringM appendString:formattedAddress];
    [self.stringM appendString:province];
    [self.stringM appendString:city];
    [self.stringM appendString:citycode];
    [self.stringM appendString:district];
    [self.stringM appendString:adcode];
    [self.stringM appendString:township];
    [self.stringM appendString:neighborhood];
    [self.stringM appendString:location];
    _currentGeocodeView.text = self.stringM;
}

@end
