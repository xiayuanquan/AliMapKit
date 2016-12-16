//
//  AliMapViewSearchByInputTipsController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//  根据输入给出提示语，可以配合模糊查询，根据一个词列出所有相关的事物

#import "AliMapViewSearchByInputTipsController.h"
#import "AliMapViewPOISearchByIDController.h"
#import "AliMapViewShopModel.h"
#import "AliMapViewShopCellFrame.h"
#import "AliMapViewShopCell.h"

@interface AliMapViewSearchByInputTipsController ()<AMapSearchDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)AMapSearchAPI *POISearchManager;     //POI检索引擎
@property (nonatomic, strong)UITableView *tableView;              //表格
@property (nonatomic, strong)NSMutableArray *shopModels;          //所有的模型
@end

@implementation AliMapViewSearchByInputTipsController

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
    
    //创建输入提示请求
    AMapInputTipsSearchRequest *tipsRequest = [[AMapInputTipsSearchRequest alloc] init];
    tipsRequest.keywords = @"吃饭";//通过“吃饭”可以提示出所有的饭店或者酒店等
    tipsRequest.city     = @"北京";
    tipsRequest.cityLimit = YES; //是否限制城市
    
    //发起请求,开始POI的ID检索
    [_POISearchManager AMapInputTipsSearch:tipsRequest];
    [XYQProgressHUD showMessage:@"正在检索"];
}

#pragma mark - AMapSearchDelegate
//检索失败
-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}


//收集检索到的目标
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response{
    
    [XYQProgressHUD hideHUD];
    if(response.tips.count == 0)  return;
    [XYQProgressHUD showSuccess:@"检索成功"];
    [response.tips enumerateObjectsUsingBlock:^(AMapTip * _Nonnull poi, NSUInteger idx, BOOL * _Nonnull stop) {
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    AMapTip *tipPOI = self.shopModels[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = [NSString stringWithFormat:@"输入提示名称：%@",[tipPOI name]];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"输入提示名称的uid：%@",[tipPOI uid]];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AliMapViewPOISearchByIDController *POIByIDVC = [[AliMapViewPOISearchByIDController alloc] init];
    AMapTip *tipPOI = self.shopModels[indexPath.row];
    POIByIDVC.title = [tipPOI name];
    POIByIDVC.uid = [tipPOI uid];
    [self.navigationController pushViewController:POIByIDVC animated:YES];
}

@end
