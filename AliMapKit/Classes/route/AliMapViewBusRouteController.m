//
//  AliMapViewBusRouteController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//  公交出行路线规划

#import "AliMapViewBusRouteController.h"

@interface AliMapViewBusRouteController ()<AMapSearchDelegate>{
    UILabel *_startLabel;       //出发点
    UILabel *_deastinationLabel;//目的地
    UITextView *_routeContent;  //路线规划内容
}
@property (nonatomic, strong)AMapSearchAPI *POISearchManager; //POI检索引擎
@property (nonatomic, strong)NSMutableString *routeM;         //路线规划内容
@end

@implementation AliMapViewBusRouteController

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
    
    //创建公交出行路线查询请求
    CLLocationCoordinate2D startCoordinate; //天通苑
    startCoordinate.longitude = 116.4127590000;
    startCoordinate.latitude  = 40.0752220000;
    CLLocationCoordinate2D destiCoordinate; //苏州街
    destiCoordinate.longitude = 116.3058432554;
    destiCoordinate.latitude  = 39.9795355317;
    
    AMapTransitRouteSearchRequest *busRouteRequest = [[AMapTransitRouteSearchRequest alloc] init];
    busRouteRequest.city   = @"北京";
    busRouteRequest.nightflag = YES;
    busRouteRequest.origin = [AMapGeoPoint locationWithLatitude:startCoordinate.latitude
                                                       longitude:startCoordinate.longitude];
    busRouteRequest.destination = [AMapGeoPoint locationWithLatitude:destiCoordinate.latitude
                                                            longitude:destiCoordinate.longitude];
    
    
    //发起请求,开始POI的公交出行路线查询检索
    [_POISearchManager AMapTransitRouteSearch:busRouteRequest];
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
    [response.route.transits enumerateObjectsUsingBlock:^(AMapTransit * _Nonnull transitObj, NSUInteger idx, BOOL * _Nonnull stop) {

        [self.routeM appendFormat:@"方案%@：\n",[self returnChineseName:idx+1]];
        [self.routeM appendFormat:@"此公交方案价格:%.1lf元\n",transitObj.cost];
        [self.routeM appendFormat:@"此换乘方案预期时间:%.1lf分钟\n",(float)transitObj.duration/60];
        [self.routeM appendFormat:@"是否是夜班车:%@\n",transitObj.nightflag==1?@"是":@"不是"];
        [self.routeM appendFormat:@"此方案总步行距离:%ld米\n",transitObj.walkingDistance];
        [self.routeM appendFormat:@"当前方案的总距离:%.1lf千米\n",(float)transitObj.distance/1000];
        
        [transitObj.segments enumerateObjectsUsingBlock:^(AMapSegment * _Nonnull segmentObj, NSUInteger index, BOOL * _Nonnull stop) {
            if(index==0)[self.routeM appendFormat:@"换乘次数为%ld次：\n\n",transitObj.segments.count-1];
            [segmentObj.buslines enumerateObjectsUsingBlock:^(AMapBusLine * _Nonnull busLineObj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if(segmentObj.buslines.count>0)[self.routeM appendFormat:@"第%ld次乘车：\n",index+1];
                NSString *name = [[[[busLineObj.name componentsSeparatedByString:@"("] lastObject] componentsSeparatedByString:@")"] firstObject];
                [self.routeM appendFormat:@"公交类型:%@\n",busLineObj.type];
                [self.routeM appendFormat:@"公交线路名称:%@\n",busLineObj.name];
                [self.routeM appendFormat:@"首发站:%@\n",[[name componentsSeparatedByString:@"--"] firstObject]];
                [self.routeM appendFormat:@"终点站:%@\n\n",[[name componentsSeparatedByString:@"--"] lastObject]];
            }];
        }];
        
        //显示公交路线内容
        _routeContent.text = self.routeM;
    }];
}

//创建子控件
-(void)createAllSubViews{
    
    //出发点
    _startLabel = [[UILabel alloc] init];
    _startLabel.textAlignment = 1;
    _startLabel.text = @"出发地：天通苑";
    [self.view addSubview:_startLabel];
    [_startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, 60));
        make.left.mas_equalTo(self.view).with.offset(0);
        make.top.mas_equalTo(self.view).with.offset(64);
    }];
    
    //目的地
    _deastinationLabel = [[UILabel alloc] init];
    _deastinationLabel.textAlignment = 1;
    _deastinationLabel.text = @"目的地：苏州街";
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

-(NSString *)returnChineseName:(NSInteger)idx{
    NSArray *chineseNames = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十"];
    return chineseNames[idx-1];
}

@end
