//
//  AliMapViewPositionController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//  定位

#import "AliMapViewPositionController.h"
#import "AliMapViewSinglePositionController.h"
#import "AliMapViewBackgroundPositionController.h"
#import "AliMapViewContinuePositionController.h"
#import "AliMapViewMonitoringRegionController.h"
#import "AliMapViewLocationDataAvailableController.h"

@interface AliMapViewPositionController ()
@property (strong,nonatomic)NSMutableArray *allPositions;
@end

@implementation AliMapViewPositionController

-(NSMutableArray *)allPositions{
    if (!_allPositions) {
        _allPositions = [NSMutableArray arrayWithObjects:@"单次定位",@"后台定位",@"持续定位",@"地理围栏",@"位置区域判断",nil];
    }
    return _allPositions;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allPositions.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuserIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.allPositions[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //单次定位
    if (indexPath.row==0) {
        AliMapViewSinglePositionController *singlePositionVC = [[AliMapViewSinglePositionController alloc] init];
        singlePositionVC.title = self.allPositions[indexPath.row];
        [self.navigationController pushViewController:singlePositionVC animated:YES];
    }
    
    //后台定位
    if (indexPath.row==1) {
        AliMapViewBackgroundPositionController *backgroundPositionVC = [[AliMapViewBackgroundPositionController alloc] init];
        backgroundPositionVC.title = self.allPositions[indexPath.row];
        [self.navigationController pushViewController:backgroundPositionVC animated:YES];
    }
    
    //持续定位
    if (indexPath.row==2) {
        AliMapViewContinuePositionController *continuePositionVC = [[AliMapViewContinuePositionController alloc] init];
        continuePositionVC.title = self.allPositions[indexPath.row];
        [self.navigationController pushViewController:continuePositionVC animated:YES];
    }
    
    //地理围栏
    if (indexPath.row==3) {
        AliMapViewMonitoringRegionController *monitoringRegionVC = [[AliMapViewMonitoringRegionController alloc] init];
        monitoringRegionVC.title = self.allPositions[indexPath.row];
        [self.navigationController pushViewController:monitoringRegionVC animated:YES];
    }
    
    //地理围栏
    if (indexPath.row==4) {
        AliMapViewLocationDataAvailableController *availableVC = [[AliMapViewLocationDataAvailableController alloc] init];
        availableVC.title = self.allPositions[indexPath.row];
        [self.navigationController pushViewController:availableVC animated:YES];
    }
}

@end
