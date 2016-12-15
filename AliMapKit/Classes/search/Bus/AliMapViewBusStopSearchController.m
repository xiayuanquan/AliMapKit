//
//  AliMapViewBusStationSearchController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//  公交查询（公交站点）

#import "AliMapViewBusStopSearchController.h"

@interface AliMapViewBusStopSearchController ()<AMapSearchDelegate>
@property (nonatomic, strong)AMapSearchAPI *POISearchManager;     //POI检索引擎
@property (nonatomic, strong)NSMutableArray *busstops;            //所有的公交站点
@end

@implementation AliMapViewBusStopSearchController

-(NSMutableArray *)busstops{
    if (!_busstops) {
        _busstops = [NSMutableArray array];
    }
    return _busstops;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    //创建POI检索引擎
    _POISearchManager = [[AMapSearchAPI alloc] init];
    _POISearchManager.delegate = self;
    
    //创建公交站点查询请求
    AMapBusStopSearchRequest *stopSearchRequest = [[AMapBusStopSearchRequest alloc] init];
    stopSearchRequest.keywords = @"天通苑";
    stopSearchRequest.city     = @"北京";
    
    //发起请求,开始POI的公交站点检索
    [_POISearchManager AMapBusStopSearch:stopSearchRequest];
}

#pragma mark - <AMapSearchDelegate>

//检索失败
-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}


//收集检索到的公交站点目标
- (void)onBusStopSearchDone:(AMapBusStopSearchRequest *)request response:(AMapBusStopSearchResponse *)response{
    if (response.count==0) return;
    
    [response.busstops enumerateObjectsUsingBlock:^(AMapBusStop * _Nonnull busStop, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.busstops addObject:busStop];
    }];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.busstops.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuserIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentifier];
    }
    AMapBusStop *busStop = self.busstops[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = [NSString stringWithFormat:@"公交站点名称：%@",[busStop name]];
    return cell;
}


@end
