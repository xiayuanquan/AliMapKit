//
//  AliMapViewPOISearchByRouteController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//  道路沿途进行POI检索

#import "AliMapViewPOISearchByRouteController.h"
#import "AliMapViewPOISearchByIDController.h"

@interface AliMapViewPOISearchByRouteController ()<AMapSearchDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)AMapSearchAPI  *POISearchManager;     //POI检索引擎
@property (nonatomic, strong)UITableView    *tableView;            //表格
@property (nonatomic, strong)NSMutableArray *shopModels;           //所有的模型
@end

@implementation AliMapViewPOISearchByRouteController

//懒加载
-(NSMutableArray *)shopModels{
    if (!_shopModels) {
        _shopModels = [NSMutableArray array];
    }
    return _shopModels;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:245/255 green:245/255 blue:245/255 alpha:1.0];
    
    //创建tableView
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:0];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    //创建POI检索引擎
    _POISearchManager = [[AMapSearchAPI alloc] init];
    _POISearchManager.delegate = self;
    
    //创建道路沿途的POI检索请求
    AMapRoutePOISearchRequest *RouteRequest = [[AMapRoutePOISearchRequest alloc] init];
    //起始位置（昌平区：40.22 116.23）
    RouteRequest.origin = [AMapGeoPoint locationWithLatitude:40.22 longitude:116.23];
    //终点位置（丰台区：39.85 116.28）
    RouteRequest.destination = [AMapGeoPoint locationWithLatitude:39.85 longitude:116.28];
    //导航策略
    RouteRequest.strategy = AMapDrivingStrategyShortest;
    //搜索类型(这里我设置为加油站)
    RouteRequest.searchType = AMapRoutePOISearchTypeGasStation;
    
    //发起请求,开始POI道路沿途检索
    [_POISearchManager AMapRoutePOISearch:RouteRequest];
}

#pragma mark - AMapSearchDelegate
//检索失败
-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}


//收集检索到的目标(默认每一次给出一页数据,可以自己通过上拉刷新设置page的增加)
- (void)onRoutePOISearchDone:(AMapRoutePOISearchRequest *)request response:(AMapRoutePOISearchResponse *)response{
    
    if (response.pois.count == 0)  return;
    [response.pois enumerateObjectsUsingBlock:^(AMapRoutePOI * _Nonnull poi, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.shopModels addObject:poi];
    }];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shopModels.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuserIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuserIdentifier];
    }
    AMapRoutePOI *routePOI = self.shopModels[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = [NSString stringWithFormat:@"沿途加油站名称：%@",[routePOI name]];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"加油站的uid：%@",[routePOI uid]];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AliMapViewPOISearchByIDController *POIByIDVC = [[AliMapViewPOISearchByIDController alloc] init];
    AMapRoutePOI *routePOI = self.shopModels[indexPath.row];
    POIByIDVC.title = [routePOI name];
    POIByIDVC.uid = [routePOI uid];
    [self.navigationController pushViewController:POIByIDVC animated:YES];
}

     
@end
