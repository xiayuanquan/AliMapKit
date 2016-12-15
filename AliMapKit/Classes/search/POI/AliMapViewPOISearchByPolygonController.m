//
//  AliMapViewPOIPoSearchBylygonController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//  多边形POI检索

#import "AliMapViewPOISearchByPolygonController.h"
#import "AliMapViewShopModel.h"
#import "AliMapViewShopCellFrame.h"
#import "AliMapViewShopCell.h"

@interface AliMapViewPOISearchByPolygonController ()<AMapSearchDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)AMapSearchAPI *POISearchManager;     //POI检索引擎
@property (nonatomic, strong)UITableView *tableView;              //表格
@property (nonatomic, strong)NSMutableArray *shopModelCellFrames; //所有的模型
@end

/**
 *  讲解一下cell、model、cellFrame的关系
 *
 *  每一个cellFrame拥有一个model模型，cellFrame中根据model内容给所有cell中的子控件布局，也即设置frame
 *  每一个cell再拥有一个cellFrame模型，cell中直接给所有的子控件设置frame，这些frame都是cellFrame中设置好的属性，
 *  同时，cell中也会设置子控件的内容，内容都是cellFrame中model的属性
 *
 */

@implementation AliMapViewPOISearchByPolygonController

//懒加载
-(NSMutableArray *)shopModelCellFrames{
    if (!_shopModelCellFrames) {
        _shopModelCellFrames = [NSMutableArray array];
    }
    return _shopModelCellFrames;
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
    
    //创建POI多边检索请求
    NSArray *points = [NSArray arrayWithObjects:
                       [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476],
                       [AMapGeoPoint locationWithLatitude:39.890459 longitude:116.581476],
                       nil];
    AMapGeoPolygon *polygon = [AMapGeoPolygon polygonWithPoints:points];
    AMapPOIPolygonSearchRequest *polygonRequest = [[AMapPOIPolygonSearchRequest alloc] init];
    polygonRequest.polygon             = polygon;
    polygonRequest.keywords            = @"Apple";
    polygonRequest.requireExtension    = YES;

    
    //发起请求,开始POI多边检索
    [_POISearchManager AMapPOIPolygonSearch:polygonRequest];
}

#pragma mark - AMapSearchDelegate
//检索失败
-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}

//收集检索到的目标(默认每一次给出一页数据,可以自己通过上拉刷新设置page的增加)
-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    
    if (response.pois.count == 0)  return;
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull poi, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AliMapViewShopCellFrame *cellFrame = [[AliMapViewShopCellFrame alloc] init];
        AliMapViewShopModel *shopModel = [[AliMapViewShopModel alloc] initWithAMapPOI:poi];
        cellFrame.shopModel = shopModel;
        [self.shopModelCellFrames addObject:cellFrame];
    }];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shopModelCellFrames.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AliMapViewShopCell *cell = [AliMapViewShopCell createCellWithTableView:tableView];
    if (self.shopModelCellFrames.count>0) {
        cell.shopCellFrame = self.shopModelCellFrames[indexPath.row];
    }
    return cell;
}


#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.shopModelCellFrames.count>0) {
        AliMapViewShopCellFrame *shopCellFrame = self.shopModelCellFrames[indexPath.row];
        return shopCellFrame.cellHeight;
    }
    return 100;
}

@end
