//
//  ViewController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import "AliMapRootViewController.h"
#import "AliMapViewShowController.h"
#import "AliMapViewDrawController.h"
#import "AliMapViewPositionController.h"
#import "AliMapViewSearchController.h"
#import "AliMapViewRouteController.h"
#import "AliMapViewNavController.h"

@interface AliMapRootViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)NSMutableArray *allFunctions;//全部功能
@property (strong,nonatomic)UITableView *tableView;
@end

@implementation AliMapRootViewController

-(NSMutableArray *)allFunctions{
    if (!_allFunctions) {
        _allFunctions = [NSMutableArray arrayWithObjects:@"地图显示",@"地图绘制",@"地图定位",@"数据检索",@"路线规划",@"汽车导航", nil];
    }
    return _allFunctions;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEGHT-64)];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allFunctions.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuserIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.allFunctions[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //地图显示
    if (indexPath.row==0) {
        AliMapViewShowController *mapViewShowVC = [[AliMapViewShowController alloc] init];
        mapViewShowVC.title = self.allFunctions[indexPath.row];
        [self.navigationController pushViewController:mapViewShowVC animated:YES];
    }
    
    //地图绘制
    if (indexPath.row==1) {
        AliMapViewDrawController *mapViewDrawVC = [[AliMapViewDrawController alloc] init];
        mapViewDrawVC.title = self.allFunctions[indexPath.row];
        [self.navigationController pushViewController:mapViewDrawVC animated:YES];
    }
    
    //地图定位
    if (indexPath.row==2) {
        AliMapViewPositionController *mapViewPositionVC = [[AliMapViewPositionController alloc] init];
        mapViewPositionVC.title = self.allFunctions[indexPath.row];
        [self.navigationController pushViewController:mapViewPositionVC animated:YES];
    }
    
    //数据检索
    if (indexPath.row==3) {
        AliMapViewSearchController *mapViewPOIVC = [[AliMapViewSearchController alloc] init];
        mapViewPOIVC.title = self.allFunctions[indexPath.row];
        [self.navigationController pushViewController:mapViewPOIVC animated:YES];
    }
    
    //驾车路线规划
    if (indexPath.row==4) {
        AliMapViewRouteController *mapViewRouteVC = [[AliMapViewRouteController alloc] init];
        mapViewRouteVC.title = self.allFunctions[indexPath.row];
        [self.navigationController pushViewController:mapViewRouteVC animated:YES];
    }
    
    //导航
    if (indexPath.row==5) {
        AliMapViewNavController *mapViewNavVC = [[AliMapViewNavController alloc] init];
        mapViewNavVC.title = self.allFunctions[indexPath.row];
        [self.navigationController pushViewController:mapViewNavVC animated:YES];
    }
}

@end
