//
//  AliMapViewBusRouteSearchController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//  公交查询（公交线路）

#import "AliMapViewBusRouteSearchController.h"

@interface AliMapViewBusRouteSearchController ()<AMapSearchDelegate>
@property (nonatomic, strong)AMapSearchAPI *POISearchManager;     //POI检索引擎
@property (nonatomic, strong)NSMutableArray *busLines;            //所有的公交线路
@property (nonatomic, strong)UISegmentedControl *segementControl; //分段控件
@end

@implementation AliMapViewBusRouteSearchController

-(NSMutableArray *)busLines{
    if (!_busLines) {
        _busLines = [NSMutableArray array];
    }
    return _busLines;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationBar];
    
    //创建POI检索引擎
    _POISearchManager = [[AMapSearchAPI alloc] init];
    _POISearchManager.delegate = self;
    [self sendRequestForBusLineName];
}

//设置导航栏
-(void)setupNavigationBar{
    _segementControl = [[UISegmentedControl alloc]initWithItems:@[@"公交站线路根据名字请求",@"公交站线路根据ID请求"]];
    _segementControl.frame = CGRectMake(0, 0, 250, 40);
    [_segementControl addTarget:self action:@selector(segementControlValueChange:) forControlEvents:UIControlEventValueChanged];
    _segementControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = _segementControl;
}

//切换公交站线路的请求方式
-(void)segementControlValueChange:(UISegmentedControl *)control{
 
    if (control.selectedSegmentIndex == 0) {
        [self sendRequestForBusLineName];
    }
    if (control.selectedSegmentIndex == 1) {
        [self sendRequestForBusLineID];
    }
}

//公交站线路根据名字请求
-(void)sendRequestForBusLineName{
    
    //先取消之前所有的请求
    [_POISearchManager cancelAllRequests];
    [self.busLines removeAllObjects];
    [self.tableView reloadData];
    
    //创建公交线路查询请求
    AMapBusLineNameSearchRequest *busLineNameSearchRequest = [[AMapBusLineNameSearchRequest alloc] init];
    busLineNameSearchRequest.keywords           =  @"1";//与"1"有关的所有公交线路
    busLineNameSearchRequest.city               =  @"beijing";
    busLineNameSearchRequest.requireExtension   =  YES;
    
    //发起请求,开始POI的公交线路检索
    [_POISearchManager AMapBusLineNameSearch:busLineNameSearchRequest];
}


//公交站线路根据ID请求
-(void)sendRequestForBusLineID{
    
    //先取消之前所有的请求
    [_POISearchManager cancelAllRequests];
    [self.busLines removeAllObjects];
    [self.tableView reloadData];
    
    //创建公交线路查询请求
    AMapBusLineIDSearchRequest *busLineIDSearchRequest = [[AMapBusLineIDSearchRequest alloc] init];
    busLineIDSearchRequest.uid      = @"110100023111";  //uid为"110100023111"的具体某一条公交线路
    busLineIDSearchRequest.city     = @"北京";
    busLineIDSearchRequest.requireExtension   = YES;
    
    //发起请求,开始POI的公交线路检索
    [_POISearchManager AMapBusLineIDSearch:busLineIDSearchRequest];
}


#pragma mark - <AMapSearchDelegate>
//检索失败
-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}


//收集检索到的公交线路目标
- (void)onBusLineSearchDone:(AMapBusLineBaseSearchRequest *)request response:(AMapBusLineSearchResponse *)response{
    
    if (response.count==0) return;
    
    [response.buslines enumerateObjectsUsingBlock:^(AMapBusLine * _Nonnull busLine, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.busLines addObject:busLine];
    }];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.busLines.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuserIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentifier];
    }
    if (self.busLines.count>0) {
        AMapBusLine *busLine = self.busLines[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.text = [NSString stringWithFormat:@"公交线路名称：%@",[busLine name]];
    }
    return cell;
}

@end
