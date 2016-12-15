//
//  AliMapViewBusSearchController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//  公交查询（公交站点、公交线路）


#import "AliMapViewBusSearchController.h"
#import "AliMapViewBusStopSearchController.h"
#import "AliMapViewBusRouteSearchController.h"

@interface AliMapViewBusSearchController ()
@property (strong,nonatomic)NSMutableArray *buses;
@end

@implementation AliMapViewBusSearchController

-(NSMutableArray *)buses{
    if (!_buses) {
        _buses = [NSMutableArray arrayWithObjects:@"公交站点查询",@"公交线路查询",nil];
    }
    return _buses;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.buses.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuserIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.buses[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //公交站点查询
    if (indexPath.row==0) {
        AliMapViewBusStopSearchController *busStopVC = [[AliMapViewBusStopSearchController alloc] init];
        busStopVC.title = self.buses[indexPath.row];
        [self.navigationController pushViewController:busStopVC animated:YES];
    }
    
    //公交线路查询
    if (indexPath.row==1) {
        AliMapViewBusRouteSearchController *busRouteVC = [[AliMapViewBusRouteSearchController alloc] init];
        busRouteVC.title = self.buses[indexPath.row];
        [self.navigationController pushViewController:busRouteVC animated:YES];
    }
}


@end
