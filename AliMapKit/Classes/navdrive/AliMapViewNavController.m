//
//  AliMapViewNavController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//  用系统的导航

#import "AliMapViewNavController.h"
#import "AliMapViewSystemNaviDriveController.h"
#import "AliMapViewCustomNavDeriveController.h"

@interface AliMapViewNavController ()
@property (strong,nonatomic)NSMutableArray *navStyles;//所有的导航方式
@end

@implementation AliMapViewNavController

-(NSMutableArray *)navStyles{
    if (!_navStyles) {
        _navStyles = [NSMutableArray arrayWithObjects:@"采用系统的导航界面(实时和模拟)",@"自定义导航界面的定制",nil];
    }
    return _navStyles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.navStyles.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuserIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.navStyles[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //采用系统的导航界面(实时和模拟)
    if (indexPath.row==0) {
        AliMapViewSystemNaviDriveController *systemNaviDriveVC = [[AliMapViewSystemNaviDriveController alloc] init];
        systemNaviDriveVC.title = self.navStyles[indexPath.row];
        [self.navigationController pushViewController:systemNaviDriveVC animated:YES];
    }
    
    //自定义导航界面的定制
    if (indexPath.row==1) {
        AliMapViewCustomNavDeriveController *CustomNavDeriveVC = [[AliMapViewCustomNavDeriveController alloc] init];
        CustomNavDeriveVC.title = self.navStyles[indexPath.row];
        [self.navigationController pushViewController:CustomNavDeriveVC animated:YES];
    }
 
}


@end
