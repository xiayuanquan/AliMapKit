//
//  AliMapViewCarRouteController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//  驾车出行路线规划

#import "AliMapViewCarRouteController.h"

@interface AliMapViewCarRouteController ()<AMapSearchDelegate>{
    UILabel *_startLabel;       //出发点
    UILabel *_deastinationLabel;//目的地
    UITextView *_routeContent;  //路线规划内容
}
@property (nonatomic, strong)AMapSearchAPI *POISearchManager; //POI检索引擎
@property (nonatomic, strong)NSMutableString *routeM;         //路线规划内容
@end

@implementation AliMapViewCarRouteController

//懒加载
-(NSMutableString *)routeM{
    if (!_routeM) {
        _routeM = [NSMutableString string];
    }
    return _routeM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建所有的子控件
    [self createAllSubViews];
    
    //创建POI检索引擎
    _POISearchManager = [[AMapSearchAPI alloc] init];
    _POISearchManager.delegate = self;
    
    //创建驾车出行路线查询请求
    CLLocationCoordinate2D startCoordinate; //昌平区
    startCoordinate.longitude = 116.23;
    startCoordinate.latitude  = 40.22;
    CLLocationCoordinate2D destiCoordinate; //丰台区
    destiCoordinate.longitude = 116.28;
    destiCoordinate.latitude  = 39.85;
    AMapDrivingRouteSearchRequest *carRouteRequest = [[AMapDrivingRouteSearchRequest alloc] init];
    carRouteRequest.requireExtension = YES;
    carRouteRequest.strategy = 5;
    carRouteRequest.origin = [AMapGeoPoint locationWithLatitude:startCoordinate.latitude
                                           longitude:startCoordinate.longitude];
    carRouteRequest.destination = [AMapGeoPoint locationWithLatitude:destiCoordinate.latitude
                                                longitude:destiCoordinate.longitude];
    
    
    //发起请求,开始POI的驾车出行路线查询检索
    [_POISearchManager AMapDrivingRouteSearch:carRouteRequest];
    [XYQProgressHUD showMessage:@"正在查询"];
}

#pragma mark - <AMapSearchDelegate>
//检索失败
-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}

//收集检索到的路线出行规划目标
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response{
    
   [XYQProgressHUD hideHUD];
   [XYQProgressHUD showSuccess:@"查询成功"];
   [response.route.paths enumerateObjectsUsingBlock:^(AMapPath * _Nonnull pathObj, NSUInteger idx, BOOL * _Nonnull stop) {
       [self.routeM appendFormat:@"起点和终点的距离：%.2lf千米\n",(float)pathObj.distance/1000];
       [self.routeM appendFormat:@"预计耗时：%ld小时\n",pathObj.duration/60/60];
       [self.routeM appendFormat:@"此方案费用：%.2lf元\n",pathObj.tolls];
       [self.routeM appendFormat:@"此方案收费路段长度：%.2lf千米\n",(float)pathObj.tollDistance/1000];
       [self.routeM appendFormat:@"此方案交通信号灯个数：%ld个\n\n\n",pathObj.totalTrafficLights];
       
       [pathObj.steps enumerateObjectsUsingBlock:^(AMapStep * _Nonnull stepObj, NSUInteger idx, BOOL * _Nonnull stop) {
           
           [self.routeM appendFormat:@"出行第%ld步:\n",idx+1];
           [self.routeM appendFormat:@"行走指示：%@\n",stepObj.instruction];
           [self.routeM appendFormat:@"方向：%@\n",stepObj.orientation];
           [self.routeM appendFormat:@"道路名称：%@\n",stepObj.road];
           [self.routeM appendFormat:@"此路段长度：%ld米\n",stepObj.distance];
           [self.routeM appendFormat:@"此路段预计耗时：%ld分钟\n",stepObj.duration/60];
           if(idx<pathObj.steps.count-1)[self.routeM appendFormat:@"导航主要动作：%@\n\n\n",stepObj.action];
       }];
       
       //显示路线规划内容
       _routeContent.text = self.routeM;
   }];
}

//创建子控件
-(void)createAllSubViews{
    
   //出发点
    _startLabel = [[UILabel alloc] init];
    _startLabel.textAlignment = 1;
    _startLabel.text = @"出发地：昌平区";
    [self.view addSubview:_startLabel];
    [_startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, 60));
        make.left.mas_equalTo(self.view).with.offset(0);
        make.top.mas_equalTo(self.view).with.offset(64);
    }];
    
   //目的地
    _deastinationLabel = [[UILabel alloc] init];
    _deastinationLabel.textAlignment = 1;
    _deastinationLabel.text = @"目的地：丰台区";
    [self.view addSubview:_deastinationLabel];
    [_deastinationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, 60));
        make.left.mas_equalTo(_startLabel).with.offset(SCREEN_WIDTH/2);
        make.top.mas_equalTo(self.view).with.offset(64);
    }];
    
    //添加连接线
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-30,91,60,3)];
    line.backgroundColor = [UIColor blackColor];
    [self.view addSubview:line];
    
   //路线规划内容
    _routeContent = [[UITextView alloc] init];
    _routeContent.textAlignment = 0;
    _routeContent.editable = NO;
    _routeContent.font = [UIFont systemFontOfSize:16];
    [_routeContent sizeThatFits:CGSizeMake(SCREEN_WIDTH-2*Cell_Border, MAXFLOAT)];
    _routeContent.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.3];
    [self.view addSubview:_routeContent];
    [_routeContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-2*Cell_Border, SCREEN_HEGHT-64-120));
        make.top.mas_equalTo(_deastinationLabel).with.offset(60);
        make.centerX.mas_equalTo(self.view);
    }];
}

@end
