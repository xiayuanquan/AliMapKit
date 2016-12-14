//
//  AliMapViewDrawController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import "AliMapViewDrawController.h"
#import "AliMapViewDrawPinController.h"
#import "AliMapViewDrawPolylineController.h"
#import "AliMapViewDrawSurfaceController.h"

@interface AliMapViewDrawController ()
@property (strong,nonatomic)NSMutableArray *drawMarks;
@end

@implementation AliMapViewDrawController

-(NSMutableArray *)drawMarks{
    if (!_drawMarks) {
        _drawMarks = [NSMutableArray arrayWithObjects:@"绘制点标记",@"绘制折线",@"绘制面",nil];
    }
    return _drawMarks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.drawMarks.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuserIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.drawMarks[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //绘制点标记
    if (indexPath.row==0) {
        AliMapViewDrawPinController *drawPinVC = [[AliMapViewDrawPinController alloc] init];
        drawPinVC.title = self.drawMarks[indexPath.row];
        [self.navigationController pushViewController:drawPinVC animated:YES];
    }
    
    //绘制折线
    if (indexPath.row==1) {
        AliMapViewDrawPolylineController *drawPolylineVC = [[AliMapViewDrawPolylineController alloc] init];
        drawPolylineVC.title = self.drawMarks[indexPath.row];
        [self.navigationController pushViewController:drawPolylineVC animated:YES];
    }
    
    //绘制面
    if (indexPath.row==2) {
        AliMapViewDrawSurfaceController *drawSurfaceVC = [[AliMapViewDrawSurfaceController alloc] init];
        drawSurfaceVC.title = self.drawMarks[indexPath.row];
        [self.navigationController pushViewController:drawSurfaceVC animated:YES];
    }
}

@end
