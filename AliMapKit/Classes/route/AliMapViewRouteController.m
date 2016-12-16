//
//  AliMapViewRouteController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//  出行路线规划

#import "AliMapViewRouteController.h"
#import "AliMapViewCarRouteController.h"
#import "AliMapViewWalkRouteController.h"
#import "AliMapViewBusRouteController.h"
#import "AliMapViewBikeRouteController.h"

@interface AliMapViewRouteController ()
@property (strong,nonatomic)NSMutableArray *allRoutes;
@end

@implementation AliMapViewRouteController

-(NSMutableArray *)allRoutes{
    if (!_allRoutes) {
        _allRoutes = [NSMutableArray arrayWithObjects:
                       @"驾车出行路线规划",@"步行出行路线规划",@"公交出行路线规划",
                       @"骑行出行路线规划",nil];
    }
    return _allRoutes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allRoutes.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuserIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.allRoutes[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //驾车出行路线规划
    if (indexPath.row==0) {
        AliMapViewCarRouteController *carRouteVC = [[AliMapViewCarRouteController alloc] init];
        carRouteVC.title = self.allRoutes[indexPath.row];
        [self.navigationController pushViewController:carRouteVC animated:YES];
    }
    
    //步行出行路线规划
    if (indexPath.row==1) {
        AliMapViewWalkRouteController *walkRouteVC = [[AliMapViewWalkRouteController alloc] init];
        walkRouteVC.title = self.allRoutes[indexPath.row];
        [self.navigationController pushViewController:walkRouteVC animated:YES];
    }
    
    //公交出行路线规划
    if (indexPath.row==2) {
        AliMapViewBusRouteController *busRouteVC = [[AliMapViewBusRouteController alloc] init];
        busRouteVC.title = self.allRoutes[indexPath.row];
        [self.navigationController pushViewController:busRouteVC animated:YES];
    }
    
    //骑行路线规划
    if (indexPath.row==3) {
        AliMapViewBikeRouteController *bikeRouteVC = [[AliMapViewBikeRouteController alloc] init];
        bikeRouteVC.title = self.allRoutes[indexPath.row];
        [self.navigationController pushViewController:bikeRouteVC animated:YES];
    }
    
}



@end
