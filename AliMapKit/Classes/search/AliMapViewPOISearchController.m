//
//  AliMapViewPOISearchController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//  各种POI检索

#import "AliMapViewPOISearchController.h"
#import "AliMapViewPOISearchByKeywordController.h"
#import "AliMapViewPOISearchByAroundController.h"
#import "AliMapViewPOIPoSearchByPolygonController.h"

@interface AliMapViewPOISearchController ()
@property (strong,nonatomic)NSMutableArray *allPOIs;
@end

@implementation AliMapViewPOISearchController

-(NSMutableArray *)allPOIs{
    if (!_allPOIs) {
        _allPOIs = [NSMutableArray arrayWithObjects:
                       @"关键字检索POI",@"周边检索POI",@"多边检索POI",
                       @"ID检索POI",@"道路沿途检索POI",@"输入给出提示语",nil];
    }
    return _allPOIs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allPOIs.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuserIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.allPOIs[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //关键字检索POI
    if (indexPath.row==0) {
        AliMapViewPOISearchByKeywordController *POIByKeywordVC = [[AliMapViewPOISearchByKeywordController alloc] init];
        POIByKeywordVC.title = self.allPOIs[indexPath.row];
        [self.navigationController pushViewController:POIByKeywordVC animated:YES];
    }
    
    //周边检索POI
    if (indexPath.row==1) {
        AliMapViewPOISearchByAroundController *POIByAroundVC = [[AliMapViewPOISearchByAroundController alloc] init];
        POIByAroundVC.title = self.allPOIs[indexPath.row];
        [self.navigationController pushViewController:POIByAroundVC animated:YES];
    }
    
    //多边形检索POI
    if (indexPath.row==2) {
        AliMapViewPOIPoSearchByPolygonController *POIByPolygonVC = [[AliMapViewPOIPoSearchByPolygonController alloc] init];
        POIByPolygonVC.title = self.allPOIs[indexPath.row];
        [self.navigationController pushViewController:POIByPolygonVC animated:YES];
    }
}


@end
