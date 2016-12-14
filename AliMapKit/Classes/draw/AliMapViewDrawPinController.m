//
//  AliMapViewDrawPinController.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import "AliMapViewDrawPinController.h"
#import "AliMapViewDrawPinDefalutPointController.h"
#import "AliMapViewDrawPinCustomPointController.h"
#import "AliMapViewDrawCustomAnnotationController.h"

@interface AliMapViewDrawPinController ()
@property (strong,nonatomic)NSMutableArray *drawPins;
@end

@implementation AliMapViewDrawPinController

-(NSMutableArray *)drawPins{
    if (!_drawPins) {
        _drawPins = [NSMutableArray arrayWithObjects:@"添加默认样式点标记",@"添加自定义样式点标记",@"添加自定义AnnotationView",nil];
    }
    return _drawPins;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.drawPins.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuserIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.drawPins[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //添加默认样式点标记
    if (indexPath.row==0) {
        AliMapViewDrawPinDefalutPointController *defalutPointVC = [[AliMapViewDrawPinDefalutPointController alloc] init];
        defalutPointVC.title = self.drawPins[indexPath.row];
        [self.navigationController pushViewController:defalutPointVC animated:YES];
    }
    
    //添加自定义样式点标记
    if (indexPath.row==1) {
        AliMapViewDrawPinCustomPointController *customPointVC = [[AliMapViewDrawPinCustomPointController alloc] init];
        customPointVC.title = self.drawPins[indexPath.row];
        [self.navigationController pushViewController:customPointVC animated:YES];
    }
    
    //添加自定义AnnotationView(包括气泡和大头针)
    if (indexPath.row==2) {
        AliMapViewDrawCustomAnnotationController *annotationVC = [[AliMapViewDrawCustomAnnotationController alloc] init];
        annotationVC.title = self.drawPins[indexPath.row];
        [self.navigationController pushViewController:annotationVC animated:YES];
    }
}

@end
