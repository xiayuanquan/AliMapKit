//
//  AliMapViewSearchController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//  数据检索

#import "AliMapViewSearchController.h"
#import "AliMapViewPOISearchController.h"
#import "AliMapViewAddressSearchController.h"
#import "AliMapViewBusSearchController.h"

@interface AliMapViewSearchController ()
@property (strong,nonatomic)NSMutableArray *allSearchs;
@end

@implementation AliMapViewSearchController

-(NSMutableArray *)allSearchs{
    if (!_allSearchs) {
        _allSearchs = [NSMutableArray arrayWithObjects:
                       @"获取POI数据",@"获取地址描述数据",@"获取公交数据",
                       @"获取行政区划分数据",@"获取天气数据",@"获取自有数据",nil];
    }
    return _allSearchs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allSearchs.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuserIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.allSearchs[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取POI数据
    if (indexPath.row==0) {
        AliMapViewPOISearchController *POISearchVC = [[AliMapViewPOISearchController alloc] init];
        POISearchVC.title = self.allSearchs[indexPath.row];
        [self.navigationController pushViewController:POISearchVC animated:YES];
    }
    
    //获取地址描述数据
    if (indexPath.row==1) {
        AliMapViewAddressSearchController *AddressSearchVC = [[AliMapViewAddressSearchController alloc] init];
        AddressSearchVC.title = self.allSearchs[indexPath.row];
        [self.navigationController pushViewController:AddressSearchVC animated:YES];
    }
    
    //获取公交数据
    if (indexPath.row==2) {
        AliMapViewBusSearchController *busSearchVC = [[AliMapViewBusSearchController alloc] init];
        busSearchVC.title = self.allSearchs[indexPath.row];
        [self.navigationController pushViewController:busSearchVC animated:YES];
    }
}


@end
