//
//  AliMapViewAddressSearchController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//  地址编码和反编码查询

#import "AliMapViewAddressSearchController.h"
#import "AliMapViewGeocodeSearchController.h"
#import "AliMapViewReGeocodeSearchController.h"

@interface AliMapViewAddressSearchController ()
@property (strong,nonatomic)NSMutableArray *addressStyles;
@end

@implementation AliMapViewAddressSearchController

-(NSMutableArray *)addressStyles{
    if (!_addressStyles) {
        _addressStyles = [NSMutableArray arrayWithObjects:@"地理编码查询(地址转坐标)",@"地理反编码查询(坐标转地址)",nil];
    }
    return _addressStyles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressStyles.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuserIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.addressStyles[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //地理编码查询(地址转坐标)
    if (indexPath.row==0) {
        AliMapViewGeocodeSearchController *geocodeVC = [[AliMapViewGeocodeSearchController alloc] init];
        geocodeVC.title = self.addressStyles[indexPath.row];
        [self.navigationController pushViewController:geocodeVC animated:YES];
    }
    
    //地理反编码查询(坐标转地址)
    if (indexPath.row==1) {
        AliMapViewReGeocodeSearchController *regeocodeVC = [[AliMapViewReGeocodeSearchController alloc] init];
        regeocodeVC.title = self.addressStyles[indexPath.row];
        [self.navigationController pushViewController:regeocodeVC animated:YES];
    }
}



@end
