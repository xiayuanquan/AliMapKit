//
//  AliMapViewDrawSurfaceController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved
//

#import "AliMapViewDrawSurfaceController.h"
#import "AliMapViewDrawSurfaceCircleController.h"
#import "AliMapViewDrawSurfaceHeatController.h"
#import "AliMapViewDrawSurfaceOverlayController.h"
#import "AliMapViewDrawSurfaceCustomlayController.h"

@interface AliMapViewDrawSurfaceController ()
@property (strong,nonatomic)NSMutableArray *drawSurfaces;
@end

@implementation AliMapViewDrawSurfaceController

-(NSMutableArray *)drawSurfaces{
    if (!_drawSurfaces) {
        _drawSurfaces = [NSMutableArray arrayWithObjects:@"绘制圆",@"绘制热力图",@"绘制overlay图层",@"绘制自定义图层",nil];
    }
    return _drawSurfaces;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.drawSurfaces.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuserIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.drawSurfaces[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //绘制圆
    if (indexPath.row==0) {
        AliMapViewDrawSurfaceCircleController *drawSurfaceCircleVC = [[AliMapViewDrawSurfaceCircleController alloc] init];
        drawSurfaceCircleVC.title = self.drawSurfaces[indexPath.row];
        [self.navigationController pushViewController:drawSurfaceCircleVC animated:YES];
    }

    //绘制热力图
    if (indexPath.row==1) {
        AliMapViewDrawSurfaceHeatController *drawSurfaceHeatVC = [[AliMapViewDrawSurfaceHeatController alloc] init];
        drawSurfaceHeatVC.title = self.drawSurfaces[indexPath.row];
        [self.navigationController pushViewController:drawSurfaceHeatVC animated:YES];
    }

    //绘制overlay图层
    if (indexPath.row==2) {
        AliMapViewDrawSurfaceOverlayController *drawSurfaceOverLayVC = [[AliMapViewDrawSurfaceOverlayController alloc] init];
        drawSurfaceOverLayVC.title = self.drawSurfaces[indexPath.row];
        [self.navigationController pushViewController:drawSurfaceOverLayVC animated:YES];
    }
    
    //绘制自定义图层
    if (indexPath.row==3) {
        AliMapViewDrawSurfaceCustomlayController *drawSurfaceCustomVC = [[AliMapViewDrawSurfaceCustomlayController alloc] init];
        drawSurfaceCustomVC.title = self.drawSurfaces[indexPath.row];
        [self.navigationController pushViewController:drawSurfaceCustomVC animated:YES];
    }
}

@end
